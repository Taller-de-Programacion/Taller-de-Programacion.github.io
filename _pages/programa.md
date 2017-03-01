---
layout: page
title: Programa
permalink: /programa
---
# Programa

A continuación se muestra un programa **orientativo** de la materia.

Se suponen conocidos los conceptos básicos de C. Sólo se darán los conceptos más importantes y previamente se hará un repaso general.

Asimismo se pueden descargar clases en fomato PDF pertenecientes a cuatrimestres anteriores como referencia. Es muy recomendable tener los textos en las clases para tomar nota sobre los mismos. Aunque no se garantiza que cada clase se dará según los apuntes aquí publicados, los contenidos principales no varían sustancialmente.

## Apuntes por Tema (PDF)

* [Introducción a la Materia](/wp-content/uploads/2010/08/clase_1_introduccion.pdf)

* Lenguaje C
    * [Parte 1 – Fundamentos](/wp-content/uploads/2010/08/clase_1.pdf)
    * [Parte 2 – Memória dinámica](/wp-content/uploads/2010/08/clase_21.pdf)

* Threads
    * [Parte 1](/wp-content/uploads/2010/08/clase_4_threads_1.pdf)
    * [Ejemplo Encapsulación en C](/wp-content/uploads/2010/08/threads_ejemplo_encapsulacion.zip)

* Sockets
    * [Parte 1](/wp-content/uploads/2010/08/clase_sockets_1.pdf)
    * [Parte 2](/wp-content/uploads/2010/08/clase_sockets_2.pdf)

* Lenguaje C++
    * [Parte 1](/wp-content/uploads/2010/08/clase_3_cpp.pdf)
    * [Repaso – Verdadero o falso](/wp-content/uploads/2010/08/clase3.intro_.a.cpp_.repaso.verdadero.o.falso_.pdf)

* Templates
    * [Templates y STL](/wp-content/uploads/2010/08/clase_templates_y_stl.pdf)
    * [Templates en Detalle](/wp-content/uploads/2010/08/clase_5_templates.pdf)

* [Excepciones y manejo de recursos](/wp-content/uploads/2010/08/clase_6_excepciones.pdf)

* [GTK+ y programación orientada a eventos](/wp-content/uploads/2010/08/clase_7_gtk.pdf)

## Clases

<table id="lectures-table">
</table>

<script>
createList = function(array) {
    var node = document.createElement("ul");
    array.forEach(function(el) {
        var item = document.createElement("li");
        item.innerHTML = el;
        node.appendChild(item);
    });
    return node;
}

wrapCell = function (child) {
    var wrapper = document.createElement("td");
    wrapper.appendChild(child);
    return wrapper;
}

fillLecturesTable = function(dates, contents, events) {
    var table = document.getElementById("lectures-table");
    for (i = 0; i < 16; i++) {
        var row = document.createElement("tr");
        var dateNode = document.createTextNode(dates[i]);
        var contentSublist = createList(contents[i]);
        var eventSublist = createList(events[i]);
        row.appendChild(wrapCell(dateNode));
        row.appendChild(wrapCell(contentSublist));
        row.appendChild(wrapCell(eventSublist));
        table.appendChild(row);
    }
}

var dates = ["7/3/2017", "14/3/2017", "21/3/2017", "28/3/2017", "4/4/2017", "11/4/2017", "18/4/2017", "25/4/2017", "2/5/2017", "9/5/2017", "16/5/2017", "23/5/2017", "30/5/2017", "6/6/2017", "13/6/2017", "20/6/2017"];
var contents = [
    ["Introducción a la materia (1h)", "Conceptos de C avanzados (3hs)"],
    ["Introducción a Threads (2hs)", "Introducción a Sockets (2hs)"],
    ["C++ (4hs)"],
    ["Buenas prácticas con Threads (2hs)", "Buenas prácticas con Sockets (2hs)"],
    ["C++ (4hs)"],
    ["C++ (4hs)"],
    ["Templates/STL (3h)", "Excepciones (1hs)"],
    ["GTK+ (1h)", "gtkmm (3hs)"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"],
    ["Desarrollo de Trabajo Grupal"]
] 
var events = [
    ["Ejercicio 0 - Explicación (C)"],
    ["Ejercicio 0 - Entrega", "Ejercicio 1 - Explicación (C)"],
    ["Ejercicio 0 - Dev. Entrega"],
    ["Ejercicio 1 - Entrega 1", "Ejercicio 2 - Explicación (C++)"],
    ["Ejercicio 1 - Dev. Entrega 1"],
    ["Ejercicio 1 - Entrega 2", "Ejercicio 2 - Entrega 1", "Ejercicio 3 - Explicación (C++)"],
    ["Ejercicio 1 - Dev. Entrega 2", "Ejercicio 2 - Dev. Entrega 1"],
    ["Ejercicio 2 - Entrega 2", "Ejercicio 3 - Entrega 1"],
    ["Ejercicio 2 - Dev. Entrega 2", "Ejercicio 3 - Dev. Entrega 1", "Ejercicio final - Explicación (C++)"],
    ["Ejercicio 3 - Entrega 2"],
    ["Ejercicio 3 - Dev. Entrega 2"],
    [],
    [],
    ["Ejercicio final - Pre-entrega"],
    ["Ejercicio final - Dev. Pre-entrega"],
    ["Ejercicio final - Entrega"]
]

fillLecturesTable(dates, contents, events);
</script>

**NOTA**: Este cuadro contiene duraciones de cada clase a modo orientativo.

