---
layout: page
title: Programa
permalink: /programa
---
# Programa

A continuación se muestra un programa **orientativo** de la materia.

Se suponen conocidos los conceptos básicos de C. Sólo se darán los conceptos más importantes y previamente se hará un repaso general.

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

