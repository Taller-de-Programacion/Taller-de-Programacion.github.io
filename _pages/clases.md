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

<div class="table-responsive">
<table class="table table-striped table-condensed">
<thead>
  <tr>
    <th class="col-md-1">Fecha</th>
    <th>Temas</th>
    <th>Trabajos Prácticos</th>
  </tr>
</thead>
<tbody id="lectures-table">
</tbody>
</table>
</div>

### Apuntes de otros cuatrimestres

<ul>
<li><a href="http://www.drk.com.ar/docs/development/conociendo_gdb.php">Tutorial de GDB (Leandro Fernández)</a></li>

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
    node.className = "list-unstyled";
    array.forEach(function(el) {
        var item = document.createElement("li");
        item.innerHTML = el;
        node.appendChild(item);
    });
    return node;
}

createListOfLinks = function(array) {
    var node = document.createElement("ul");
    node.className = "list-unstyled";
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

        if ( today <= aDate && nextLectureFound === false ) {
            nextLectureFound = true;
            row.className = "info";

            var dateNode = document.createTextNode(date_to_string(aDate) + "  \n(próxima clase)");
        }
        else {
            var dateNode = document.createTextNode(date_to_string(aDate));
        }

        var linkSublist = createListOfLinks(lectures[i].links);
        var eventSublist = createList(lectures[i].events);

        row.appendChild(wrapCell(dateNode));
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
            ["Explicación TP 0"],
        links: [
             {
                name: "Introducción a la Materia (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/introduccion.pdf",
             },
             {
                name: "Memoria en C/C++ (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/memoria/bin/memoria-handout.pdf",
             },
             {
                name: "Proceso de Compilación (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/proceso_de_compilacion.pdf",
             },
             {
                name: "Proceso de Compilación (tutorial)",
                link: "https://github.com/Taller-de-Programacion/compilacion/tree/master/gcc",
             },
             {
                name: "Makefiles (tutorial)",
                link: "https://github.com/Taller-de-Programacion/compilacion/tree/master/make",
             }
        ],
    },
    {
        contents:
            ["Introducción a Sockets (3hs)", "Repaso de Archivos y TDAs (1h)"],
        events:
            ["Entrega TP 0", "Explicación TP 1"],
        links:
            [
             {
                name: "Introducción a sockets TCP en C (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/sockets-mdipaola/bin/sockets-handout.pdf",
             },
             {
                name: "Sockets TCP en C (ejemplos)",
                link: "https://github.com/Taller-de-Programacion/clases/tree/master/sockets-mdipaola/src",
             },
             {
                name: "Archivos (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/archivos.pdf",
             },
             {
                name: "TDAs (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/tipos_de_datos_abstractos.pdf",
             },
        ],
    },
    {
        contents:
            ["Clases, RAII, Move Semantics en C++ (2hs)", "Herencia y Polimorfismo en C++ (2hs)"],
        events:
            ["Corrección TP 0"],
        links:
            [
             {
                name: "struct y clases C++ (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/classes/bin/classes-handout.pdf",
             },
             {
                name: "Pasaje de objetos (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/moving/bin/moving-handout.pdf",
             },
             {
                name: "Herencia y Polimorfismo (handout)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/polimorfismo-handout.pdf",
             },
        ],
    },
    {
        contents:
            ["Introducción a Threads (4hs)"],
        events:
            ["Entrega TP 1", "Explicación TP 2"],
        links:
            [
             {
                name: "Threads en C++ (tutorial)",
                link: "https://github.com/Taller-de-Programacion/threads",
             },
             {
                name: "Recursos compartidos (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/shared-resources/bin/shared-resources-handout.pdf",
             },
             {
                name: "Introducción a Threads (presentación)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/introthreads/bin/introathreads-draft.pdf",
             },
        ]
    },
    {
        contents:
            ["Templates/STL (3h)", "Operadores en C++ (1h)"],
        events:
            ["Corrección TP 1"],
        links:
            [
             {
                name: "Templates (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/templates/bin/templates-handout.pdf",
             },
             {
                name: "STL (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/stl/bin/stl-handout.pdf",
             },
             {
                name: "Sobrecarga de Operadores (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/sobrecarga_de_operadores.pdf",
             },
         ],
    },
    {
        contents:
            ["Excepciones (1hs)", "Introducción a la Arquitectura Cliente-Servidor (2hs)", "Programación Orientada a Eventos (1hs)"],
        events:
            ["Reentrega TP 1", "Entrega TP 2", "Explicación TP 3"],
        links:
            [
             {
                name: "Manejo de Errores (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/manejodeerrores/bin/manejodeerrores-handout.pdf",
             },
             {
                name: "Cliente-Servidor (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/client_server_arch/bin/client_server_arch-handout.pdf",
             },
             {
                name: "Programación Orientada a Eventos (handout)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/poe-handout.pdf",
             },
             {
                name: "Programación Orientada a Eventos (2) (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/prog_orientada_a_eventos/bin/poe-handout.pdf",
             }
            ],
    },
    {
        contents:
            ["CMake (0.5h)", "SDL (1h)", "Qt5 (2.5h)"],
        events:
            ["Corrección TP 1", "Corrección TP 2", "Entrega TP 3"],
        links:
            [
             {
                name: "Bibliotecas GUI",
                link: "https://github.com/Taller-de-Programacion/clases/tree/feature/bibliotecas-gui/bibliotecas-gui",
             }
            ]
    },
    {
        contents:
            ["Sockets UDP (1hs)", "Features extra de C++ (1hs)", "Espacio para consultas (1hs)","Desarrollo de Trabajo Grupal"],
        events:
            ["Reentrega TP 2", "Corrección TP 3", "Explicación TP Final"],
        links:
            [
             {
                name: "Introducción a Sockets UDP en C (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/introduccion_sockets_udp.pdf",
             },
             {
                name: "Extra C++",
                link: "https://github.com/Taller-de-Programacion/clases/tree/master/cpp-misc",
             }
            ]
    },
    {
        contents:
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Corrección TP 2", "Reentrega TP 3"],
        links:
            [],
    },
    {
        contents:
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Corrección TP 3"],
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
            ["Entrega TP Final"],
        links:
            [],
    },
    {
        contents:
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Corrección TP Final"],
        links:
            [],
    },
    {
        contents:
            ["Desarrollo de Trabajo Grupal"],
        events:
            ["Reentrega TP Final"],
        links:
            [],
    },
];

fillLecturesTable(new Date("{{ site.current_quater }}"), lectures);
</script>


