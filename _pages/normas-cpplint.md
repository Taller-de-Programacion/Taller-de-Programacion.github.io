---
layout: post
title: Normas de Codificación – CPPLint
author: Pablo Roca
date: 21/08/2013
snippets: none
permalink: /normas-cpplint

---

Una de las buenas prácticas de programación más aceptadas es la adopción de normas o estándares de codificación dentro de ciertos entornos de trabajo.

La cátedra adopta para los trabajos prácticos individuales la guía de codificación propuesta por Google para sus herramientas y desarrollos públicos. Se entiende que dichas normas facilitan la lectura del código y generan buenas prácticas en los desarrolladores que las adoptan.

## Documentación y Script de Verificación

El detalle de las normas se puede encontrar en la guía de estilos provista por Google:

<ul>
<li><a href="https://code.google.com/p/google-styleguide/">Guía de Estilos de Google – Página Principal</a></li>
<li><a href="https://google.github.io/styleguide/cppguide.html">Guía de Estilos de Google – Normas para C++</a></li>
</ul>

A fin de verificar el cumplimiento de los estándares de codificación, se utiliza el sistema de ‘lint’ propuesto por Google, llamado <strong>Cpplint</strong>. Ciertas normas fueron relajadas según el criterio de la cátedra para permitir cierta flexibilidad al programador.

Antes de realizar una entrega, es necesario comprobar el cumplimiento de los estándares de la misma forma en que lo verifica el servidor. Por este motivo, se proveen los scripts utilizados por la cátedra:

<ul>
<li><a href="/assets/2013/08/cpplint.zip">Cpplint y Reglas de Codificación utilizadas por SERCOM</a></li>
</ul>

Una vez descargado el archivo Cpplint, se puede utilizar el script <strong>execute.sh</strong> para verificar las normas de todos los archivos de extensión .c,.cpp,.h,.hpp bajo la carpeta actual. Para ejecutar el script, es necesario asegurarse que se cuenta con un interprete bash apropiado. Existen dos formas de hacer esto:

<div>
<ol>
<li>Utilizar el comando <strong>bash</strong> e indicarle el archivo de script:
<ul>
<li>&gt; <strong>bash execute.sh &nbsp;</strong>o bien:</li>
<li><strong>&gt;</strong> <strong>sh execute.sh</strong></li>
</ul>
</li>
<li>Entregar al archivo los permisos de ejecución necesarios y agregar la ruta al comando bash en la cabecera:
<ul>
<li>Controlar que el comando <strong>bash</strong> se encuentre en <strong>/bin/bash</strong> y que esta ruta esté indicada en la cabecera de <strong>execute.sh</strong>:</li>
<li><strong>&gt; chmod +x execute.sh</strong></li>
<li><strong>./execute.sh</strong></li>
</ul>
</li>
</ol>
</div>

<div><span style="line-height: 24px;"><br>
</span></div>

## Normas Básicas y Ejemplos

Las normas de codificación básicas son:

<ul>
<li>Evitar líneas vacías a menos que se estén separando dos bloques de código con distinta funcionalidad.</li>
<li>Indentar el código siempre. Utilizar espacios cuando sea posible.</li>
<li>No abrir la llave de un bloque de código en una línea nueva.</li>
<li>Antes de una coma, no utilizar espacios. Luego de una coma, colocar un espacio.</li>
<li>Colocar un espacio entre cualquier operador y sus operandos.</li>
<li>No colocar espacios innecesarios entre paréntesis, tanto en expresiones de comparación como en pasaje de argumentos.</li>
<li>Colocar un espacio para separar la clausula de flujo (IF, WHILE, etc.) de la condición encerrada en paréntesis. Por el contrario, no hacerlo como separador entre nombre de función y sus argumentos o parámetros.</li>
<li>Los nombres de variables, funciones, métodos y clases deben ser claros y concisos.</li>
<li>Los nombres de archivos deben estar en minúscula y utilizar guión bajo ( _ ) como separador de palabras.</li>
<li>Los tipos y clases deben utilizar PascalCase como separador de palabras.</li>
<li>Las funciones y métodos deben utilizar camelCase como separador de palabras.</li>
<li>Las variables deben estar en minúscula y utilizar guión bajo ( _ ) como separador de palabras.</li>
<li>Los bloques condicionales IF/ELSE pueden o no incluir llaves pero su empleo debe ser consistente dentro de un mismo bloque.</li>
</ul>

Los siguientes extractos de código muestran un ejemplo de uso correcto e incorrecto de las normas:

<table>
<tbody>
<tr>
<td>CORRECTO</td>
<td>INCORRECTO</td>
</tr>
<tr>
<td>
<pre>#include &lt;stdio.h&gt;
int main(int argc, char* argv[]) {
    if (argc &gt; 1) {
        printf("Hola %s\n", argv[1]);
    } else {
        printf("Hola Mundo\n");
    }
    return 0;
}</pre>
</td>
<td>
<pre>#include &lt;stdio.h&gt;
int main(int argc, char* argv[]) {
    if (argc&gt;1) {
        printf("Hola %s\n", argv[1]);
    }
    else

        printf("Hola Mundo\n");
    return 0;

}</pre>
</td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr>
<td>CORRECTO</td>
<td>INCORRECTO</td>
</tr>
<tr>
<td>
<pre>#include &lt;stdio.h&gt;

void imprimirSaludo(char* nombre_usuario) {
    printf("Hola %s\n", nombre_usuario);
}

void imprimirSaludoGenerico() {
    printf("Hola Mundo\n");
}

int main(int argc, char* argv[]) {
    if (argc &gt; 1)
        imprimirSaludo(argv[1]);
    else
        imprimirSaludoGenerico();
    return 0;
}</pre>
</td>
<td>
<pre>#include &lt;stdio.h&gt;

void imprimirSaludo(char* nombreUsuario)
{

    printf("Hola %s\n",nombreUsuario);
}

void imprimir_saludo_generico()
{

    printf("Hola Mundo\n");
}

int main(int argc,char* argv[])
{
    if (argc &gt; 1)
        imprimirSaludo( argv[1] );
    else
        imprimir_saludo_generico ();
    return 0 ;
}</pre>
</td>
</tr>
</tbody>
</table>

A fines prácticos, se incluye el detalle de las normas utilizadas por el script. Cada regla es respaldada por la <a href="https://google.github.io/styleguide/cppguide.html">documentación provista en las guías de codificación</a>:

<ul>
<li>build/class</li>
<li>build/deprecated</li>
<li>build/include_what_you_use</li>
<li>build/namespaces</li>
<li>build/printf_format</li>
<li>readability/braces</li>
<li>readability/check</li>
<li>readability/fn_size</li>
<li>readability/function</li>
<li>readability/multiline_comment</li>
<li>readability/multiline_string</li>
<li>readability/utf8</li>
<li>runtime/arrays</li>
<li>runtime/casting</li>
<li>runtime/explicit</li>
<li>runtime/init</li>
<li>runtime/invalid_increment</li>
<li>runtime/memset</li>
<li>runtime/operator</li>
<li>runtime/printf</li>
<li>runtime/printf_format</li>
<li>runtime/rtti</li>
<li>runtime/string</li>
<li>runtime/threadsafe_fn</li>
<li>whitespace/blank_line</li>
<li>whitespace/empty_loop_body</li>
<li>whitespace/ending_newline</li>
<li>whitespace/line_length</li>
<li>whitespace/newline</li>
<li>whitespace/parens</li>
<li>whitespace/semicolon</li>
</ul>
