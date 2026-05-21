---
layout: archive
title: "Team"
permalink: /team/
author_profile: false
---

<style>
.archive ul li {
  margin-bottom: 0.1em !important;
}

.archive li ul,
.archive li ol {
  margin-top: 0.1em !important;
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
