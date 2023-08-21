---
layout: main-topic-page
title: Documentación requerida para el TP Grupal Final
permalink: /documentacion-requerida
sidebar-include: sidebar-trabajos-practicos.html
hide_post_meta: true
nav-trabajos-practicos: active
tags: [Trabajos Prácticos]

---

Para el trabajo práctico final el grupo deberá presentar tres documentos
junto con el código.

Estos son el manual del usuario, la documentación técnica
y el manual del proyecto.

### Manual del usuario

Como todo software, este es usado por un usuario que, a priori, puede no
saber como usar el software.

El manual del usuario debe escribirse pensando que la persona que lo va
a leer no es un experto en C++.

Debe ser claro para que el usuario pueda compilar el proyecto.
Piensen que para su perspectiva, si no se puede compilar
es como que el software "no funciona".

Indicar

 - sistema operativo y dependencias necesarias para la compilación y
   ejecución del programa. Incluir versiones.
 - los pasos para compilar el proyecto
 - los pasos para configurar el software: hay que modificar archivo con
   parámetros? hay que poner algún recurso (imágenes, sonidos) en algún
   lugar?

Tener implementado un instalador que automatize lo anterior es de suma
importancia.

Explicar como usar el software es igualmente importante: si el usuario
no sabe que una funcionalidad particular existe, no la usará y pensará
que no existe.

Un manual de usuario debe ser atractivo para el usuario. Usar
screenshots de la interfaz gráfica.

Por ejemplo para un juego el manual debería poder responder:

 - como se levanta el servidor?
 - como se crean nuevos niveles con el editor?
 - como se lanza el cliente?
 - como se juega?

Hacer una página web (con Github Pages) y/o un video promocional del
proyecto no es obligatorio, pero es más que bienvenido.


### Documentación técnica

La documentación técnica debe contener la información necesaria para que
otro desarrollador puede entender la arquitectura e incluso continuar
con el desarrollo del proyecto.

 - explicar con diagramas de clase y/o de secuencia las partes más
importantes del proyecto. Resaltar los métodos mas importantes pero no
es necesario diagramas detallistas: piensen que la documentación está
para explicarle a otro desarrollador como funciona el proyecto.

 - explicar como es el formato de los archivos y del protocolo de
comunicación.

Los diagramas deben graficar cómo esta constituido y/o resuelto
el trabajo:

 - diagramas de clase de solo las clases mas importantes
 - diagramas de secuencia u objetos de las comunicaciones mas importante entre threads

Por ejemplo **no** tiene mucho sentido un diagrama completo de treinta
clases
o un diagrama tan genérico que podría ser el diagrama de cualquier
trabajo.


En cambio aporta información un gráfico que centra la atención en una
clase de alta importancia y aquellas relacionadas con la primera.

Usen un generador
como [PlantUML](https://plantuml.com/) que son basados en texto
en vez de uno gráfico para generar los diagramas rápidamente.


### Manual de proyecto

Este manual es una documentación corta para indicar en que trabajó cada
integrante del equipo, como se organizaron por semana y cuanto difirió
del plan inicial.

Indiquen que herramientas usaron (IDEs, linters) y que documentación
usaron para aprender sobre las tecnologías.

Hay algo que crean que debería darse en Taller? Indiquenlos también.

Cuales fueron los puntos más problemáticos? Pudieron llegar con todo?
Hay errores conocidos? Si volvieran hacer el proyecto, que cambiarían
(a nivel código o a nivel organizacional).


