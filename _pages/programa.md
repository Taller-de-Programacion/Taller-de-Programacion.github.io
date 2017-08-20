---
layout: post
title: Programa
permalink: /programa
---
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



nextweek = function (aDate){
    return new Date(aDate.getTime() + 7 * 24 * 60 * 60 * 1000);
}

date_to_string = function (aDate) {
    return aDate.getDate() + '/' + (aDate.getMonth() + 1) + '/' + aDate.getFullYear();
}

fillLecturesTable = function(initial_date, lectures) {
    var table = document.getElementById("lectures-table");
    var aDate = initial_date;
    for (i = 0; i < lectures.length; i++) {
        var row = document.createElement("tr");
        var dateNode = document.createTextNode(date_to_string(aDate));
        var contentSublist = createList(lectures[i].contents);
        var eventSublist = createList(lectures[i].events);

        row.appendChild(wrapCell(dateNode));
        row.appendChild(wrapCell(contentSublist));
        row.appendChild(wrapCell(eventSublist));

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
    },
    {
        contents: 
            ["Introducción a Threads (2hs)", "Introducción a Sockets (2hs)"],
        events:
            ["Ejercicio 0 - Entrega", "Ejercicio 1 - Explicación (C)"],
    },
    {
        contents: 
            ["C++ (4hs)"],
        events:
            ["Ejercicio 0 - Dev. Entrega"],
    },
    {
        contents: 
            ["Buenas prácticas con Threads (2hs)", "Buenas prácticas con Sockets (2hs)"],
        events:
            ["Ejercicio 1 - Entrega 1", "Ejercicio 2 - Explicación (C++)"],
    },
    {
        contents: 
            ["C++ (4hs)"],
        events:
            ["Ejercicio 1 - Dev. Entrega 1"],
    },
    {
        contents: 
            ["C++ (4hs)"],
        events:
            ["Ejercicio 1 - Entrega 2", "Ejercicio 2 - Entrega 1", "Ejercicio 3 - Explicación (C++)"],
    },
    {
        contents: 
            ["Templates/STL (3h)", "Excepciones (1hs)"],
        events:
            ["Ejercicio 1 - Dev. Entrega 2", "Ejercicio 2 - Dev. Entrega 1"],
    },
    {
        contents: 
            ["GTK+ (1h)", "gtkmm (3hs)"],
        events:
            ["Ejercicio 2 - Entrega 2", "Ejercicio 3 - Entrega 1"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 2 - Dev. Entrega 2", "Ejercicio 3 - Dev. Entrega 1", "Ejercicio final - Explicación (C++)"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 3 - Entrega 2"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio 3 - Dev. Entrega 2"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            [],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Pre-entrega"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Dev. Pre-entrega"],
    },
    {
        contents: 
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Ejercicio final - Entrega"]
    },
];

fillLecturesTable(new Date("2017/08/15"), lectures);
</script>

**NOTA**: Este cuadro contiene duraciones de cada clase a modo orientativo.

