---
layout: post
title: Herencia y polimorfismo
author: admin
date: 21/08/2010
tags: [C++ herencia polimorfismo]
---

Primero definimos una clase *cObjeto* genérico, que posee un nombre almacenado en un buffer.

```cpp
//-----------------------------------------------------------------------------
// TALLER DE PROGRAMACION I
//
// Temas a ejemplificar: herencia, polimorfismo, orden de llamada de
//                       constructores y destructores, clases abstractas
//-----------------------------------------------------------------------------
#ifndef VIRTUAL_H
#define VIRTUAL_H

#include <cstring>
#include <iostream>
 //-----------------------------------------------------------------------------
// CLASE de OBJETO GENERAL
// tanto la clase base como la derivada tendran dos objetos de esta clase como
// miembros privados, a fin de verificar el orden de llamada de los
// constructores y destructores
//-----------------------------------------------------------------------------
class cObjeto {
  private:
  char nombre[ 32 ];
  public:
  // Si el metodo esta definido en la declaracion de la clase
  // implicitamente es declarada "inline"
  // Sin embargo el compilador es libre de ignorar esta sugerencia.
  cObjeto(const char *nombre) {
  // siempre usar strncpy (y las versiones de tama#o limitado - con 'n' en
  // el nombre - de las funciones de cstring) cuando el tama#o del buffer
  // no se sabe si es suficiente
  strncpy( this->nombre, nombre, sizeof(this->nombre)-1 );
  // nos aseguramos de que el string termine en \0 por si "nombre" era mas
  // largo que 0x100 chars
  this->nombre[sizeof(this->nombre)-1] = '\0';
  std::cout << "Constructor Objeto: " << this->nombre << "\n";
  }
  // Este tambien es inline
  ~cObjeto() {
    std::cout << "Destructor Objeto: " << this->nombre << "\n";
  }
};
```

Definimos una clase *cBase* con un par de atributos de tipo *cObjeto*

```cpp
//-----------------------------------------------------------------------------
// CLASE BASE
//-----------------------------------------------------------------------------
class cBase {
  private:
  cObjeto objeto_base_1;
  cObjeto objeto_base_2;
  public:
  cBase(): objeto_base_1( "Objeto 1 de Base" ),
  objeto_base_2( "Objeto 2 de Base con un nombre muy largo que va a ser truncado" ) {
    std::cout << "Constructor de BASE\n";
  }
  // Los metodos virtuales nunca pueden ser "inline" porque se resuelven en
  // tiempo de ejecucion
  virtual ~cBase();
  // Otra forma de declarar un metodo "inline" es con el modificador
  // asi podemos definir un metodo inline por fuera de la declaracion de
  // la clase (pero debe estar la definicion en el .h para que sea efectivo)
  inline void funcion_A();
  inline void funcion_B();
  // Por mas que lo defina dentro de la clase, tampoco va a ser "inline" por ser virtual
  virtual void funcion_C() {
    std::cout << "Funcion C de BASE\n";
  }
  // Metodo virtual puro, directamente no tiene definicion, por lo tanto hace
  // que la clase sea abstracta (no se pueda instanciar)
  virtual void funcion_D() = 0;
};

// Como dijimos, los inline deben estar definidos en el .h
void cBase :: funcion_A() {
  std::cout << "Funcion A de BASE\n";
}

void cBase :: funcion_B() {
  std::cout << "Funcion B de BASE\n";
}
```

Definimos una clase derivada de *cDerivada*. A diferencia de la clase *cBase*, definimos los métodos en un archivo aparte.


```cpp
//-----------------------------------------------------------------------------
// CLASE DERIVADA
//-----------------------------------------------------------------------------
class cDerivada : public cBase {
  private:
  cObjeto objeto_deriv_1;
  cObjeto objeto_deriv_2;
  public:
  cDerivada();
  ~cDerivada();
  void funcion_A();
  void funcion_D();
};

#endif // _VIRTUAL_H_
```

Y en un archivo `virtual.cpp`

```cpp
//-----------------------------------------------------------------------------
// TALLER DE PROGRAMACION I
//
// Temas a ejemplificar: herencia, polimorfismo, orden de llamada de
//                       constructores y destructores, clases abstractas
//-----------------------------------------------------------------------------
#include "virtual.h"
// Implementacion de cBase (cosas no inline)
cBase :: ~cBase() {
  std::cout << "Destructor de BASE\n";
}

// Implementacion de cDerivada (cosas no inline)
cDerivada :: cDerivada() : cBase(),
 objeto_deriv_1( "Objeto 1 de Derivada" ),
 objeto_deriv_2( "Objeto 2 de Derivada" ) {
  std::cout << "Constructor de DERIVADA\n";
}

cDerivada :: ~cDerivada() {
  std::cout << "Destructor de DERIVADA\n";
}

void cDerivada :: funcion_A() {
  std::cout << "Funcion A de DERIVADA\n";
}

void cDerivada :: funcion_D() {
  std::cout << "Funcion D de DERIVADA\n";
}
```

En un archivo `main.cpp` escribimos una función main de pruebas.

```cpp
int main( void ) {
  cDerivada derivada;
  cBase *base_ptr = &derivada;
  // funcion de base, redefinida en derivada
  derivada.funcion_A();
  base_ptr->funcion_A();
  // funcion de base, no redefinida en derivada
  derivada.funcion_B();
  base_ptr->funcion_B();
  // funcion virtual de base, no redefinida en derivada
  derivada.funcion_C();
  base_ptr->funcion_C();
  // funcion virtual pura de base, redefinida en derivada
  derivada.funcion_D();
  base_ptr->funcion_D();
  return( 0 );
}
```
