---
layout: post
title: Combos simples en gtkmm
author: Pablo Roca
date: 10/03/2011
tags: [C++ gtkmm]
---
Agregamos un [combo](http://library.gnome.org/devel/gtkmm-tutorial/stable/sec-combobox.html) simple que admite sólo los textos que mostrará (string). Este caso se simplifica en gran medida si utilizamos un [combo de texto](http://library.gnome.org/devel/gtkmm-tutorial/stable/sec-comboboxtext.html) que hereda del combo original, ocultando la complejidad del esquema model-view y agregando funcionalidad sólo para textos.

Utilizamos la señal *changed* para mostrar el elemento elegido por el usuario a través de la salida estándar.

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
