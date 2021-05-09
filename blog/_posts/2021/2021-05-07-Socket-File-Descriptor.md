---
layout: post
title: Socket - File Descriptor
author: Martin Di Paola
date: 07/05/2021
tags: [correccion, socket, fd, RAII]
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

Como todo recurso, este debe ser protegido en un `struct` (C) o clase
(C++) **ocultando** el file descriptor de la interfaz
(funciones/métodos) públicos.

```cpp
/***** Archivo socket.h *****/
struct socket_t {
  int fd;
};

// Mal: el usuario del struct socket_t *sabe* y *manipula*
// file descriptors. Leakea la implementación y no es RAII.
void socket_set_fd(struct socket_t* self, int fd);
/***** Fin de socket.h *****/
```

```cpp
/***** Archivo socket.h *****/
struct socket_t {
  int fd;
};
/***** Fin de socket.h *****/

/***** Archivo socket.c *****/
// Bien: esta función es privada: el usuario del struct socket_t
// *no* puede llamarla.
static void socket_set_fd(struct socket_t* self, int fd) {
  self->fd = fd;
}
/***** Fin de socket.c *****/
```

```cpp
/***** Archivo socket.h *****/
class Socket {
  private:
    int fd;
  public:
    // Mal: el usuario de la clase Socket *sabe* y *manipula*
    // file descriptors. Leakea la implementación y no es RAII.
    Socket(int fd);
    /*...*/
};
/***** Fin de socket.h *****/
```


```cpp
/***** Archivo socket.h *****/
class Socket {
  private:
    int fd;
    // Bien: este método (constructor) es privado: el usuario de la clase
    // Socket *no* puede llamarlo.
    explicit Socket(int fd);
  public:
    /*...*/
};
/***** Fin de socket.h *****/
```
