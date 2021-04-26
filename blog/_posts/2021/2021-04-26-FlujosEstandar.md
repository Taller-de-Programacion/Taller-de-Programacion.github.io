---
layout: post
title: Flujos Estándar
author: Ezequiel Werner
date: 26/04/2021
tags: [correccion, Files]
snippets: none

---

STDIN, STDOUT y STDERR son flujos de datos, tratados como archivos en UNIX.
Los tres están conectados con el proceso padre (comúnmente la terminal), pero
ninguno está conectado con un periférico: STDIN no es el teclado ni STDOUT la 
pantalla. La confusión se da porque la terminal es una aplicación interactiva
que maneja eventos de teclado y muestra una ventana en la pantalla.

