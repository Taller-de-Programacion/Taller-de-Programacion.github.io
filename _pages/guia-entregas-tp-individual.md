---
layout: main-topic-page
sidebar-include: sidebar-trabajos-practicos.html
title: Guía de Entregas – Trabajo Práctico Individual
permalink: /guia-entregas-tp-individual
author: admin
date: 20/08/2010
tags: [Trabajos Prácticos]
hide_post_meta: true
snippets: none

---
## Consideraciones acerca de los ejercicios semanales.

La entrega de los trabajos prácticos consta de tres partes:

 - la resolución del trabajo (<a href="/guia-entregas-tp-individual#CF">código fuente</a>)
 - el armado de un <a href="/guia-entregas-tp-individual#IF">informe</a>
 - y la publicación del código y del informe en un repositorio de Github y en el Sercom

Es muy importante leer esta guía de entrega completa para evitar inconvenientes
ya que todas las partes son necesarias para la corrección del trabajo.

Para el caso del trabajo práctico grupal existe <a href="/guia-entregas-tp-final" target="_self">una guía particular</a>.

<a name="CF"></a>
## Código fuente

Se requiere que el código fuente sea prolijo y contenga los
comentarios pertinentes.

Asimismo es obligatorio incluir sangría (<em>indent</em>) en el código
fuente con longitud de entre dos y cuatro espacios.

Se debe utilizar el conjunto de caracteres
<a href="http://es.wikipedia.org/wiki/UTF8" target="_blank">UTF-8</a>
para la codificación de los archivos que conforman el código fuente.

Nota: cuando el enunciado no mencione el tratamiento de errores,
el programa deberá retornar al sistema operativo cero en caso de
ejecución exitosa y uno ante una situación de error.
Si el alumno decidiera retornar varios código de error para
diferentes situaciones deberán enumerarlos en el informe.

<a name="IF"></a>
## Armado del Informe

El informe <strong>debe</strong> contener:

 - nombre y padrón
 - el link al repositorio de Github
 - una descripción de la resolución del trabajo
 - uno o varios diagramas que ayuden al lector a entender la solución
 - y opcionalmente aclaraciones del alumno.

El informe debe ser escrito en formato
[markdown](https://guides.github.com/features/mastering-markdown/)
y guardarse en el `README` del repositorio.

La descripción textual debe de ser de al menos una carilla donde se describa
un tema relevante relacionado con la solución del trabajo.

Puede tratarse de la forma en la que se solucionó el problema más
complejo que presentaba el ejercicio o una lista descriptiva de las
funciones o clases más importantes.

El o los diagramas deben graficar cómo esta constituido y/o resuelto
el ejercicio, con una breve descripción coloquial sólo de ser necesario.

Deben permitirle al lector entender las partes mas complejas del trabajo
y guiarlo en la solución.

Por ejemplo **no** tiene mucho sentido un diagrama completo de treinta clases
o un diagrama tan genérico que podría ser el diagrama de cualquier trabajo.

En cambio aporta información un gráfico que centra la atención en una
clase de alta importancia y aquellas relacionadas con la primera.

Se recomienda usar algunos de los diagramas UML. Use un generador
como [PlantUML](https://plantuml.com/) que son basados en texto
en vez de uno gráfico.

<strong>Nota: El diagrama aclaratorio es obligatorio para la aprobación de un trabajo práctico.</strong>

Finalmente las aclaraciones del alumno pueden contener,
en el caso excepcional en que no se haya cumplido con la totalidad
de los requerimientos de la entrega, explicación del por qué
y la justificación pertinente.

Esto no garantiza la aceptación de la excepción por parte de la cátedra,
pero es condición necesaria.

<a name="EE"></a>

## Entrega Electrónica

La entrega electrónica consta de subir el código fuente y
el informe a un repositorio privado en Github, realizar
un release y hacer una entrega en el Sercom
donde se realizaran las pruebas automáticas.

Una [guía](/guia-electronica) paso a paso esta disponible.

Recorda que el repositorio de Github solo debe
contener código C o C++ con extensiones .c, .cpp y .h y
el `README` (el informe)

**No** debe incluir:

 - Binarios, sean archivos objeto (.o), ejecutables u otros.
 - Carpetas
 - Archivos del sistema de control de versiones (típicamente .git, .svn)


## Corrección

Con el objetivo de lograr un criterio uniforme de corrección y calificación,
se estableció el siguiente modo de corrección:

Una vez comprobado que el trabajo práctico cumpla
(en forma parcial o total) el objetivo enunciado, se supondrá un
trabajo práctico perfecto (10 puntos) y se restarán puntos
por cada error encontrado, en base a una tabla general y
una particular para cada trabajo práctico.

Entre otros serán evaluados en los siguientes puntos generales:

<ul>
<li>Cumplimiento de los objetivos planteados</li>
<li>Código ordenado y eficiente</li>
<li>Documentación del código fuente</li>
<li>Claridad del informe del trabajo práctico</li>
<li>Presentación correcta de código fuente (impresión legible y ordenada)</li>
<li>Conceptos de programación utilizados</li>
<li>Perdida de memoria y/o recursos
<ul>
<li>No se permite el uso de variables globales</li>
</ul>
</li>
<li>Eficiencia de la solución adoptada
<ul>
<li>No se permite la carga completa de archivos de entrada a memoria (1)</li>
<li>No se permite limitar las entradas a tamaños arbitrarios (1)</li>
</ul>
</li>
</ul>

<em>(1) Salvo indicación explícita del enunciado o del profesor</em>

<a name="compilar"></a>
## ¿Cómo compilar en Linux?


Para compilar en Linux (o cualquier otro <em>sabor</em> de Unix) se utiliza el comando <strong>make</strong> en conjunto con uno de los siguientes archivos de <em>scripts</em>:

<blockquote><em><em><a href="/assets/2010/08/file-zip.gif"><img title="Archivo ZIP" src="/assets/2010/08/file-zip.gif" alt="Archivo ZIP" width="37" height="37"></a></em> <a href="/assets/2016/09/Makefile.zip">Makefile</a><br>
</em>
<em><a href="/assets/2010/08/file-zip.gif"><img title="Archivo ZIP" src="/assets/2010/08/file-zip.gif" alt="Archivo ZIP" width="37" height="37"></a> <a href="/assets/2016/09/Makefile_client_server.zip">Makefile Cliente/Servidor</a><br>
</em></blockquote>

Ambos Makefiles deben descomprimirse en el directorio donde se encuentran todos los fuentes del ejercicio. Luego se edita el <tt>Makefile</tt> con tu editor de texto para configurar la sección llamada&nbsp; <strong><tt>#CONFIGURACION</tt></strong> para indicar el nombre del ejecutable, si se trata de un ejercicio en C o C++, si usa GTK+, gtkmm o la biblioteca matemática (math.h).
En la sección de <strong><tt>#CONFIGURACION "AVANZADA"</tt></strong> se encuentra el detalle de los valores de configuración que puede ser modificado si la configuración simple no es suficiente.
Una vez hecho esto sólo tenés que ejecutar, en la línea de comandos y dentro del directorio de fuentes, el comando&nbsp;<strong><strong>make</strong></strong> (si el archivo de scripts se llama&nbsp;<strong>Makefile</strong> y encuentra en dicho directorio) o <strong>make -f &lt;ruta-archivo-makefile&gt;</strong> (para especificar de forma explícita al archivo de scripts)

<strong>¡Prestar particular atención a los errores y/o advertencias!</strong>

Notas

<ul>
<li>Que compile bien con estas instrucciones no significa que el ejercicio esté perfecto, ni siquiera que sea ISO C/C++ puro. Es sólo una herramienta más (y bastante buena) pero no es garantizala calidad del código.</li>
<li>Si querés aprender más del comando <strong><tt>make</tt></strong> y el <strong><tt>Makefile</tt></strong> ejecutá en la línea de comandos: <strong><tt>man make</tt></strong> o <strong><tt>info make</tt></strong>.</li>
<li>Obviamente necesitás un compilador de C y C++. La cátedra recomienda el GCC/G++ (versiones 4.9 o superior).</li>
</ul>

### Utilizando Makefile Cliente/Servidor

Para compilar programas cliente-servidor, podes usar el Makefile especial para Cliente/Servidor. Para usarlo tenes que renombrarlo como <strong><tt>Makefile </tt></strong>y ponerle nombres especiales a tus archivos:

<ul>
<li><strong><tt>client*</tt></strong> a los archivos especificos para el cliente (por ejemplo: <tt>client_main.cpp</tt>).</li>
<li><strong><tt>server*</tt></strong> a los archivos especificos para el servidor (por ejemplo: <tt>server_main.cpp</tt>).</li>
<li><strong><tt>common*</tt></strong> a los archivos generales, compartidos por ambos procesos, cliente y servidor (por ejemplo: <tt>common_socket.cpp</tt> o <tt>common_thread.cpp</tt>).</li>
<li>Luego, compilas tambien con <tt>make</tt> y te genera los ejecutables <strong><tt>client</tt></strong> con el cliente y <strong><tt>server</tt></strong> con el servidor.</li>
</ul>

## Estándares de Codificación

La cátedra adopta las guías de codificación propuestas por Google para sus herramientas y proyectos públicos. A fin de controlar el cumplimiento de estas normas, los alumnos deben ejecutar el <em>script</em> de verificación <strong>Cpplint</strong> provisto por la cátedra.
Para más información, consultar el instructivo sobre <a title="Normas de Codificación – CPPLint" href="/normas-cpplint">Normas de Codificación y Cpplint</a>.
