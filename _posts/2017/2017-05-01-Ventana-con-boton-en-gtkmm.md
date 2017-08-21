---
layout: post
title: Ventana con botón en gtkmm
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
         #include <gtkmm.h>
        #include <iostream>
          // Función 'callback' para atender la señal "clicked" del botón
        void on_button_clicked(){
            std::cout << "[recibido el evento clicked]" << std::endl;
              //Salimos del loop de eventos
            Gtk::Main::quit();
        }
          int main(int argc, char* argv[]){
            //Inicializamos el framework
            Gtk::Main kit(argc, argv);
              //Creamos el botón con texto y un callback sobre la señal 'clicked'
            Gtk::Button boton("Apretame!");
            boton.signal_clicked().connect(sigc::ptr_fun(&on_button_clicked));
              //Creamos la ventana y agregamos el botón
            Gtk::Window ventana;
            ventana.add(boton);
              //Mostramos el botón que contiene la ventana
            ventana.show_all();
              //Comienza el loop de eventos
            Gtk::Main::run(ventana);
            return 0;
        }
        ```

---
<div class="entry-content">
						<p>Agregamos un <a href="http://library.gnome.org/devel/gtkmm-tutorial/stable/chapter-button-widget.html">botón</a> que cierra la ventana introduciendo el uso de <a href="http://library.gnome.org/devel/gtkmm-tutorial/stable/chapter-signals.html">señales</a> y da un mensaje por la salida estándar con el método recomendado en <em>gtkmm</em>.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
