---
layout: post
title: Ventana gtkmm utilizando Application
author: Pablo Roca
date: 02/05/2017
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
         // Función 'callback' para atender la señal "clicked" del botón de salir
        void on_salir_clicked(Glib::RefPtr<Gtk::Application> app){
            std::cout << "[recibido el evento clicked]" << std::endl;
              //Salimos del loop de eventos
            app->quit();
        }
         int main(int argc, char *argv[])
        {
          //Crea la aplicación de gtkmm sin nombre, contemplando argumentos externos
          //Admite un nombre como parámetro opcional para evitar ventanas duplicadas
          auto app = Gtk::Application::create(argc, argv);
           //Crea una ventana simple con tamaño determinado
          Gtk::Window ventana;
          ventana.set_default_size(200, 200);
             //Crea el botón con texto y un callback sobre la señal 'clicked'
          Gtk::Button salir("Salir");
          salir.signal_clicked().connect(sigc::bind(sigc::ptr_fun(on_salir_clicked), app));
           //Agrega el botón a la ventana y muestra el contenido
          ventana.add(salir);
          ventana.show_all();
           //Ejecuta la aplicación y bloquea hasta que el usuario decide salir
          //con la cruz o hace un click en el botón.
          return app->run(ventana);
        }
        ```

---
<div class="entry-content">
						<p>Basándonos en el ejemplo de <a title="Ventana con botón en gtkmm" href="/2017/05/01/Ventana-con-boton-en-gtkmm.html">Ventana con botón en gtkmm</a>, re-escribimos el código utilizando el nuevo esquema de trabajo con Gtk::Application.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
