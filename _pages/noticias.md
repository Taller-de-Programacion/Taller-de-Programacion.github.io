---
# This is just an alias of index.md
layout: post
title: Noticias
permalink: /noticias
---
  <ul class="post-list">
    {% for post in site.posts %}
      {% if post.tags contains 'Noticias' %}
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
