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
como registrarse en el Sercom.

## Creación de un repositorio en GitHub

Para ello deberás tener una cuenta en [GitHub](https://github.com/).
Estas son gratuitas y solo requieren de un mail de confirmación.

Una vez logueado deberás crear un repositorio de Git por cada
trabajo práctico:

<img style="max-width: 100%;" src="assets/img/git/01_create_repo.png" />

El nombre del repositorio no es importante aunque se sugiere que
coincida con el nombre del trabajo.

Lo que sí es importante es que el repositorio sea **privado** durante
la cursada. Una vez terminada la cursada podes hacer pública tu solución.

<img style="max-width: 100%;" src="assets/img/git/02_private_repo.png" />

Copia la dirección del repositorio en GitHub. Asegurate de seleccionar
*https*.

<img style="max-width: 100%;" src="assets/img/git/03_copy_name.png" />

En una terminal en tu máquina podes clonar tu repositorio. Esto es
tener una copia local donde puedas trabajar.

<img style="max-width: 100%;" src="assets/img/git/04_clone.png" />


## Evolución del proyecto

A partir de aquí comienza tu desarrollo. Es importante que todo el
código que crees esten dentro del repositorio **sin** subcarpetas.

Ademas del código deberas crear un `README` con el **informe del trabajo**.
Asegurate que en el informe incluyas tu nombre, padrón y la URL del
repositorio.

<img style="max-width: 100%;" src="assets/img/git/05_code_and_readme.png" />

Con `git add` podes seleccionar que cambios se incluiran en el siguiente
commit; con `git commit` consolidas tus cambios en un commit, es recomendable
hacer buenos mensajes de commit. Finalmente un `git push` copia tus commits
locales y los publica en el repositorio de GitHub.

Se recomienda hacer el ciclo de `git add`, `git commit` y `git push`
*frecuentemente* introduciendo cambios pequeños y con buenos comentarios.

<img style="max-width: 100%;" src="assets/img/git/06_commit_push.png" />

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

Con el release creado descargate el zip que te da GitHub.

<img style="max-width: 80%;" src="assets/img/git/09_download_code.png" />

El Sercom (<a href="{{ site.sercom_url }}" target="_blank">{{ site.sercom_url }}</a>)
cuenta con su propio sistema de registro de usuarios y deberás estar
registrado previamente.

Una vez correctamente identificado deberás entrar al curso y seleccionar
el ejercicio que estas resolviendo.

Cada entrega o *submission* requiere completar 3 items:
 - subir el zip que te descargaste desde GitHub
 - poner el link al repositorio de GitHub en el cual esta el código
 - poner tu padrón.

<img style="max-width: 100%;" src="assets/img/git/11_subir_entrega.png" />

El proceso de hacer un release y subirlo al Sercom lo podes realizar
varias veces pero hay un limite por hora.

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

## Semana de Code Review

Una vez que se cierre el período de entregas comienza la semana de
revisión o *code review*.

El *code review* es un proceso estándar que fomenta la colaboración
y la mejora continua.

El docente le enviará al alumno un mail pidiéndole que lo agregue como
*colaborador* al repositorio.

El alumno deberá configurar el proyecto

<img style="max-width: 100%;" src="assets/img/git/12_settings.png" />

y agregarlo como colaborador:

<img style="max-width: 60%;" src="assets/img/git/13_add_collaborator.png" />

El docente entonces podrá hacer un code review. Podrá
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
