---
layout: archive
title: "Team"
permalink: /team/
author_profile: false
---

<style>
ul li {
  margin-bottom: 0.5em;
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
