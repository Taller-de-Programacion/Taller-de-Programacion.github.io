---
layout: post
title: Recorte de objetos (Object slicing)
author: admin
date: 03/04/2011
snippets: 
    - |
        ```cpp
        #include <iostream>
         class Padre {
        private:
         int v;
        public:
         Padre(int v) : v(v) {};
         virtual void show() { std::cout << v << std::endl; };
        };
         class Hijo : public Padre {
        private:
         char c;
        public:
         Hijo(int v, char c) : Padre(v), c(c) {};
         void show() { Padre::show(); std::cout << c << std::endl; };
        };
         void testSlicing(Padre p) {
         p.show();
        }
         int main(int argc, char ** argv) {
          Hijo h(10, 'x');
          testSlicing(h);
          return 0;
        }
        ```

    - |
        ```cpp
        void testSlicing(Padre * p) {
         p->show();
        }
         int main(int argc, char ** argv) {
          Hijo h(10, 'x');
          testSlicing(&h);
          return 0;
        }
        ```

---
<div class="entry-content">
						<p>Cuando se trabaja en C++ con objetos de una jerarquía de clases, es común que en alguna parte del programa un objeto de una clase derivada se tome como un objeto del tipo de la clase madre. Esto se conoce con el término <em>up casting</em> que indica justamente que se toma el objeto como un tipo superior dentro de la jerarquía de clases. Esta práctica es totalmente común en la programación orientada a objetos, pero en C++ se debe prestar especial cuidado ya que puede ocurrir que el objeto sea literalmente rebanado durante el up casting. Perdiéndose información y, si se trabaja con polimorfismo, comportamiento propio de la clase original.</p>
<div><div id="highlighter_300121" class="">{{page.snippets[0] | markdownify }}</div></div>
<p>En el ejemplo que presentamos se definieron dos clases completas, Padre e Hijo. Siendo la segunda derivada de la primera. En la función principal se crea un objeto del tipo Hijo y se realiza una llamada a la función <strong>testSlicing()</strong> que recibe por copia un objeto del tipo Padre.</p>
<p>Cuando la función es llamada el objeto del tipo Hijo debe copiarse en una variable automática llamada <strong>p</strong> que se encuentra en la pila. Esta variable, por ser del tipo Padre, sólo puede almacenar un entero. Que es la información declarada en la propia clase. Por lo tanto sólo esa porción de información del objeto original es copiada. El resto, ya que la clase Hijo puede almacenar un <strong>char</strong> también, se pierde. Asimismo el método <strong>show()</strong> ejecutado corresponde al de la clase Padre.</p>
<p style="text-align: left;"><a href="https://taller-de-programacion.github.io/assets/2011/04/slicing.png"><img class="size-full wp-image-433 aligncenter" title="Object slicing" src="http://7542.fi.uba.ar/wp-content/uploads/2011/04/slicing.png" alt="" width="318" height="78"></a>Para evitar que el objeto sea recortado es necesario utilizar punteros. Al eliminar la copia de memoria y utilizar una referencia a la memoria original, se mantiene toda la información. Tal como se muestra en la siguiente porción de código modificado:</p>
<p style="text-align: left;">
</p><div><div id="highlighter_921968" class="">{{page.snippets[1] | markdownify }}</div></div>
<p style="text-align: left;">Sólo se realizaron cambios en las líneas uno, dos y nueve. Esto código mantiene tanto la información (en realidad ya no hay copia) y mantiene el comportamiento. El método <strong>show() </strong>ejecutado ahora corresponde al de la clase Hijo.</p>
											</div>
