---
layout: post
title: Noticias
permalink: /noticias
hide_post_meta: true

---
  <ul class="post-list">
    {% for post in site.posts %}
      {% if post.tags contains 'Noticias' %}
      <li>
        <h2>
          <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
        </h2>
        <div class="post-meta">
            <div>
                {% assign date_format = site.minima.date_format | default: "%b %-d, %Y" %}
                <span class="post-meta">{{ post.date | date: date_format }} por {{ post.author | default: 'admin' }}</span>
            </div>
            {% if post.tags != empty and post.tags != black and post.tags != false %}
            <div>
                <span>Tags: </span>
                {% for tag in post.tags %}
                <span>{{ tag }} </span>
                {% endfor %}
            </div>
            {% endif %}
        </div>
      </li>
      {% endif %}
    {% endfor %}
  </ul>
