---
layout: post
title: Constructor de copia y sobrecarga II
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        //-----------------------------------------------------------------------------
        // TALLER DE PROGRAMACION I
        //
        // Temas a ejemplificar: constructor de copia, sobrecarga de operadores
        //-----------------------------------------------------------------------------
         #ifndef _CADENA_H_
        #define _CADENA_H_
         #include <istream>
         //-----------------------------------------------------------------------------
        // Clase cCadena: El objetivo de esta clase es el encapsulamiento de una
        //                cadena tipo C (null terminated).
        //-----------------------------------------------------------------------------
         class cCadena
        {
         private:
         // cnum anonimo para usarlo como constantes
         enum { BUFFER_SIZE = 4096 };
          // representacion interna del string
         char *ptr;
          // funciones privadas utilizadas internamente por los metodos publicos
         void eliminar_actual( void );
         void cargar_cadena( const char *cadena );
          // sobrecarga del operador >>, como funcion no miembro
         friend std::istream &operator>>( std::istream &stream, cCadena &cadena );
          // se sobrecarga el operador == de forma 'no miembro' utilizando una
         // funcion amiga. Ver diferencia con la clase cComplejo, donde este
         // operador es sobrecargado utilizando un metodo miembro
         //
         // NOTA: por fines ilustrativos solo se sobrecargara la comparacion
         // contra un string tipo C. Lo importante a ilustrar tambien es que es
         // sobrecargado dos veces, para poder brindar la reciprocidad, cosa que
         // no seria posible utilizando metodos miembro. La segunda sobrecarga
         // no se realiza mediante funcion amiga.
         friend bool operator==( const cCadena &cadena, const char *string_c );
          public:
          // constructor con parametro con valor por defecto
         // permite instancias de las formas 'cCadena cad', 'cCadena cad( "Hola" )'
         cCadena( const char *cadena = NULL );
          // constructor de copia
         // permite instancias de objetos del tipo 'cCadena cad2( cad1 )'
         cCadena( const cCadena &origen );
          ~cCadena();
          // operador de conversion de tipo a 'const char *'
         operator const char*() const;
          // dos versiones de sobrecarga del operador =, para dos tipos
         // de datos distintos a la derecha del operador
         const cCadena &operator=( const cCadena &origen );
         const cCadena &operator=( const char *origen );
          int obtener_largo() const;
         void borrar();
          // sobrecarga del operador [] utilizada para el acceso a una
         // letra en particular; ej:  char c = cad1[ 5 ];
         const char &operator[]( int posicion ) const;
         char &operator[]( int posicion );
          // operador ! utilizado para saber si la cadena esta vacia
         bool operator!() const;
        };
         #endif // _CADENA_H_
        ```

    - |
        ```cpp
        //-----------------------------------------------------------------------------
        // TALLER DE PROGRAMACION I
        //
        // Temas a ejemplificar: constructor de copia, sobrecarga de operadores
        //-----------------------------------------------------------------------------
         #include <iostream>
        #include <cstring>
        #include <cstdlib>
        #include <cassert>
        #include "cadena.h"
         using namespace std;
         void cCadena :: eliminar_actual( void )
        {
         // si se posee memoria alocada para alguna cadena,
         // esta es devuelta al sistema
         if( ptr != NULL ) delete[] ptr;
          // la cadena almacenada queda indicada como nula
         ptr = NULL;
        }
          void cCadena :: cargar_cadena( const char *cadena )
        {
         // si actualmente se posee una cadena almacenada, esta
         // debe ser eliminada antes de asignar la nueva
         if( ptr != NULL ) eliminar_actual();
          // si la cadena recibida contiene el valor nulo, nada
         // quedara almacenado
         if( cadena == NULL ) return;
          // se reserva lugar para almacenar la nueva cadena y se
         // almacena como un string null terminated
         ptr = new char[strlen( cadena ) + 1];
         if( ptr != NULL )
         {
         strcpy( ptr, cadena );
         }
         else
         {
         // aca se podría manejar el caso de error de memoria
         // lanzando una excepcion o algun indicador de error
         // dentro de la clase
         }
        }
          cCadena :: cCadena( const char *cadena ):
         ptr(NULL) // Inicializa el atributo privado antes que nada
        {
         // si se envia una cadena de inicializacion (ver uso de parametros
         // por default), se carga la cadena
         if( cadena != NULL ) cargar_cadena( cadena );
        }
          cCadena :: cCadena( const cCadena &origen ):
         ptr(NULL)
        {
         // si se envia una cadena de inicializacion (ver uso de parametros
         // por default), se carga la cadena
         if( origen.ptr != NULL ) cargar_cadena( origen.ptr );
          // NOTA: En este ejemplo el constructor de copia es necesario. Notar
         // que los punteros no se copian directamente dentro de cargar_cadena,
         // sino que se asigna otro buffer de memoria para almacenar la cadena
        }
          cCadena :: ~cCadena()
        {
         // dentro del destructor, se elimina la cadena almacenada (si es
         // que existiese). Notar la importancia: dado que se utiliza
         // memoria dinamica para almacenar las cadenas, se debe devolver
         // la misma antes de eliminar el objeto
         if( ptr != NULL ) eliminar_actual();
        }
          cCadena :: operator const char*() const
        {
         // la sobrecarga de este operador de 'conversion de tipos' permite
         // que el objeto cCadena se comporte como un 'const char *' donde
         // se requiera este tipo de dato
         return( (ptr == NULL) ? "" : ptr );
        }
          const cCadena &cCadena :: operator=( const char *origen )
        {
         // se carga la nueva cadena a partir de otro objeto del mismo tipo
         cargar_cadena( origen );
          // se devuelve una referencia al mismo objeto para permitir expresiones
         // del tipo: 'a = b = c';
         return( *this );
        }
          const cCadena &cCadena :: operator=( const cCadena &origen )
        {
         // se carga la nueva cadena a partir de otro objeto del mismo tipo
          // NOTA: notar que la condicion ( &origen != this ) evita la
         // auto-asignacion de un objeto sobre si mismo. En este es escencial,
         // porque la destruccion de la cadena actual del objeto destino estaria
         // destruyendo la cadena del objeto origen antes de la asignacion.
          // NOTA: notar que por la sobrecarga del operador de conversion de tipo
         // 'const char *' se puede llamar a la funcion cargar_cadena usando
         // como parametro un objeto del tipo cCadena
          if( &origen != this ) cargar_cadena( origen );
          // se devuelve una referencia al mismo objeto para permitir expresiones
         // del tipo: 'a = b = c';
         return( *this );
        }
         int cCadena :: obtener_largo() const
        {
         // devuelve el largo de la cadena, contemplando el caso de la cadena
         // sin inicializar
         return( (ptr == NULL) ? 0 : strlen( ptr ) );
        }
          void cCadena :: borrar()
        {
         // elimina la cadena actual, si existiese
         // (libera ademas la memoria alocada para la misma)
         if( ptr != NULL ) eliminar_actual();
        }
          bool cCadena :: operator!() const
        {
         // este operador devuelve verdadero si la cadena almacenada esta vacia
         return( obtener_largo() == 0 );
        }
          const char &cCadena :: operator[]( int posicion ) const
        {
         // devuelve el i-esimo caracter de la cadena almacenada dentro
         // del objeto, como constante. Ej.  char c = cadena[ 5 ]
          // NOTA: aca se ve una buena razon para tener encapsulada en una clase
         // el manejo de strings. Se posee control sobre los límites del indice,
         // evitando errores de acceso indeseados. Tambien se puede
         // usar std::string accediendo con el metodo at() que tiene chequeo de
         // rango de los indices (lanzando una excepcion out_of_range si esta
         // fuera de rango).
          if( posicion < obtener_largo() )
         {
         return( ptr[ posicion ] );
         }
         else
         {
         // aca se podría manejar el caso de error de indice fuera de rango
         // lanzando una excepcion, assert, o algun tipo de indicador de error
         // dentro de la clase
         assert( "Indice fuera de Rango" );
         return( ptr[0] ); // aca nunca llegaria
         }
        }
          char &cCadena :: operator[]( int posicion )
        {
         // devuelve el i-esimo caracter de la cadena almacenada dentro
         // del objeto, como destino. Ej.  cadena[ 5 ] = c
          // NOTA: devolver una referencia a char es algo peligroso, porque
         // permitiria que el usuario maliciosamente ingrese un caracter '\0'
         // sin utilizar los metodos destinados a tal fin; una funcionalidad
         // de la clase estaria interfiriendo con el manejo interno de la misma
          if( posicion < obtener_largo() )
         {
         return( ptr[ posicion ] );
         }
         else
         {
         // aca se podría manejar el caso de error de indice fuera de rango
         // lanzando una excepcion, assert, o algun tipo de indicador de error
         // dentro de la clase
         assert( "Indice fuera de Rango" );
         return( ptr[0] ); // aca nunca llegaria
         }
        }
           // notar que esta sobrecarga del operador << (global) no fue declarada
        // como friend de la clase cCadena; esto fue posible debido a que esta funcion
        // no accede a ningun atributo ni metodo privado de la clase.
        ostream &operator<<( ostream &stream, const cCadena &cadena )
        {
         // operacion valida debido a que el operador de conversion de tipo
         // 'const char *' fue sobrecargado para la clase cCadena
         const char *cadena_casteada = cadena;
          // realiza la salida de la cadena
         // notar que cout es una instancia de ostream, por lo cual es perfectamente
         // valido 'cout << cadena'
         stream << "Cadena: " << cadena_casteada;
          // devuelve una referencia a ostream para permitir expresiones del tipo
         // 'cout << a << b << c;
         return( stream );
        }
          // notar que esta sobrecarga del operador >> (no miembro) fue declarada
        // como friend de la clase cCadena; esto es debido a que esta funcion
        // accede a atributos privados de la clase.
        istream &operator>>( istream &stream, cCadena &cadena )
        {
         // realiza la entrada a un buffer temporario, con maximo limitado a 500
         // notar que cin es una instancia de istream, por lo cual es perfectamente
         // valido 'cin >> cadena'
         char buffer[cCadena::BUFFER_SIZE];
         stream.getline( buffer, cCadena::BUFFER_SIZE );
          // se realiza la asignacion de la nueva cadena, utilizando metodos publicos
         cadena = buffer;
          // devuelve una referencia a istream para permitir expresiones del tipo
         // 'cin >> a >> b >> c;
         return( stream );
        }
          // notar que esta sobrecarga del operador == (no miembro) fue declarada
        // como friend de la clase cCadena; esto es debido a que esta funcion
        // accede a atributos privados de la clase.
        bool operator==( const cCadena &cadena, const char *string_c )
        {
         // por ser funcion amiga de la clase cCadena, posee acceso a cadena.ptr
         return( strcmp( cadena.ptr, string_c ) == 0 );
        }
          // notar que esta sobrecarga del operador << (global) NO fue declarada
        // como friend de la clase cCadena; esto fue posible debido a que esta funcion
        // no accede a ningun atributo ni metodo privado de la clase.
        bool operator==( const char *string_c, const cCadena &cadena )
        {
         // esta se realiza en base a la anterior, invirtiendo el
         // orden de los parametros (forzando la llamada al operador de cCadena
         return( cadena == string_c );
        }
           // -----------------------------------------
        //  TEST DE LA CLASE DE CADENAS
        // -----------------------------------------
        int main( void )
        {
         cCadena cad1;
         cCadena cad2( "Hola Mundo" );
         cCadena cad3( cad2 );
          cout << "\n" << cad1 << "\n";
         cout << cad2 << "\n";
         cout << cad3 << "\n\n";
          cad1 = cad2;
          cout << cad1 << "\n";
         cout << cad2 << "\n";
         cout << cad3 << "\n\n";
          if( !cad1 == false )
         {
         cout << "La tercer letra es: " << cad1[2] << "\n";
         }
          cad1[2] = 'k';
          if( !cad1 == false )
         {
         cout << "La tercer letra es: " << cad1[2] << "\n";
         }
          cad1.borrar();
          if( !cad1 )
         {
         cout << "La cadena fue borrada" << "\n\n";
         }
          if( cad2 == "Hola Mundo" )
         {
         cout << "Prueba de Reciprocidad (Parte 1)" << "\n";
         }
          if( "Hola Mundo" == cad2 )
         {
         cout << "Prueba de Reciprocidad (Parte 2)" << "\n\n";
         }
          cout << "Ingrese Cadena: ";
         cin >> cad1;
         cout << cad1 << "\n\n";
          return( 0 );
        }
        ```

---
<div class="entry-content">
						<p>Constructor de copia, sobrecarga de operadores.</p>
<p>cadena.h</p>
<div><div id="highlighter_765182" class="">{{page.snippets[0] | markdownify }}</div></div>
<p>cadena.cpp</p>
<div><div id="highlighter_521650" class="">{{page.snippets[1] | markdownify }}</div></div>
											</div>
