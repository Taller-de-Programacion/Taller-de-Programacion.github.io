---
layout: post
title: Programa
permalink: /programa
---
A continuación se muestra un programa **orientativo** de la materia.

Se suponen conocidos los conceptos básicos de C. Sólo se darán los conceptos más importantes y previamente se hará un repaso general.

## Clases

<table id="lectures-table">
  <tr>
    <th>Fecha</th>
    <th>Temas</th>
    <th>Recursos</th>
    <th>Trabajos Prácticos</th>
  </tr>

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

createListOfLinks = function(array) {
    var node = document.createElement("ul");
    array.forEach(function(el) {
        var item = document.createElement("li");
        var anchor = document.createElement("a");
        anchor.href = el.link;
        anchor.innerHTML = el.name;
        item.appendChild(anchor);
        node.appendChild(item);
    });
    return node;
}

wrapCell = function (child) {
    var wrapper = document.createElement("td");
    wrapper.appendChild(child);
    return wrapper;
}



nextweek = function (aDate){
    return new Date(aDate.getTime() + 7 * 24 * 60 * 60 * 1000);
}

date_to_string = function (aDate) {
    return aDate.getDate() + '/' + (aDate.getMonth() + 1) + '/' + aDate.getFullYear();
}

fillLecturesTable = function(initial_date, lectures) {
    var table = document.getElementById("lectures-table");
    var aDate = initial_date;

    for (var i = 0; i < lectures.length; i++) {
        var row = document.createElement("tr");
        var dateNode = document.createTextNode(date_to_string(aDate));
        var contentSublist = createList(lectures[i].contents);
        var linkSublist = createListOfLinks(lectures[i].links);
        var eventSublist = createList(lectures[i].events);

        row.appendChild(wrapCell(dateNode));
        row.appendChild(wrapCell(contentSublist));
        row.appendChild(wrapCell(linkSublist));
        row.appendChild(wrapCell(eventSublist));

        if ((i % 2) === 0) {    // even rows
            row.style.backgroundColor = "#eeeeee";
        }
        else {                  // odd rows
        }

        table.appendChild(row);
        aDate = nextweek(aDate);
    }
}

var lectures = [
    {
        contents: 
            ["Introducción a la materia (1h)", "Conceptos de C avanzados (3hs)"],
        events:
            ["Ejercicio 0 - Explicación (C)"],
        links:
            [{name: "Memoria en C/C++ (handout)", link: "https://github.com/Taller-de-Programacion/clases/raw/master/memoria/bin/memoria.7z"}],
    },
    {
        contents: 
            ["Introducción a Sockets (3hs)", "Repaso de Archivos y TDAs (1h)"],
        events:
            ["Ejercicio 0 - Entrega", "Ejercicio 1 - Explicación (C)"],
        links:
            [],
    },
    {
        contents: 
            ["Clases, RAII, Move Semantics en C++ (2hs)", "Herencia y Polimorfismo en C++ (2hs)"],
        events:
            ["Ejercicio 0 - Dev. Entrega"],
        links:
            [],
    },
    {
        contents: 
            ["Introducción a Threads (4hs)"],
        events:
            ["Ejercicio 1 - Entrega 1", "Ejercicio 2 - Explicación (C++)"],
        links:
            [],
    },
    {
        contents: 
            ["Templates/STL (3h)", "Operadores en C++ (1h)"],
        events:
            ["Ejercicio 1 - Dev. Entrega 1"],
        links:
            [],
    },
    {
        contents: 
            ["Excepciones (1hs)", "Introducción a la Arquitectura Cliente-Servidor (3hs)"],
        events:
            ["Ejercicio 1 - Entrega 2", "Ejercicio 2 - Entrega 1", "Ejercicio 3 - Explicación (C++)"],
        links:
            [],
    },
    {
        contents: 
            ["Sockets UDP (1hs)", "Programación Orientada a Eventos (3hs)"],
        events:
            ["Ejercicio 1 - Dev. Entrega 2", "Ejercicio 2 - Dev. Entrega 1"],
        links:
            [],
    },
    {
        contents: 
            ["GTK+ (1h)", "gtkmm (3hs)"],
        events:
            ["Ejercicio 2 - Entrega 2", "Ejercicio 3 - Entrega 1"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 2 - Dev. Entrega 2", "Ejercicio 3 - Dev. Entrega 1", "Ejercicio final - Explicación (C++)"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 3 - Entrega 2"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 3 - Dev. Entrega 2"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            [],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            [],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Pre-entrega"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Dev. Pre-entrega"],
        links:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Entrega"],
        links:
            [],
    },
];

fillLecturesTable(new Date("2017/08/15"), lectures);
</script>

**NOTA**: Este cuadro contiene duraciones de cada clase a modo orientativo.

