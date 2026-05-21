---
layout: archive
title: ""
permalink: /publications/
author_profile: false
---

{% include base_path %}

You can also find my research on [Google Scholar](https://scholar.google.co.kr/citations?user=pbAP-VQAAAAJ&hl=en).

{% assign publications = site.data.publications %}
{% assign journal_articles = publications | where: "section", "journal_articles" %}
{% assign book_chapters = publications | where: "section", "book_chapters" %}
{% assign conference_papers = publications | where: "section", "conference_papers" %}
{% assign preprints = publications | where: "section", "preprints" %}
{% assign other_publications = publications | where: "section", "other" %}

{% if journal_articles.size > 0 %}
**Journal Articles**
{% include publication-list.html items=journal_articles prefix="J" %}
{% endif %}

{% if book_chapters.size > 0 %}
**Book Chapters**
{% include publication-list.html items=book_chapters prefix="B" %}
{% endif %}

{% if conference_papers.size > 0 %}
**Conference Papers**
{% include publication-list.html items=conference_papers prefix="C" %}
{% endif %}

{% if preprints.size > 0 %}
**Preprints**
{% include publication-list.html items=preprints prefix="P" %}
{% endif %}

{% if other_publications.size > 0 %}
**Other Publications**
{% include publication-list.html items=other_publications prefix="O" %}
{% endif %}
