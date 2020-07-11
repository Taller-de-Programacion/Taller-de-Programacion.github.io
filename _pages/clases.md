---
layout: main-topic-page
title: Clases
permalink: /clases
sidebar-include: sidebar-clases.html
main-col-sz: col-sm-9
sidebar-col-sz: col-sm-3
hide_post_meta: true
nav-clases: active

---

A continuación se muestra un programa **orientativo** de la materia.

Se suponen conocidos los conceptos básicos de C. Sólo se darán los
conceptos más importantes y previamente se hará un repaso general.

## Programa

<div class="table-responsive-sm">
<table class="table table-striped table-condensed">
<thead>
  <tr>
    <th class="col-md-1">Fecha</th>
    <th class="col-md-7">Temas</th>
    <th class="col-md-4">Trabajos Prácticos</th>
  </tr>
</thead>
<tbody id="lectures-table">
</tbody>
</table>
</div>

### Apuntes de otros cuatrimestres


* [Tutorial de GDB (Leandro Fernández)](http://www.drk.com.ar/docs/development/conociendo_gdb.php)

* [C - Fundamentos](/assets/apuntes_legacy/C - Fundamentos.pdf.7z)

* [C - Memoria](/assets/apuntes_legacy/C - Memoria.pdf.7z)

* [C++](/assets/apuntes_legacy/C++.pdf.7z)

* [C++ - Verdadero Falso](/assets/apuntes_legacy/C++ - Verdadero Falso.pdf.7z)

* [Manejo de Errores](/assets/apuntes_legacy/Manejo de Errores.pdf.7z)

* [Taller de Programacion (Gabriel Praino)](/assets/apuntes_legacy/TallerDeProgramacion_GabrielPraino.pdf.7z)

* [Sockets](/assets/apuntes_legacy/Sockets.pdf.7z)

* [Cliente-Servidor](/assets/apuntes_legacy/Cliente-Servidor.pdf.7z)

* [Templates](/assets/apuntes_legacy/Templates.pdf.7z)

* [Templates y STL](/assets/apuntes_legacy/Templates y STL.pdf.7z)

* [POSIX Threads](/assets/apuntes_legacy/POSIX Threads.pdf.7z)

* [GTK+ y Programacion Orientada a Eventos](/assets/apuntes_legacy/GTK+ y Programacion Orientada a Eventos.pdf.7z)

<script type="text/javascript">
    {% include clases.js %}
    fillLecturesTable(new Date("{{ site.current_quater }}"), lectures, {{ site.current_quater_holidays }});
</script>