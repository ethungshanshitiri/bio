---
layout: archive
title: ""
permalink: /team/
author_profile: false
---

<style>
@media (min-width: 64em) {
  #main {
    max-width: none;
    margin-left: 2rem;
    margin-right: 2rem;
  }

  .archive {
    float: none;
    width: min(100%, 54rem);
    margin-left: 0;
    margin-right: auto;
    padding-left: 0;
    padding-right: 0;
  }
}

.team-heading {
  margin: 1rem 0 0.25rem;
}

.team-list {
  margin-top: 0;
  margin-bottom: 1rem;
}

.team-list li {
  line-height: 1.3;
  margin-bottom: 0.15rem;
}
</style>

<p class="team-heading"><strong>Current</strong></p>
<ul class="team-list">
{% for student in site.data.team.current %}
  <li>{{ student.name }} ({{ student.degree }}, {{ student.year }})</li>
{% endfor %}
</ul>

<p class="team-heading"><strong>Alumni</strong></p>
<ul class="team-list">
{% for student in site.data.team.alumni %}
  <li>{{ student.name }} ({{ student.degree }}, {{ student.year }})</li>
{% endfor %}
</ul>
