---
layout: post
title: Notas Técnicas
permalink: /notas-tecnicas
---
  <ul class="post-list">
    {% for post in site.posts %}
      {% unless post.tags contains 'Noticias' %}
      <li>
        <h2>
          <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
        </h2>
        {% assign date_format = site.minima.date_format | default: "%b %-d, %Y" %}
        <span class="post-meta">{{ post.date | date: date_format }}</span>

      </li>
      {% endunless %}
    {% endfor %}
  </ul>

