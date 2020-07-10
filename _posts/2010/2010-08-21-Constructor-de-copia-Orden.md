---
layout: post
title: Constructor de copia – Orden
author: admin
date: 21/08/2010
tags: [C]
snippets: 
    - |
        ```cpp
        #include <iostream>
        #include <string>
         class CCadena
        {
         private:
          char *cadena;
          public:
          CCadena( char *cad )
         {
         cadena = new char[ strlen( cad ) + 1 ];
         strcpy( cadena, cad );
         }
          CCadena( const CCadena &v )
         {
         cadena = new char[ strlen( v.cadena ) + 1 ];
         strcpy( cadena, v.cadena );
         }
          void Print()
         {
         std::cout << cadena;
         }
          ~CCadena()
         {
         delete[] cadena;
         }
        };
         void print( CCadena param )
        {
         param.Print();
        }
         int main( void )
        {
         CCadena cadena( "Hola" );
         print( cadena );
          return 0;
        }
        ```

---
Constructor copia: Orden

Implementamos las siguientes clases:

![Diagrama de clases](/assets/2010/08/2010-08-21-Constructor-de-copia-Orden.svg)

```cpp
#include <iostream>
class CA {
 public:
  CA() {
   std::cout << "Const CA" << std::endl;
  }
  ~CA() {
   std::cout << "Destr CA" << std::endl;
  }
};

class CB {
 public:
  CB() {
   std::cout << "Const CB" << std::endl;
  }
  ~CB() {
   std::cout << "Destr CB" << std::endl;
  }
};

class CC {
 public:
  CC() {
   std::cout << "Const CC" << std::endl;
  }
  ~CC() {
   std::cout << "Destr CC" << std::endl;
  }
};

class P1 {
 private:
  CC c;
 public:
  P1() {
   std::cout << "Const P1" << std::endl;
  }
  ~P1() {
   std::cout << "Destr P1" << std::endl;
  }
};

class P2 {
 public:
  P2() {
   std::cout << "Const P2" << std::endl;
  }
  ~P2() {
   std::cout << "Destr P2" << std::endl;
  }
};

class H : public P1, P2 {
 private:
  CA a;
  CB b;
 public:
  H() {
   std::cout << "Const H" << std::endl;
  }
  ~H() {
   std::cout << "Destr H" << std::endl;
  }
};
 
int main(void) {
 H h;
 // Const CC              primero se construyen los padres, en el orden que aparecen
 // Const P1
 // Const P2              para cada clase que se construya, antes de su constructor se
 // Const CA                   invocan los constructores de cada uno de los miembros,
 // Const CB                   en el orden en el que aparecen.
 // Const H
 // Destr H
 // Destr CB
 // Destr CA
 // Destr P2
 // Destr P1
 // Destr CC
 return 0;
}
```
<p>orden.cpp</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>