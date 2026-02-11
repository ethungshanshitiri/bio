async function loadJSON(path){
  const res = await fetch(path, {cache: "no-store"});
  if(!res.ok) throw new Error("Failed to load " + path);
  return await res.json();
}

function fmtPeriod(p){
  const start = p.start ? p.start : "";
  const end = p.end ? p.end : "";
  if(start && end) return start + " to " + end;
  return start || end || "";
}

function fmtGrant(p){
  if(!p.currency || !p.amount) return "";
  return p.currency + " " + p.amount;
}

async function init(){
  const items = await loadJSON("assets/data/projects.json");
  const root = document.getElementById("projectList");
  root.innerHTML = "";

  items.forEach(p => {
    const div = document.createElement("div");
    div.className = "proj";

    const h = document.createElement("h3");
    h.textContent = p.title;
    div.appendChild(h);

    const meta = document.createElement("div");
    meta.className = "projMeta";
    meta.textContent = [p.grantor, fmtPeriod(p), fmtGrant(p), p.role].filter(Boolean).join(" • ");
    div.appendChild(meta);

    if(p.summary){
      const s = document.createElement("div");
      s.className = "small";
      s.style.marginTop = "8px";
      s.textContent = p.summary;
      div.appendChild(s);
    }

    const raw = document.createElement("div");
    raw.className = "projSmall";
    raw.textContent = "Edit this project in assets/data/projects.json";
    div.appendChild(raw);

    root.appendChild(div);
  });
}

document.addEventListener("DOMContentLoaded", init);
