async function loadJSON(path){
  const res = await fetch(path, {cache: "no-store"});
  if(!res.ok) throw new Error("Failed to load " + path);
  return await res.json();
}

function fmtDate(iso){
  try{
    const d = new Date(iso + "T00:00:00");
    return d.toLocaleDateString(undefined, {year:"numeric", month:"short", day:"2-digit"});
  }catch(e){
    return iso;
  }
}

async function init(){
  const items = await loadJSON("assets/data/news.json");
  const root = document.getElementById("newsList");
  if(!root) return;

  if(!items.length){
    root.innerHTML = "<p class='small'>No news yet. Edit assets/data/news.json.</p>";
    return;
  }

  root.innerHTML = "";
  items.sort((a,b)=> (a.date < b.date ? 1 : -1)).forEach(n => {
    const wrap = document.createElement("div");
    wrap.className = "newsItem";

    const d = document.createElement("div");
    d.className = "newsDate";
    d.textContent = fmtDate(n.date);
    wrap.appendChild(d);

    const t = document.createElement("p");
    t.className = "newsTitle";
    t.textContent = n.title;
    wrap.appendChild(t);

    if(n.detail){
      const det = document.createElement("p");
      det.className = "newsDetail";
      det.textContent = n.detail;
      wrap.appendChild(det);
    }

    root.appendChild(wrap);
  });
}

document.addEventListener("DOMContentLoaded", init);
