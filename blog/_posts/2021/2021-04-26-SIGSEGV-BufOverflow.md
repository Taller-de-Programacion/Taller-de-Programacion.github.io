---
layout: post
title: Buffer overflow, Segmentation fault
author: Ezequiel Werner
date: 26/04/2021
tags: [correccion, Compilacion, Buffer overflow, Segmentation fault]
snippets: none

---

Un segmentation fault se da cuando un proceso intenta realizar una operación 
para la que no tiene permisos sobre un segmento de memoria. Es común ver un 
segmentation fault cuando se intenta desreferenciar un puntero nulo.
Para clarificar la parte de los permisos, también recibiríamos un segmentation 
fault si intentamos escribir al code-segment, mientras que no sucede si lo 
leemos, porque tenemos permiso de sólo lectura.

Un buffer overflow es acceder a memoria contigua a la asignada para cierta 
variable. Usualmente pasa cuando escribimos más allá de los límites de algún 
arreglo de memoria, pisando o leyendo memoria contigua.
