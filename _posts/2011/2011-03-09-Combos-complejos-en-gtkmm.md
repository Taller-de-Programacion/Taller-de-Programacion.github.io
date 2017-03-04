---
layout: post
title: Combos complejos en gtkmm
author: Pablo Roca
date: 09/03/2011
snippets: 
    - |
        ```cpp
        #include <gtkmm.h>
        #include <iostream>
         //Clase que mantiene la estructura del modelo a utilizar en el combo
        class ColumnasModelo: public Gtk::TreeModel::ColumnRecord{
        private:
            Gtk::TreeModelColumn<int> columnaValor;
            Gtk::TreeModelColumn<Glib::ustring> columnaTexto;
        public:
            ColumnasModelo(){
                //El modelo tendrá dos columnas: la primera con el valor entero, la segunda con el texto string unicode.
                add(columnaValor);
                add(columnaTexto);
            }
            Gtk::TreeModelColumn<int>& getColumnaValor(){
                return columnaValor;
            }
            Gtk::TreeModelColumn<Glib::ustring>& getColumnaTexto(){
                return columnaTexto;
            }
        };
         //Función callback para la señal changed del combo. Muestra el valor actual por salida estándar
        void on_combo_changed(Gtk::ComboBox* combo, ColumnasModelo* columnas){
            if (combo->get_active()){
                Gtk::TreeModel::Row fila = *combo->get_active();
                std::cout << "Elemento elegido: " << fila[columnas->getColumnaTexto()] << " con valor: " << fila[columnas->getColumnaValor()] << std::endl;
            }
        }
         int main(int argc, char* argv[]){
            //Inicializamos el framework
            Gtk::Main kit(argc, argv);
             //Creamos las columnas, el modelo y el combo que en este caso será la vista para el modelo planteado
            ColumnasModelo columnas;
            Glib::RefPtr<Gtk::ListStore> modelo = Gtk::ListStore::create(columnas);
            Gtk::ComboBox combo;
             //Establecemos el modelo del combo e indicamos las columnas a mostrar
            combo.set_model(modelo);
            //No es necesario agregar la columna valor si sólo queremos mostrar el texto
            //combo.pack_start(columnas.getColumnaValor());
            combo.pack_start(columnas.getColumnaTexto());
             //Agregamos las filas
            Gtk::TreeModel::Row fila = *(modelo->append());
            fila[columnas.getColumnaValor()] = 1;
            fila[columnas.getColumnaTexto()] = "Texto 1";
             fila = *(modelo->append());
            fila[columnas.getColumnaValor()] = 2;
            fila[columnas.getColumnaTexto()] = "Texto 2";
             //Conectamos un callback a la señal changed del combo
            combo.signal_changed().connect(sigc::bind(sigc::ptr_fun(&on_combo_changed), &combo, &columnas));
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
						<p>Agregamos un <a href="http://library.gnome.org/devel/gtkmm-tutorial/stable/sec-combobox.html">combo</a> complejo que admite elementos con valor (entero) y texto (string). Para aceptar esta estructura se la debe definir en un modelo e indicarle al combo que auspicie de vista para el mismo. Ver el <a href="http://library.gnome.org/devel/gtkmm-tutorial/2.91/chapter-combobox.html">tutorial de <em>gtkmm</em></a> para entender el concepto de <em>view-model</em> utilizado en este tipo de controles.</p>
<p>Utilizamos la señal <em>changed</em> para mostrar el elemento elegido por el usuario a través de la salida estándar.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
