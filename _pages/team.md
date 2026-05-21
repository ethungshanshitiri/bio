---
layout: archive
title: "Team"
permalink: /team/
author_profile: false
---

<style>
.archive ul {
  list-style-position: inside;
  padding-left: 0;
}

.archive ul li {
  margin-bottom: 0 !important;
  line-height: 1.2;
}
</style>

## Current
{% for student in site.data.team.current %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}

## Alumni
{% for student in site.data.team.alumni %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}
