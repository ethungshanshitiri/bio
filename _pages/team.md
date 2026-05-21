---
layout: archive
title: "Team"
permalink: /team/
author_profile: false
---

## Current
{% for name in site.data.team.current %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}

## Alumni
{% for student in site.data.team.alumni %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}
