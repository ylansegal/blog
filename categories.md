---
layout: page
title: "Categories"
permalink: /categories/
---

<ul>
{% assign sorted_cats = site.categories | sort %}
{% for category in sorted_cats %}
  {% assign category_name = category | first %}
  {% for archive in site.archives %}
    {% if archive.type == "category" and archive.title == category_name %}
      <li>
        <a href="{{ archive.url | relative_url }}">{{ archive.title | escape }} ({{ category.last | size }})</a>
      </li>
    {% endif %}
  {% endfor %}
{% endfor %}
</ul>
