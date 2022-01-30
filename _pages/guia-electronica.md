---
layout: main-topic-page
title: Entrega digital en GitHub y Sercom
sidebar-include: sidebar-guia-electronica.html
permalink: /guia-electronica
hide_post_meta: true
tags: [Trabajos Prácticos]
nav-trabajos-practicos: active

---

La entrega digital consta de subir el trabajo a un repositorio
en GitHub, hacer un release y subir el release al
<a href="{{ site.sercom_url }}" target="_blank">Sercom</a>.

Este es un *proceso habitual en la industria* desde el control
de versiones al release.

La [guía de registración](/inscripcion-sercom) les muestra paso a paso
como registrarse en el Sercom donde deberas tener una cuenta gratuita
en [GitHub](https://github.com/) previamente creada.

Una vez que te registres en el Sercom y te hayas anotado en el curso
correspondiente al cuatrimestre en curso, el Sercom te creeara 3
repositorios en Github **privados**.

Estos son:

 - `onboarding`
 - `sockets`
 - `threads`

Los repositorios son **privados** y no deben ser compartidos para evitar
plagios.

## Evolución del proyecto

El proyecto consta de 2 partes: la parte de entregas **individuales** y
la parte de entregas **grupales**.

La parte grupal la discutirás con tu grupo y con el docente a cargo pero
eso recién será a partir de la mitad del cuatrimestre.

Por ahora, enfocate en la parte individual.

La parte individual a su vez consta de 3 partes, cada una asociado a su
correspondiente repositorio en Github.

Para las entregas individuales el Sercom te habrá creado 3 repositorios
en donde deberás ir resolviendo distintas partes del proyecto.

Es importante que todo el
código que crees esten dentro del repositorio **sin** subcarpetas.

Ademas del código deberás crear un `README` con el **informe del trabajo**.
Asegurate que en el informe incluyas tu nombre y padrón.

<img style="max-width: 100%;" src="assets/img/git/05_code_and_readme.png" />

Con `git add` podes seleccionar que cambios se incluiran en el siguiente
commit; con `git commit` consolidas tus cambios en un commit, es recomendable
hacer buenos mensajes de commit. Finalmente un `git push` copia tus commits
locales y los publica en el repositorio de GitHub.

Se recomienda hacer el ciclo de `git add`, `git commit` y `git push`
*frecuentemente* introduciendo cambios pequeños y con buenos comentarios.

<img style="max-width: 100%;" src="assets/img/git/06_commit_push.png" />

Podes leer mas sobre `git` en el libro público y gratuito [Pro
Git](https://git-scm.com/book/en/v2)

## Release de la solución

Una vez que consideres que tu trabajo esta listo para ser subido al
<a href="{{ site.sercom_url }}" target="_blank">Sercom</a>, tenes
que hacer un *release*. No te olvides de verificar que hayas subido
a GitHub todos tus cambios con un `git push`.

<img style="max-width: 100%;" src="assets/img/git/07_check.png" />

Un *release* no es mas que una marca o tag que indica un momento
fijo en la historia de tu repositorio. El nombre del tag es
arbitrario pero se sugiere el uso de números de versión incrementales
siguiendo un [versionado semántico](https://semver.org/lang/es/).

<img style="max-width: 80%;" src="assets/img/git/08_release.png" />

## Entrega en el Sercom

Con el release creado deberás ir al Sercom, seleccionar el ejercicio
correspondiente y hacer una entrega o *submission* donde tendrás que
poner el nombre del release (el mismo que usaste en Github).

El proceso de hacer un release y subirlo al Sercom lo podes realizar
varias veces como desees
pero el Sercom impone un **límite** por hora.

**No abuses del sistema**: asegurate que
tu código compila, pasa las pruebas y no tiene leaks de *manera local*.
Es **mucho** más rápido que estar subiendo las entregas al Sercom ademas
que podrás debuggearlo.

El Sercom compilará tu código y lo ejecutará contra los tests públicos y
privados.

Cuando termine podrás ver los resultados:
 - output de la compilación
 - diferencias entre el output generador por tu código y el esperado por
las pruebas
 - verificación con Valgrind, thread-sanitizer y otras herramientas.

Recordá que las entregas **son obligatorias** y que tienen fechas de
cierre.

## Semana de Code Review

Una vez que se cierre el período de entregas comienza la semana de
revisión o *code review*.

El *code review* es un proceso estándar que fomenta la colaboración
y la mejora continua.

El docente le enviará al alumno un mail pidiéndole que lo agregue como
*colaborador* al repositorio.

El docente podrá
seleccionar fragmentos de código

<img style="max-width: 60%;" src="assets/img/git/14_file_issue.png" />

y crear tickets o issues:

<img style="max-width: 100%;" src="assets/img/git/15_fill_issue.png" />

*Es muy importante que el alumno repase los temas de la clase en
compañía de las correcciones.*

El alumno entonces tendrá una lista de los puntos a mejorar
para una posible reentrega.

## Comentarios finales

La mencionada forma de trabajo tiene como objetivo familiarizar
al alumno con herramientas y metodologías de actual uso en la industria.

Un sistema de control de versiones como `git` es esencial para manejar
proyectos de mayor escala y el proceso de *code review* es una buena
práctica para mejorar el código.
