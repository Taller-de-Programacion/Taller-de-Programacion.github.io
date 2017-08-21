---
layout: post
title: Combos simples en gtkmm
author: Pablo Roca
date: 01/05/2017
tags: [gtkmm]
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de https://developer.gnome.org/gtkmm-tutorial/stable/sec-basics-simple-example.html.en
         *
         * Se compila con:
         * g++ main.cpp $(pkg-config --cflags --libs gtkmm-3.0)
         *
         */
         //Se incluyen todos los tipos de la librería (no óptimo) 
        #include <gtkmm.h>
        #include <iostream>
         //Función callback para la señal changed del combo. Muestra el valor actual por salida estándar
        void on_combo_changed(Gtk::ComboBoxText* combo){
            std::cout << "Elemento elegido: " << combo->get_active_text() << std::endl;
        }
          int main(int argc, char* argv[]){
          //Crea la aplicación de gtkmm sin nombre, contemplando argumentos externos
          //Admite un nombre como parámetro opcional para evitar ventanas duplicadas
          auto app = Gtk::Application::create(argc, argv);
           //Crea una ventana simple
          Gtk::Window ventana;
             //Crea el combo con sus items y un callback sobre la señal 'changed'
          Gtk::ComboBoxText combo;
          combo.append("Texto 1");
          combo.append("Texto 2");
          combo.append("Texto 3");
          combo.signal_changed().connect(sigc::bind(sigc::ptr_fun(&on_combo_changed), &combo));
            //Agrega el combo a la ventana y muestra el contenido
          ventana.add(combo);
          ventana.show_all();
           //Ejecuta la aplicación y bloquea hasta que el usuario decide salir
          return app->run(ventana);
        }
        ```

---
<div class="entry-content">
						<p>Agregamos un <a href="https://developer.gnome.org/gtkmm-tutorial/stable/chapter-combobox.html.en">combo</a> simple que admite sólo los textos que mostrará (string). Este caso se simplifica en gran medida si utilizamos un <a href="https://developer.gnome.org/gtkmm-tutorial/stable/combobox-example-simple.html.en">combo de texto</a> que hereda del combo original, ocultando la complejidad del esquema model-view y agregando funcionalidad sólo para textos.</p>
<p>Utilizamos la señal <em>changed</em> para mostrar el elemento elegido por el usuario a través de la salida estándar.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
