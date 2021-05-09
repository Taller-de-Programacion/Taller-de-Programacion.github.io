---
layout: post
title: Endianness
author: Martin Di Paola
date: 24/04/2021
tags: [correccion, endianness]
snippets: none

---


Recordá que los integers pueden no tener la misma representación en
memoria que los integers de otras computadoras.

Esto es el llamado *endianness*.

Para convertir el endianness de tu máquina a *big endian* y viceversa
podes usar las funciones `ntoh` y `htons`  (para `short`) y `ntol` y `htol`
(para `int`).

Tip:  `ntohs` se lee *del endianness de la (n)etwork al endianness del
(h)ost para un (s)hort*.

Históricamente el endianness de la red (network) es *big endian*.
