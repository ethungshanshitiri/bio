async function loadJSON(path){
  const res = await fetch(path, {cache: "no-store"});
  if(!res.ok) throw new Error("Failed to load " + path);
  return await res.json();
}

function escapeHTML(str){
  return str.replace(/[&<>"']/g, (m) => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
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
    out = out.replace(re, "<strong>" + v + "</strong>");
  });
  return out;
}

function doiLink(doi){
  if(!doi) return "";
  const url = "https://doi.org/" + doi;
  return ` <a class="doi" href="${url}" target="_blank" rel="noopener">${doi}</a>`;
}

function groupByYear(list){
  const groups = new Map();
  list.forEach(p => {
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

function render(list){
  const root = document.getElementById("pubList");
  root.innerHTML = "";

  const grouped = groupByYear(list);
  grouped.forEach(([year, items]) => {
    const sec = document.createElement("section");
    sec.className = "pubYear";

    const h = document.createElement("h2");
    h.textContent = year;
    sec.appendChild(h);

    const ul = document.createElement("ol");
    ul.className = "pubOl";

    items.forEach(p => {
      const li = document.createElement("li");
      const safe = escapeHTML(p.text);
      li.innerHTML = highlightName(safe) + doiLink(p.doi);
      ul.appendChild(li);
    });

    sec.appendChild(ul);
    root.appendChild(sec);
  });
}

function applyFilters(all){
  const q = (document.getElementById("q").value || "").toLowerCase().trim();
  const type = document.getElementById("type").value;

  let list = all;
  if(type !== "All"){
    list = list.filter(p => p.type === type);
  }
  if(q){
    list = list.filter(p => (p.text || "").toLowerCase().includes(q));
  }
  render(list);
}

async function init(){
  const all = await loadJSON("assets/data/publications.json");
  window.__pubs = all;

  render(all);

  document.getElementById("q").addEventListener("input", () => applyFilters(all));
  document.getElementById("type").addEventListener("change", () => applyFilters(all));
}

document.addEventListener("DOMContentLoaded", init);
