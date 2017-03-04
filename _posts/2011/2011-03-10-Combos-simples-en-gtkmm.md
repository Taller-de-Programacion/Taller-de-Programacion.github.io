---
layout: post
title: Combos simples en gtkmm
author: Pablo Roca
date: 10/03/2011
snippets: 
    - |
        ```cpp
        #include <gtkmm.h>
        #include <iostream>
         //Función callback para la señal changed del combo. Muestra el valor actual por salida estándar
        void on_combo_changed(Gtk::ComboBoxText* combo){
            std::cout << "Elemento elegido: " << combo->get_active_text() << std::endl;
        }
         int main(int argc, char* argv[]){
            //Inicializamos el framework
            Gtk::Main kit(argc, argv);
             Gtk::ComboBoxText combo;
             //Agregamos las filas
            combo.append_text("Texto 1");
            combo.append_text("Texto 2");
             //Conectamos un callback a la señal changed del combo
            combo.signal_changed().connect(sigc::bind(sigc::ptr_fun(&on_combo_changed), &combo));
             //Creamos la ventana, agregamos el combo y mostramos el contenido
            Gtk::Window ventana;
            ventana.add(combo);
            ventana.show_all();
             //Iniciamos el loop de eventos
            Gtk::Main::run(ventana);
            return 0;
        }
        ```

---
<div class="entry-content">
						<p>Agregamos un <a href="http://library.gnome.org/devel/gtkmm-tutorial/stable/sec-combobox.html">combo</a> simple que admite sólo los textos que mostrará (string). Este caso se simplifica en gran medida si utilizamos un <a href="http://library.gnome.org/devel/gtkmm-tutorial/stable/sec-comboboxtext.html">combo de texto</a> que hereda del combo original, ocultando la complejidad del esquema model-view y agregando funcionalidad sólo para textos.</p>
<p>Utilizamos la señal <em>changed</em> para mostrar el elemento elegido por el usuario a través de la salida estándar.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
