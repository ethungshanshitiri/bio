---
layout: archive
title: "Team"
permalink: /team/
author_profile: false
---

## Ph.D.
{% for name in site.data.team.phd %}
* {{ name }}
{% endfor %}

## MS
{% for name in site.data.team.ms %}
* {{ name }}
{% endfor %}

## BS
{% for name in site.data.team.bs %}
* {{ name }}
{% endfor %}
