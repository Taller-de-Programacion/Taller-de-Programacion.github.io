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
        while (findDate(aDate, holidays) != -1) {
           var row = document.createElement("tr");

           var dateText = date_to_string(aDate);
           dateText += "  \n(feriado)";
           var dateNode = document.createTextNode(dateText);

           var no_class_msj = document.createElement("div");
           no_class_msj.innerHTML = "No se dictan clases";
           var eventSublist = createList(lectures[event_ix].events);

           row.appendChild(wrapCell(dateNode, {class: "col-md-1"}));
           row.appendChild(wrapCell(no_class_msj, {class: "col-md-7"}));
           row.appendChild(wrapCell(eventSublist, {class: "col-md-4"}));

           table.appendChild(row);

           event_ix += 1;
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
            ["Explicación TP", "Explicación Onboarding"],
        links: [
             {
                name: "Introducción a la Materia (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/introduccion.pdf",
             },
             {
                name: "Onboarding (enunciado)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/onboarding.pdf",
             },
             {
                name: "Memoria en C/C++ (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/memoria/bin/memoria-handout.pdf",
             },
             {
                name: "Buffer overflow (código)",
                link: "https://github.com/eldipa/taller-clases/tree/master/memoria/src/cookie-buffer-overflow",
             },
             {
                name: "Java más rápido que C (código)",
                link: "https://github.com/eldipa/taller-clases/tree/master/memoria/src/java-faster-than-c",
             }
        ],
    },
    {
        events:
            ["Disponible cuestionario recap de Socket"],
        links:
            [
             {
                name: "Sockets TCP/IP (slides + handout)",
                link: "https://taller-de-programacion.github.io/sockets-presentation",
             },
             {
                name: "Hands On Sockets TCP/IP en C++",
                link: "https://github.com/eldipa/hands-on-sockets-in-cpp",
             },
             {
                name: "struct y clases C++ (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/classes/bin/struct_and_classes-handout.pdf",
             }
        ],
    },
    {
        events:
            ["Entrega final Onboarding", "Explicación TP (parte sockets)"],
        links:
            [
             {
                name: "RAII C++ (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/classes/bin/raii-handout.pdf",
             },
             {
                name: "Const y Member Initialization List (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/classes/bin/const-handout.pdf",
             },
             {
                name: "Pasaje y asignacion de objetos (Move Semantics) (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/moving/bin/moving-handout.pdf",
             }
        ],
    },
    {
        events:
            ["Entrega obligatoria TP (parte sockets) y recaps"],
        links:
            [
             {
                name: "Manejo de Errores (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/manejodeerrores/bin/manejodeerrores-handout.pdf",
             },
             {
                name: "Introducción a Threads (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2022/threads.pdf",
             },
             {
                name: "Hands On Threads en C++",
                link: "https://github.com/eldipa/hands-on-threads",
             }
        ]
    },
    {
        events:
            ["Devolucion de correcciones", "Disponible cuestionario recap de Threads"],
        links:
            [
             // {
             //    name: "Threads en C++ (tutorial - Lafroce)",
             //    link: "https://github.com/Taller-de-Programacion/threads",
             // },
             {
                name: "Recursos compartidos (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/shared-resources/bin/shared-resources-handout.pdf",
             },
             {
                name: "Queues Thread Safe",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2022/queues.pdf",
             }
             // {
             //    name: "Recursos compartidos (handout - Di Paola)",
             //    link: "https://github.com/eldipa/taller-clases/raw/master/shared-resources/bin/shared-resources-handout.pdf",
             // },
             // {
             //    name: "Introducción a Threads (presentación - Di Paola)",
             //    link: "https://github.com/Taller-de-Programacion/clases/raw/master/introthreads/bin/introathreads-draft.pdf",
             // },
             // {
             //    name: "Cliente-Servidor (handout - Di Paola)",
             //    link: "https://github.com/Taller-de-Programacion/clases/raw/master/client_server_arch/bin/client_server_arch-handout.pdf",
             // },
         ],
    },
    {
        events:
            ["Entrega final TP (parte sockets)", "Explicación TP (parte threads)"],
        links:
            [
             {
                name: "Cliente-Servidor (slides)",
                link: "https://github.com/eldipa/taller-clases/raw/master/client_server_arch/bin/client_server_arch.pdf",
             },
             {
                name: "Cliente-Servidor (handout)",
                link: "https://github.com/eldipa/taller-clases/raw/master/client_server_arch/bin/client_server_arch-handout.pdf",
             }
            ],
    },
    {
        events:
            ["Entrega obligatoria TP (parte threads) y recaps"],
        links:
            [
             {
                name: "Herencia y Polimorfismo (handout)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/polimorfismo-handout.pdf",
             },
             {
                name: "Herencia y Polimorfismo (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/herencia_y_polimorfismo.pdf",
             },
             {
                name: "Sobrecarga de Operadores (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/sobrecarga_de_operadores.pdf",
             },
            ]
    },
    {
        events:
            ["Devolucion de correcciones"],
        links:
            [
             {
                name: "Bibliotecas GUI",
                link: "https://github.com/Taller-de-Programacion/clases/tree/feature/bibliotecas-gui/bibliotecas-gui",
             },
             {
                name: "Programación Orientada a Eventos (handout)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2020/poe-2020.pdf",
             },
             {
                name: "Programación Orientada a Eventos (2) (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/prog_orientada_a_eventos/bin/poe-handout.pdf",
             }
            ]
    },
    {
        events:
            ["Entrega final TP (parte threads)", "Explicación TP (parte grupal)"],
        links:
            [
             {
                name: "Makefiles & CMake",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2022/cmake.pdf"
             }
            ],
    },
    {
        events:
            [],
        links:
            [
             {
                name: "Namespaces, friends and smart pointers (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/namespaces_friends_smart_pointers.pdf",
             }
            ],
    },
    {
        events:
            [],
        links:
            [
             {
                name: "Introducción a Sockets UDP en C (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/introduccion_sockets_udp.pdf",
             }
            ],
    },
    {
        events:
            [],
        links:
            [
             {
                name: "Templates (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/templates/bin/templates-handout.pdf",
             },
             {
                name: "Templates (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/templates.pdf",
             }
            ],
    },
    {
        events:
            [],
        links:
            [],
    },
    {
        events:
            ["Entrega obligatoria TP (parte grupal)"],
        links:
            [],
    },
    {
        events:
            ["Devolucion de correcciones"],
        links:
            [],
    },
    {
        events:
            [
              "Reentrega final TP (parte grupal)",
              "Examen oral sobre el TP",
            ],
        links:
            [],
    },
];


/*

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
             {
                name: "Archivos (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/archivos.pdf",
             },
             {
                name: "TDAs (presentación)",
                link: "https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io/raw/master/assets/2018/tipos_de_datos_abstractos.pdf",
             },
             {
                name: "STL (handout)",
                link: "https://github.com/Taller-de-Programacion/clases/raw/master/stl/bin/stl-handout.pdf",
             },
             {
                name: "Extra C++",
                link: "https://github.com/Taller-de-Programacion/clases/tree/master/cpp-misc",
             }
*/
