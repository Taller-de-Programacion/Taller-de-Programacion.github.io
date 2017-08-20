---
layout: post
title: Ventana con herencia y atributos
author: Pablo Roca
date: 02/05/2017
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de https://developer.gnome.org/gtkmm-tutorial/stable/sec-helloworld.html.en
         *
         * Se compila con:
         * g++ main.cpp $(pkg-config --cflags --libs gtkmm-3.0)
         *
         */
         #include <gtkmm/button.h>
        #include <gtkmm/window.h>
        #include <iostream>
         //Ventana 'custom'. Extiende Gtk::Window con un botón y su comportamiento
        class CustomWindow : public Gtk::Window
        {
        public:
          CustomWindow();
        private:
          void on_button_clicked();
          Gtk::Button boton;
        };
         //Construye la ventana con un botón. Vincula el click del botón con su callback
        CustomWindow::CustomWindow()
        : boton("Print") //Construye el botón con el texto 'Print'
        {
          set_default_size(200, 200);
          set_border_width(10);
          boton.signal_clicked().connect(sigc::mem_fun(*this,
                      &CustomWindow::on_button_clicked));
          add(boton);
          boton.show();
        }
         //Método de callback para el click del botón. Imprime 'Hola Mundo'
        void CustomWindow::on_button_clicked()
        {
          std::cout << "Hola Mundo" << std::endl;
        }
         int main(int argc, char** argv)
        {
           //Crea una aplicación simple para desplegar la ventana
          auto app = Gtk::Application::create(argc, argv);
           //Crea una ventana con un botón visible
          CustomWindow ventana;
          //Ejecuta la aplicación y bloquea hasta que se destruye la ventana
          return app->run(ventana);
        }
        ```

---
<div class="entry-content">
						<p>Basándonos en el ejemplo de una <a title="Ventana gtkmm utilizando Application" href="/2017/05/02/Ventana-gtkmm-utilizando-Application.html">Ventana con Botón utilizando Gtk::Application</a>, construimos una pequeña clase que encapsula el contenido visual y los manejadores requeridos.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
