---
layout: post
title: Socket - File Descriptor
author: Martin Di Paola
date: 07/05/2021
tags: [correccion, socket, fd]
snippets: none

---

Los sockets son estructuras de datos que están del lado del kernel.

Para referenciarlos, el sistema operativo nos da un *file descriptor*
(*fd*).

Un fd es un numero **no-negativo**, esto es, 0, 1 o mayores. *El 0 es un
file descriptor válido*.

Si se quiere guardar en una variable la *ausencia* de un fd se debe
usar un número que no se lo confunda con un fd válido. O sea, un número
negativo, típicamente el `-1`.

```cpp
int fd = -1;  // fd *no* inicializado
if (fd >= 0) {
   // fd inicializado y válido
} else {
   // fd inválido
}
```


