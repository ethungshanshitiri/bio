---
layout: archive
title: ""
permalink: /team/
author_profile: false
---

<style>
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
