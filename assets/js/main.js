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

function setEmailLinks(email){
  document.querySelectorAll("[data-email]").forEach(el => {
    el.textContent = email;
    el.href = "mailto:" + email;
  });
}

async function initCommon(){
  try{
    const links = await loadJSON("assets/data/links.json");
    if(links.email) setEmailLinks(links.email);

    const setLink = (id, url) => {
      const a = document.getElementById(id);
      if(!a) return;
      if(!url){
        a.style.display = "none";
        return;
      }
      a.href = url;
    };
    setLink("scholarLink", links.scholar);
    setLink("orcidLink", links.orcid);
    setLink("githubLink", links.github);
    setLink("linkedinLink", links.linkedin);

  }catch(e){
    // no-op
  }
}

document.addEventListener("DOMContentLoaded", initCommon);
