---
layout: post
title: Constructor de copia y sobrecarga I
author: admin
date: 21/08/2010
tags: [C]
snippets: 
    - |
        ```cpp
        //-----------------------------------------------------------------------------
        // TALLER DE PROGRAMACION I
        //
        // Temas a ejemplificar: constructor de copia, sobrecarga de operadores
        //-----------------------------------------------------------------------------
         #ifndef _COMPLEJO_H_
        #define _COMPLEJO_H_
         #include <ostream>
         //-----------------------------------------------------------------------------
        // Clase cComplejo: El objetivo de esta clase es el manejo de numeros complejos
        //-----------------------------------------------------------------------------
         class cComplejo
        {
         private:
         int real, imaginario;
          // la sobrecarga del operador << no es realizada mediante metodo de
         // clase; se declara la funcion como friend (amiga) de la clase de
         // forma tal que la misma pueda acceder a la parte no-publica de la clase
         friend std::ostream &operator<<( std::ostream &stream, const cComplejo &complejo );
          // funcion privada utilizada internamente por los metodos publicos
         void set( int real, int imaginario );
          public:
          // constructor de copia y constructor con parametros con valores por
         // default; permiten instancias de los tipos 'cComplejo cmpx2( cmpx1 )',
         // 'cComprejo cmpx', 'cComplejo cmpx( 20 )', 'cComplejo cmpx( 20, 10 )'
         cComplejo( int real = 0, int imaginario = 0 );
         cComplejo( const cComplejo &parametro );
          // sobrecarga del operador = entre dos objetos del tipo cComplejo
         const cComplejo &operator=( const cComplejo &origen );
          // dos sobrecargas del operador +, para dos tipos de datos distintos
         // a la derecha del operador
         cComplejo operator+( const cComplejo &param ) const;
         cComplejo operator+( int param ) const;
          // dos sobrecargas del operador +=, para dos tipos de datos distintos
         // a la derecha del operador
         const cComplejo &operator+=( const cComplejo &param );
         const cComplejo &operator+=( int param );
          // dos sobrecargas del operador ++
         // difieren en que una es pre-incremento y la otra post-incremento
         cComplejo &operator++();
         cComplejo operator++( int );
          // sobrecarga de operadores de comparacion. Notar que los dos primeros
         // son la base de los siguientes (ver codigo abajo)
         bool operator==( const cComplejo &param ) const;
         bool operator<( const cComplejo &param ) const;
          bool operator!=( const cComplejo &param ) const;
         bool operator>( const cComplejo &param ) const;
         bool operator>=( const cComplejo &param ) const;
         bool operator<=( const cComplejo &param ) const;
          // operador de conversion de tipo a int
         operator int() const;
        };
         #endif // _COMPLEJO_H_
        ```

    - |
        ```cpp
        //-----------------------------------------------------------------------------
        // TALLER DE PROGRAMACION I
        //
        // Temas a ejemplificar: constructor de copia, sobrecarga de operadores
        //-----------------------------------------------------------------------------
         #include <iostream>
        #include "complejo.h"
         using std::ostream;
        using std::cout;
         void cComplejo :: set( int real, int imaginario )
        {
         // iguala parte real e imaginaria
         this->real = real;
         this->imaginario = imaginario;
        }
         cComplejo :: cComplejo( int real, int imaginario ):
         real(real), imaginario(imaginario) // Lista de inicializadores
        {
        }
         // en este caso el constructor de copia no es necesario, dado que el
        // constructor por default brindado por C++ realizaria el trabajo de
        // forma correcta (ver ejemplo de la clase cCadena)
        cComplejo :: cComplejo( const cComplejo &c ):
         real(c.real), imaginario(c.imaginario)
        {
        }
         const cComplejo &cComplejo :: operator=( const cComplejo &origen )
        {
         // notar la condicion que evita la auto-asignacion. En este caso no
         // seria escencial (ver ejemplo de la clase cCadena)
         if( &origen != this ) set( origen.real, origen.imaginario );
         return( *this );
        }
         const cComplejo &cComplejo :: operator+=( const cComplejo &param )
        {
         // sumamos a este objeto el parametro
         real += param.real;
         imaginario += param.imaginario;
         return *this;
        }
         const cComplejo &cComplejo :: operator+=( int param )
        {
         real += param;
         return *this;
        }
         cComplejo cComplejo :: operator+( const cComplejo &param ) const
        {
         // notar que los cambios no son almacenados; solo se devuelve un objeto
         // temporario con el valor resultante de la operacion
         cComplejo resultado(*this); // Copia nuestro objeto
         resultado += param; // Reutiliza operator += para sumarle el param
         return resultado; // Devuelve la copia
        }
         cComplejo cComplejo :: operator+( int param ) const
        {
         // notar que los cambios no son almacenados; solo se devuelve un objeto
         // temporario con el valor resultante de la operacion
         cComplejo resultado(*this);
         resultado += param;
         return resultado;
        }
         cComplejo &cComplejo :: operator++()
        {
         // operacion de incremento en uno (parte real), pre-incrementada (++a)
         // se devuelve referencia para aceptar expresiones del tipo 'a = ++b'
         *this += 1;
         return( *this );
        }
         cComplejo cComplejo :: operator++( int )
        {
         // operacion de incremento en uno (parte real), post-incrementada (a++)
         // el parametro (siempre con valor 0) es agregado por el compilador para
         // distinguirlo del pre-incremento
          // se devuelve un temporario sin modificar, aunque el objeto quede modificado
         cComplejo temp = *this;
         ++(*this); // reutilizamos pre-incremento
         return( temp );
        }
         cComplejo :: operator int() const
        {
         // la sobrecarga de este operador de 'conversion de tipos' permite
         // que el objeto cComplejo se comporte como un 'int' donde
         // se requiera este tipo de dato. Dado que fue implementado con fines
         // ilustrativos, se retornara solo la parte real
         return( real );
        }
         bool cComplejo :: operator==( const cComplejo &param ) const
        {
         // sobrecarga del operador ==
         // se consideran iguales dos complejos con igual parte real e imaginaria
         return( (real == param.real) && (imaginario == param.imaginario) );
          // NOTA: este operador sobrecargado sera base para el resto
        }
         bool cComplejo :: operator<( const cComplejo &param ) const
        {
         // sobrecarga del operador <
         // se considera un complejo menor que otro si la norma cuadrada del primero
         // es menor que la norma cuadrada del segundo
         int normacuad1 = real * real + imaginario * imaginario;
         int normacuad2 = param.real * param.real +
         param.imaginario * param.imaginario;
          return( normacuad1 < normacuad2 );
          // NOTA: este operador sobrecargado sera base para el resto
        }
         bool cComplejo :: operator!=( const cComplejo &param ) const
        {
         // sobrecarga del operador !=, utilizando como base el operador ==
         return( !( *this == param ) );
        }
         bool cComplejo :: operator>( const cComplejo &param ) const
        {
         // sobrecarga del operador >, utilizando como base los operadores != y <
         return( ( *this != param ) && ( !( *this < param ) ) );
        }
         bool cComplejo :: operator>=( const cComplejo &param ) const
        {
         // sobrecarga del operador >=, utilizando como base el operador <
         return( !( *this < param ) );
        }
         bool cComplejo :: operator<=( const cComplejo &param ) const
        {
         // sobrecarga del operador <=, utilizando como base el operador >
         return( !( *this > param ) );
        }
         // notar que esta sobrecarga del operador << (no miembro) fue declarada
        // como friend de la clase cComplejo; esto es debido a que esta funcion
        // accede a atributos privados de la clase. (ver clase cCadena)
        ostream &operator<<( ostream &stream, const cComplejo &complejo )
        {
         // realiza la salida del numero complejo en el formato 'a + bi'
         // notar que cout es una instancia de ostream, por lo cual es perfectamente
         // valido 'cout << complejo'
         stream << "Complejo: " << complejo.real << " + " << complejo.imaginario << "i";
          // devuelve una referencia a ostream para permitir expresiones del tipo
         // 'cout << a << b << c;
         return( stream );
        }
         // -----------------------------------------
        //  TEST DE LA CLASE DE NUMEROS COMPLEJOS
        // -----------------------------------------
        int main( void )
        {
         cComplejo a1( 23 );
         cComplejo a2( 45, 35 );
         cComplejo a3 = a1 + a2;
          cout << "\n" << a1 << "\n";
         cout << a2 << "\n";
         cout << a3 << "\n\n";
          a3 += a2;
         cout << a3 << "\n";
          a3++;
         cout << a3 << "\n";
          int parte_entera = ++a3;
         cout << "La parte entera es ==> " << parte_entera << "\n";
          return( 0 );
        }
        ```

---
<div class="entry-content">
						<p>Constructor de copia, sobrecarga de operadores.</p>
<p>complejo.h</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
<p>complejo.cpp</p>
<div><div>{{page.snippets[1] | markdownify }}</div></div>
											</div>
