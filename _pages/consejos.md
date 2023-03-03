---
layout: main-topic-page
title: Consejos para Cursar Taller
sidebar-include: sidebar-guia-electronica.html
permalink: /consejos
hide_post_meta: true
tags: [Trabajos Prácticos]
nav-trabajos-practicos: active

---

Taller es una materia intensa. No es difícil pero es demandante y tiene
fechas de entrega rígidas.

La mayoría de los alumnos tienen problemas no por los temas sino por
*"no tener tiempo"*.

Esta guia es una serie de consejos para optimizar tu tiempo y que le
saques el mayor jugo posible a la cursada.

## Antes de cada clase: imprime y lee los handouts

Tenes 15 minutos libres antes de ir a clase? Tal vez ya
estas en la facultad y estas en la biblioteca o en el pasillo;
tal vez estas viajando y podes usar el transporte público.

No uses esos 15 minutos para revisar el Whatsapp o red social favorita.

Tenete los handouts de las clases *impresos o en una notebook* y
usa esos 15 minutos para leerlos **antes** de la clase.

No esperes entenderlo todo pero *marca lo q no entiendas* o
*lo que pienses q no sirve*.

Anotate todo lo que no entiendas en el handout.

## Durante cada clase: haz preguntas

Durante la clase, toma nota de *solo* lo q tal vez en el handout no este
explicado bien o de aquellas cosas que no entendías.

Puede que en clase usemos otras diapositivas a las que tengas impresa
pero eso es doblemente mejor: tendrás 2 perspectivas distintas de un
mismo tema.

**Haz preguntas**: no te vayas de la clase sin tener todas las dudas
resueltas.

Al día siguiente, *haz los ejercicios de Recap*.

## Luego de cada clase: haz los ejercicios de Recap

Tendrás 1 semana para hacerlos pero **no procrastines y hacelo el día
siguiente a la clase**.

Por que? Porque estudios muestran q *es más efectivo ejercitar algo q
ya tenes fresco*.

Intenta resolver todos los ejercicios q puedas por tu cuenta primero.

Por cada ejercicio q no te salga, intenta luego:

 - *repasar el tema* desde los handouts
 - usar el compilador y debugguer para *ver* como las cosas funcionan (o
no)

Te puede parecer q es tiempo perdido pero no.

Cuanto más intentes *por tu cuenta*, más vas a aprender.

Si seguís trabado, *pregunta* en el canal general de Discord.
Otros docentes y alumnos podrán ayudarte.

Si terminaste los ejercicios de Recap pero te surgieron dudas
(a pesar de tenerlos correctos), *preguntá* en el canal general de Discord
también.

## En la semana: como hacer preguntas?

Se preciso.

Preguntas genéricas como "no compila" **no** le permiten a nadie ayudarte
(ni a docentes ni a otros alumnos).

No es mala onda, posta q un "no compila" no le dice nada a nadie.

Si algo no compila o funciona, toma tu código y *simplificalo* a tal punto q te
quede **un código muy chiquito q aun siga mostrando el error**.

Durante este proceso puede q *vos mismo* encuentres la causa de error.

Si aun seguís con dudas (sea por q sigue sin funcionar o no sabes el por
que), podes postear la pregunta con el código en el Discord.

Recuerda q el código posteado no puede hablar de tu TP y debe ser
chiquito, lo mínimo para mostrar el error.

Agrega también *que cosas pensas q pueden ser y cuales ya descartaste*:
que experimentos ya hiciste.

Así, otros alumnos y docentes podrán ayudarte:

 - podrán compilar un código y ver si pueden reproducir el error
 - podrán ayudarte a debuggerlo
 - podrán ver las cosas q probaste y descartaste (tal vez tenes
   un error conceptual).

A menos que sea una corrección en tu TP hecha por un docente,
no le preguntes a ningún docente de forma privada.

Usa el canal general de Discord.

Esto es mucho **más efectivo** por q tu pregunta podrá ser contestada
por varias personas y le servirá a otros alumnos también.

Si le preguntas a un docente de forma privada, puede q tarde
en contestar y *es tiempo q no tenes el lujo de perder*.

Y si, también como alumno *estate atento a las dudas de tus compañeros*.

Al analizar y responder dudas ajenas te llevara a tener un entendimiento
más *profundo* de los temas (o a darte cuenta q no entendiste algo!)

Se le atribuye a Albert Einstein la frase "solo entiendes algo cuando
eres capaz de explicárselo a cualquiera"

## Implementación del TP (entrega individual)

No programes todo tu TP y solo al final veas si funciona o no.

99% seguro q no funcionara, q tendrá un error y te veras forzado a
buscarlo en todo tu TP.

Es una forma seguro de quemar tu energía y tiempo.

No lo hagas.

En cambio, parte el TP en bloques: *implementa y testea un bloque antes de
seguir con el siguiente*.

Así, si llega a haber un error, lo tendrás q encontrar en un area *mucho
más chica* y por ende, **más rápidamente**.

Usa todos los *linters y static checkers* y el compilador
para encontrar cualquier error **antes** de correr el
programa.

Corre tu TP (o parte de él) con *valgrind* y arregla todo los
errores que saltaron en runtime.

Solo luego si tienes tests que fallen, usa un debugger.

Y no, **no uses prints**. Si GDB te intimida, usa cualquier otro
debugger, pero **usa un debugger**.

Te vas a cansar de escuchar y leer estos consejos pero por algo
lo repetimos todo el tiempo. Créenos.

## Code review personal (devolución del TP)

Tendrás un docente a cargo de revisarte el código.

No alcanza "con que ande": en Taller como en la vida profesional se
busca código de buena calidad.

El docente te dejara los comentarios en Github.

Asegúrate de **entenderlos** primero y corregirlos luego.

Recuerda q puede q tengas un mismo error (o similares) en varios lados
de tu código: deberás corregirlos todos.

Por eso es importante entenderlos.

Si tienes dudas de una corrección, preguntale al docente por Discord.

Si la pregunta es más general, posteala en el canal general de Discord.

## Code review público

Tendremos parte de la clase para hacer un code review público de algunas
partes de algunos TPs del cuatrimestre.

Si tu TP es mostrado, puede q te "choque" recibir críticas. Créeme, es
normal pero **enfocate en aprender**.

Recuerda q los docente hacen un code review público de los errores más comunes
así que **no eres el único**.

Nadie quiere señalar con el dedo a nadie: el objetivo es mostrar los
errores, charlarlo y ver como arreglaros.


