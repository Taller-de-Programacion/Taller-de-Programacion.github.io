---
layout: post
title: Rastreo de valor no inicializado
author: admin
date: 30/03/2011
snippets: 
    - |
        ```cpp
        #include <stdio.h>
         int foo(int x)
        {
         if(x < 10)
         {
         printf("x is less than 10\n");
         }
        }
         int main(int argc, char ** argv)
        {
         int y;
         foo(y);
          return 0;
        }
        ```

---
<div class="entry-content">
						<p>Valgrind, entre otros, reporta errores por la utilización de valores no inicializados.</p>
<p>valgrind_init.c</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
<p>Si compilamos y ejecutamos este código tendremos un comportamiento indeterminado porque dentro de la función <strong>foo()</strong> se condiciona la ejecución del <strong>printf()</strong> según el valor del argumento. Que es una copia del valor de la variable <strong>y</strong> de la función <strong>main()</strong> y que nunca se inicializó.</p>
<p>Al ejecutar con valgrind este programa recibimos un reporte de error del estilo:</p>
<pre>==14252== Memcheck, a memory error detector
==14252== Copyright (C) 2002-2010, and GNU GPL'd, by Julian Seward et al.
==14252== Using Valgrind-3.6.0.SVN-Debian and LibVEX; rerun with -h for copyright info
==14252== Command: ./a.out
==14252==
==14252== Conditional jump or move depends on uninitialised value(s)
==14252==&nbsp;&nbsp;&nbsp; at 0x80483CE: foo (valgrind_init.c:5)
==14252==&nbsp;&nbsp;&nbsp; by 0x80483F2: main (valgrind_init.c:14)</pre>
<p>El salto condicional en función de un valor no inicializado es reportado en la línea cinco, es decir la condición dentro de la función <strong>foo()</strong>. Pero el valor no inicializado está en la línea trece de <strong>main()</strong> donde se declara <strong>y</strong> sin ser inicializada antes de la llamada a <strong>foo()</strong>. La ubicación del error real debe ser deducida por el programador. En este código trivial resulta muy simple, pero cuando se trabaja con matrices y memoria dinámica suele complicarse un poco más.</p>
<p>Afortunadamente desde la versión 3.4.0 de valgrind existe una nueva opción para que se realice el rastreo del origen del problema de falta de inicialización. Se debe pasar como parámetro a valgrind la opción <strong>–track-origins=yes</strong> que se traduce en la siguiente salida:</p>
<pre>==14281== Memcheck, a memory error detector
==14281== Copyright (C) 2002-2010, and GNU GPL'd, by Julian Seward et al.
==14281== Using Valgrind-3.6.0.SVN-Debian and LibVEX; rerun with -h for copyright info
==14281== Command: ./a.out
==14281==
==14281== Conditional jump or move depends on uninitialised value(s)
==14281==&nbsp;&nbsp;&nbsp; at 0x80483CE: foo (valgrind_init.c:5)
==14281==&nbsp;&nbsp;&nbsp; by 0x80483F2: main (valgrind_init.c:14)
==14281==&nbsp; Uninitialised value was created by a stack allocation
==14281==&nbsp;&nbsp;&nbsp; at 0x80483E4: main (valgrind_init.c:12)</pre>
<p>Ahora valgrind indica que el problema está en la línea doce. Y aclara que se produce por la asignación de memoria del stack (la pila) que no ha sido inicializada. Posiblemente se haya esperado que el error fuera reportado en la línea trece. Pero valgrind no conoce el lenguaje origen del programa analizado. Sino que utiliza el binario final. Y en el mismo las declaraciones de variables locales se traducen en la utilización (la reserva) de memoria en la pila. Y es por eso que la línea indicada es justamente el inicio de la función cuya pila contiene la memoria que se utilizó sin inicializarse.</p>
											</div>
