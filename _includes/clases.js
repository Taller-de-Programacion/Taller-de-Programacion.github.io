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

wrapCell = function (child, attributes) {
    const wrapper = document.createElement("td");
    wrapper.appendChild(child);
    if (attributes) {
        Object.entries(attributes).forEach(entry => wrapper.setAttribute(entry[0], entry[1]));
    }
    return wrapper;
}


nextweek = function (aDate, nweeks){
    nweeks = nweeks || 1;
    return new Date(aDate.getTime() + nweeks * 7 * 24 * 60 * 60 * 1000);
}

advanceToDayWeek = function (aDate) {
    // XXX README
    // We assume that aDate is on Monday. The classes take place
    // on Thuesdays so we need a +1 day.
    return new Date(aDate.getTime() + 1 * 24 * 60 * 60 * 1000);
}

date_to_string = function (aDate) {
    return aDate.getDate() + '/' + (aDate.getMonth() + 1) + '/' + aDate.getFullYear();
}

findDate = function (aDate, aListOfDates) {
    for (var i = 0; i < aListOfDates.length; ++i) {
        if (aDate*1 == aListOfDates[i]*1) {
            return i;
        }
    }
    return -1;
}

fillLecturesTable = function(initial_date, lectures, holidays) {
    var today = new Date((new Date()).toDateString()); // Today's date without time
    var nextLectureFound = false;
    var table = document.getElementById("lectures-table");
    var aDate = advanceToDayWeek(initial_date);
    var final_date = nextweek(initial_date, 16);

    for (var i = 0; i < holidays.length; i++) {
        holidays[i] = new Date(holidays[i]);
    }

    var event_ix = 0;
    for (var i = 0; i < lectures.length; i++) {
        //var skip = [];
        while (findDate(aDate, holidays) != -1) {
           var row = document.createElement("tr");

           var dateText = date_to_string(aDate);
           dateText "  \n(feriado)"
           var dateNode = document.createTextNode(dateText);

           var no_class_msj = document.createElement("div");
           no_class_msj.innerHTML = "No se dictan clases";
           var eventSublist = createList(lectures[event_ix].events);

           row.appendChild(wrapCell(dateNode, {class: "col-md-1"}));
           row.appendChild(wrapCell(no_class_msj, {class: "col-md-7"}));
           row.appendChild(wrapCell(eventSublist, {class: "col-md-4"}));

           table.appendChild(row);

           event_ix += 1;
           //skip.push(aDate);
           aDate = nextweek(aDate);
        }

        var row = document.createElement("tr");
        var dateText = "";
        if ( today <= aDate && nextLectureFound === false ) {
            nextLectureFound = true;
            row.className = "info";

            dateText += date_to_string(aDate) + "  \n(próxima clase)";
        }
        else {
            dateText += date_to_string(aDate);
        }

        /*
        if (skip.length >= 1) {
           dateText += "\n(";
           if (skip.length == 1) {
               dateText += date_to_string(skip[0]);
           }
           else if (skip.length == 2) {
               dateText += date_to_string(skip[0]);
               dateText += " y ";
               dateText += date_to_string(skip[1]);
           }
           else {
               dateText += "del " + date_to_string(skip[0]);
               dateText += " al " + date_to_string(skip[skip.length-1]);
           }
           dateText += " no hay clases)";
        }
        */

        var dateNode = document.createTextNode(dateText);

        var linkSublist = createListOfLinks(lectures[i].links);
        var eventSublist = createList(lectures[event_ix].events);
        event_ix += 1;

        row.appendChild(wrapCell(dateNode, {class: "col-md-1"}));
        row.appendChild(wrapCell(linkSublist, {class: "col-md-7"}));
        row.appendChild(wrapCell(eventSublist, {class: "col-md-4"}));

        table.appendChild(row);
        aDate = nextweek(aDate);
    }
}

var lectures = [
    {
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
        events:
            ["Entrega TP 0", "Explicación TP 1"],
        links:
            [
             {
                name: "Introducción a sockets TCP en C (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/sockets/bin/sockets-handout.pdf",
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
        events:
            ["Corrección TP 0"],
        links:
            [
             {
                name: "struct y clases C++ (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/classes/bin/classes-handout.pdf",
             },
             {
                name: "Pasaje de objetos (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/moving/bin/moving-handout.pdf",
             },
             {
                name: "Herencia y Polimorfismo (handout)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/polimorfismo-handout.pdf",
             },
        ],
    },
    {
        events:
            ["Reentrega TP 0", "Entrega TP 1", "Explicación TP 2"],
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
        events:
            ["Corrección TP 0", "Corrección TP 1"],
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
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2020/poe-2020.pdf",
             },
             {
                name: "Programación Orientada a Eventos (2) (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/prog_orientada_a_eventos/bin/poe-handout.pdf",
             }
            ],
    },
    {
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
        events:
            ["Corrección TP 2", "Reentrega TP 3"],
        links:
            [],
    },
    {
        events:
            ["Corrección TP 3"],
        links:
            [],
    },
    {
        events:
            [],
        links:
            [],
    },
    {
        events:
            [],
        links:
            [],
    },
    {
        events:
            ["Entrega TP Final"],
        links:
            [],
    },
    {
        events:
            ["Corrección TP Final"],
        links:
            [],
    },
    {
        events:
            ["Reentrega TP Final"],
        links:
            [],
    },
];
