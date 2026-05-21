---
layout: archive
title: ""
permalink: /team/
author_profile: false
---

<style>
.archive ul li {
  margin-bottom: 0 !important;
  line-height: 1.2;
}

.archive li ul,
.archive li ol {
  margin-top: 0 !important;
  line-height: 1;
}
</style>


**Current**
{% for student in site.data.team.current %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}

**Alumni**
{% for student in site.data.team.alumni %}
* {{ student.name }} ({{ student.degree }}, {{ student.year }})
{% endfor %}
