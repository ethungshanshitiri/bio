async function loadJSON(path){
  const res = await fetch(path, {cache: "no-store"});
  if(!res.ok) throw new Error("Failed to load " + path);
  return await res.json();
}

function escapeHTML(str){
  return str.replace(/[&<>"']/g, (m) => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
}

function keepAuthorNamesTogether(text){
  const splitMarkers = ["&quot;", "\"", "“"];
  let splitAt = text.length;
  splitMarkers.forEach(marker => {
    const idx = text.indexOf(marker);
    if(idx >= 0) splitAt = Math.min(splitAt, idx);
  });

  const authorSection = text.slice(0, splitAt)
    // Initial + surname, e.g. "A. Yadav"
    .replace(/\b([A-Z]\.)\s+([A-Z][A-Za-z-]+)/g, "$1&nbsp;$2")
    // First name + surname, e.g. "Tania Islam"
    .replace(/\b([A-Z][a-z]+)\s+([A-Z][A-Za-z-]+)/g, "$1&nbsp;$2");

  return authorSection + text.slice(splitAt);
}

function highlightName(text){
  const variants = [
    "Ethungshan Shitiri",
    "E. Shitiri",
    "E Shitiri"
  ];
  let out = text;
  variants.forEach(v => {
    const re = new RegExp(v.replace(".", "\\."), "g");
    out = out.replace(re, `<strong class="authorName">${v.replace(/ /g, "&nbsp;")}</strong>`);
  });
  return out;
}

function doiLink(doi){
  if(!doi) return "";
  const url = "https://doi.org/" + doi;
  return ` <a class="doi" href="${url}" target="_blank" rel="noopener">DOI ${doi}</a>`;
}


function typePrefix(t){
  if(t === "Journal") return "j";
  if(t === "Conference") return "c";
  if(t === "Book Chapter") return "b";
  return "x";
}

function assignNumbers(all){
  // Stable numbering per category. Oldest = 1, newest = largest.
  const byType = new Map();
  all.forEach(p => {
    const t = p.type || "Other";
    if(!byType.has(t)) byType.set(t, []);
    byType.get(t).push(p);
  });

  byType.forEach((arr, t) => {
    arr.sort((a,b) => {
      const ya = Number(a.year || 0);
      const yb = Number(b.year || 0);
      if(ya !== yb) return ya - yb;
      return String(a.text || "").localeCompare(String(b.text || ""));
    });
    const prefix = typePrefix(t);
    arr.forEach((p, idx) => {
      p._num = idx + 1;
      p._label = prefix + p._num;
    });
  });

  return all;
}

const TYPE_ORDER = ["Journal", "Conference", "Book Chapter"];

function groupByYear(items){
  const groups = new Map();
  items.forEach(p => {
    const y = p.year || "Unknown";
    if(!groups.has(y)) groups.set(y, []);
    groups.get(y).push(p);
  });
  return Array.from(groups.entries()).sort((a,b)=>{
    if(a[0]==="Unknown") return 1;
    if(b[0]==="Unknown") return -1;
    return Number(b[0]) - Number(a[0]);
  });
}

function renderByType(list, forceAllTypes){
  const root = document.getElementById("pubList");
  root.innerHTML = "";

  // Keep unknown types at the end, but still render them if present
  const presentTypes = Array.from(new Set(list.map(p => p.type || "Other")));
  const orderedTypes = [
    ...TYPE_ORDER.filter(t => presentTypes.includes(t)),
    ...presentTypes.filter(t => !TYPE_ORDER.includes(t))
  ];

  // Ensure the three requested categories always appear in the All view
  if(forceAllTypes){
    TYPE_ORDER.forEach(t => {
      if(!orderedTypes.includes(t)) orderedTypes.push(t);
    });
  }

  orderedTypes.forEach(t => {
    const items = list.filter(p => (p.type || "Other") === t);

    const sec = document.createElement("section");
    sec.className = "pubType";

    const h = document.createElement("h2");
    h.textContent = t + (items.length ? ` (${items.length})` : "");
    sec.appendChild(h);

    if(!items.length){
      const p = document.createElement("p");
      p.className = "muted";
      p.textContent = "No entries listed in this category yet.";
      sec.appendChild(p);
      root.appendChild(sec);
      return;
    }

    const grouped = groupByYear(items);
    grouped.forEach(([year, yearItems]) => {
      const yHead = document.createElement("h3");
      yHead.className = "pubYearHead";
      yHead.textContent = year;
      sec.appendChild(yHead);

      const ul = document.createElement("ol");
      ul.className = "pubOl";

      yearItems.forEach(p => {
        const li = document.createElement("li");
        const safe = keepAuthorNamesTogether(escapeHTML(p.text || ""));
        const label = escapeHTML(String(p._label || ""));
        li.innerHTML = `<span class="pubId">${label}</span>` + highlightName(safe) + doiLink(p.doi);
        ul.appendChild(li);
      });

      sec.appendChild(ul);
    });

    root.appendChild(sec);
  });
}

function applyFilters(all){
  const q = (document.getElementById("q").value || "").toLowerCase().trim();
  const type = document.getElementById("type").value;

  let list = all;
  if(type !== "All"){
    list = list.filter(p => (p.type || "Other") === type);
  }
  if(q){
    list = list.filter(p => (p.text || "").toLowerCase().includes(q));
  }
  renderByType(list, type === "All");
}

async function init(){
  const all = await loadJSON("assets/data/publications.json");
  assignNumbers(all);
  window.__pubs = all;

  renderByType(all, true);

  document.getElementById("q").addEventListener("input", () => applyFilters(all));
  document.getElementById("type").addEventListener("change", () => applyFilters(all));
}

document.addEventListener("DOMContentLoaded", init);
