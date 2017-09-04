---
layout: post
title: Programa
permalink: /programa
hide_post_meta: true

---
A continuación se muestra un programa **orientativo** de la materia.

Se suponen conocidos los conceptos básicos de C. Sólo se darán los conceptos más importantes y previamente se hará un repaso general.

## Clases

<table class="table table-striped">
<thead>
  <tr>
    <th>Fecha</th>
    <th>Temas</th>
    <th>Recursos</th>
    <th>Trabajos Prácticos</th>
  </tr>
</thead>
<tbody id="lectures-table">
</tbody>
</table>

**NOTA**: Este cuadro contiene duraciones de cada clase a modo orientativo.


### Apuntes de otros cuatrimestres

<ul>
<li><a href="/assets/apuntes_legacy/C - Fundamentos.pdf.7z">C - Fundamentos</a></li>
<li><a href="/assets/apuntes_legacy/C - Memoria.pdf.7z">C - Memoria</a></li>

<li><a href="/assets/apuntes_legacy/C++.pdf.7z">C++</a></li>
<li><a href="/assets/apuntes_legacy/C++ - Verdadero Falso.pdf.7z">C++ - Verdadero Falso</a></li>
<li><a href="/assets/apuntes_legacy/Manejo de Errores.pdf.7z">Manejo de Errores</a></li>

<li><a href="/assets/apuntes_legacy/TallerDeProgramacion_GabrielPraino.pdf.7z">Taller de Programacion (Gabriel Praino)</a></li>

<li><a href="/assets/apuntes_legacy/Sockets.pdf.7z">Sockets</a></li>
<li><a href="/assets/apuntes_legacy/Cliente-Servidor.pdf.7z">Cliente-Servidor</a></li>

<li><a href="/assets/apuntes_legacy/Templates.pdf.7z">Templates</a></li>
<li><a href="/assets/apuntes_legacy/Templates y STL.pdf.7z">Templates y STL</a></li>

<li><a href="/assets/apuntes_legacy/POSIX Threads.pdf.7z">POSIX Threads</a></li>

<li><a href="/assets/apuntes_legacy/GTK+ y Programacion Orientada a Eventos.pdf.7z">GTK+ y Programacion Orientada a Eventos</a></li>
</ul>

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
    var today = new Date();
    var nextLectureFound = false;
    var table = document.getElementById("lectures-table");
    var aDate = initial_date;

    for (var i = 0; i < lectures.length; i++) {
        var row = document.createElement("tr");

        if ( today < aDate && nextLectureFound === false ) {
            nextLectureFound = true;
            row.className = "info";
            
            var dateNode = document.createTextNode(date_to_string(aDate) + "  \n(próxima clase)");
        } 
        else {
            var dateNode = document.createTextNode(date_to_string(aDate));
        }

        var contentSublist = createList(lectures[i].contents);
        var linkSublist = createListOfLinks(lectures[i].links);
        var eventSublist = createList(lectures[i].events);

        row.appendChild(wrapCell(dateNode));
        row.appendChild(wrapCell(contentSublist));
        row.appendChild(wrapCell(linkSublist));
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
        links: [
             {  
                name: "Memoria en C/C++ (handout)", 
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/memoria/bin/memoria.7z",
             },
             {
                name: "Compilación (tutorial)", 
                link: "https://github.com/Taller-de-Programacion/compilacion",
             }
        ],
    },
    {
        contents: 
            ["Introducción a Sockets (3hs)", "Repaso de Archivos y TDAs (1h)"],
        events:
            ["Ejercicio 0 - Entrega", "Ejercicio 1 - Explicación (C)"],
        links:
            [
             {  
                name: "Introducción a sockets TCP en C (handout)", 
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/sockets/bin/sockets.7z",
             },
             {  
                name: "Sockets TCP en C (ejemplos)", 
                link: "https://github.com/Taller-de-Programacion/clases/tree/master/sockets/src",
             },
        ],
    },
    {
        contents: 
            ["Clases, RAII, Move Semantics en C++ (2hs)", "Herencia y Polimorfismo en C++ (2hs)"],
        events:
            ["Ejercicio 0 - Dev. Entrega"],
        links:
            [
             {  
                name: "struct y clases C++ (handout)", 
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/classes/bin/classes.7z",
             },
             {  
                name: "Pasaje de objetos (handout)", 
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/moving/bin/moving.7z",
             },
        ],
    },
    {
        contents: 
            ["Introducción a Threads (4hs)"],
        events:
            ["Ejercicio 1 - Entrega 1", "Ejercicio 2 - Explicación (C++)"],
        links:
            [
             {  
                name: "Threads en C++ (tutorial)", 
                link: "https://github.com/Taller-de-Programacion/threads",
             },
        ]
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

