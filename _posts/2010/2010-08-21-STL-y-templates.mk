---
layout: post
title: STL y templates
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        #ifndef _TEMPLATES_H_
        #define _TEMPLATES_H_
         template <typename T> class Vector {
        T* v;
        int sz;
        public:
        Vector (int s) { v = new T [sz = s]; }
        ~Vector () { if (v) delete[] v; }
        //vector "circular"
        T& operator[] (int i) const { return v[i%sz];}
        int get_size() { return sz; }
        bool operator< (const Vector&) const;
        };
          template <typename T> bool Vector<T>::operator < (const Vector &v2) const
        {
        //si todos los componentes son menores -> el vector es menor.
        for (int i=0; i<sz; i++)
        if (v[i]>=v2[i]) return false;
        return true;
        }
         //especializacion de la template.
        template <> class Vector<char> {
        char* v;
        int sz;
        public:
        Vector (int s) { v = new char[sz = s]; }
        ~Vector () { if (v) delete[] v; }
        //vector "circular"
        const char& operator[] (int i) const { return v[i%sz]; }
        int get_size() { return sz; }
        /*
        Remarcar lo del CONST que si lo saco a operator[], no anda el
        operator <
        */
        bool operator< (const Vector& v2) const
        { //si todos los componentes son menores -> el vector es menor.
        for (int i=0; i<sz; i++)
        if (v[i]>=v2[i]) return false;
        return true;
        }
        };
         #endif // _TEMPLATES_H_
        ```

    - |
        ```cpp
        #include "templates.h"
         #include <iostream>
         #include <vector>
         #include <string>
          typedef Vector<char> VecChar;
         /*
         Se hace para ahorrarn escritura o si lo hago el el .h
         le hago usar una clase cuando en realidad es un template.
         */
           typedef std::vector<int> stdVecInt;
         typedef std::string stdString;
          int main (void)
         {
         // Usamos cout para escribir menos
         using std::cout;
          /*****************************************************************/
         /*        PARTE DE TEMPLATES.                                         */
          Vector<int>        int_vector (10);
         Vector<float>    float_vector(10);
         VecChar            char_vector (10);
            for (int i=0; i<10; i++)
         {
         int_vector[i]=i;
         cout<<int_vector[i]<<"\n";
         }
            /*****************************************************************/
          /****************************************************************/
         /*            PARTE DE STL                                        */
         cout<<"Parte de la STL\n";
          stdVecInt v(3); //me reserva 3 lugares cuado lo contruye
          v[0] = 5;
         v[1] = 2;
         v[2] = 7;
          cout<<"tamaño antes de push_back: "<<v.capacity()<<"\n";
         v.push_back(10);  //tambien existe el pop_back
         cout<<"tamaño despues de push_back: "<<v.capacity()<<"\n";
         //verificamos que push_back dobla la capacidad actual.
          /*
         Hay que tener en cuenta que tengo que instanciar el iterador
         adecuado para recorrer al contenedor. Para no tener problemas
         con esto, las clases de la STL incluyen a los iteradores como
         subClases y uno tiene que instanciar los iteradores contenidos
         en la clase, es decir no puedo instanciar un iterador de lista
         para recorrer un Vector.
         */
          stdVecInt::iterator iFirst = v.begin();
         //me devuelve un iterador del tipo std::vector<int>::iterator.
         stdVecInt::iterator iLast  = v.end();
         //El iLast apunta a un elemento despues del final del vector
         stdVecInt::iterator iV = v.begin();
          iV+=1; //tienen sobrecargado el operador += (iV apuntando a 2);
          /* El insertar sobre el primer elemento me hace que sean
         inválidos todos los iteradores que estén apuntando
         a elemento a la "derecha" del punto de inserción.
         En nuestro caso el iLast quedaría inválido.*/
         v.insert(iFirst,456);
          v.insert(iLast,20);  //en realidad no estoy insertando en
         //el ultimo. (resultado no garantizado);
         iLast = v.end();
          //    iLast=v.erase(iLast);  //estoy queriendo borrar una memoria
         //que nunca inicialice (excepcion).
          iLast=v.erase(--iLast); //solucion correcta.
          /*
         Tener muy en cuenta que si se produce realocacion, ningun
         iterador es válido.
         */
          while (iV != iLast)
         cout << *iV++ << " ";
         //primero se desreferencia y despues se incrementa.
          cout<<"\n";
          /* POSIBILIDADES QUE OFRECE LA BASIC_STRING    */
          stdString str1("012345"), str2("6789");
          cout<<"\nPARTE DE LA STRING\n";
          str1.append(str2); //existen 6 sobrecargadas de append.
          str2="456"; //operador = sobrecargado.
          char cadena[]="HOLA";
         str2.append(cadena);  //append de cadena literal.
          cout<<str2.c_str()<<"\n"; //devuelve una string de c cte.
          /*comparacion contra literal*/
         stdString s1("TORTITA");
          if (s1=="TORTITA")
         cout<<"Es una tortita\n";
         else cout<<"Es otra cosa\n";
          /*Concatenacion*/
         stdString s2= s1+str2;
         cout<<s2.c_str()<<"\n";
          return 0;
          }
        ```

---
<div class="entry-content">
						<p>STL – templates</p>
<p>templates.h</p>
<div><div id="highlighter_448851" class="">{{page.snippets[0] | markdownify }}</div></div>
<p>templates.cpp</p>
<div><div id="highlighter_426688" class="">{{page.snippets[1] | markdownify }}</div></div>
											</div>
