---
layout: post
title: Guías para los Trabajo Prácticos
permalink: /trabajos-practicos
author: admin
date: 21/08/2010
snippets: none

---

  <ul class="post-list">
    {% for post in site.pages %}
      {% if post.tags contains 'Trabajos Prácticos' %}
      <li>
        <h2>
          <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
        </h2>
        {% assign date_format = site.minima.date_format | default: "%b %-d, %Y" %}
        <span class="post-meta">{{ post.date | date: date_format }}</span>

      </li>
      {% endif %}
    {% endfor %}
  </ul>
