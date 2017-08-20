---
layout: post
title: Entrada de texto
author: admin
date: 02/05/2017
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de http://www.gtk.org/tutorial/
         *
         * Se compila con:
         * gcc main.c $(pkg-config --cflags --libs gtk+-3.0)
         *
         */
         #include <glib.h>
        #include <glib/gprintf.h>
        #include <gtk/gtk.h>
         /* Función 'callback' para atender la señal "clicked" del botón */
        static void on_boton_clicked(GtkWidget *widget, gpointer data)
        {
          // convierto el dato adicional a un GtkEntry
          GtkEntry* entrada = GTK_ENTRY(data);
           g_print("[recibido el evento clicked]\n");
           // muestro el contenido de la entrada de texto
          g_printf("Texto ingresado: %s\n", gtk_entry_get_text(entrada));
        }
         //Callback para iniciar la aplicación
        static void activate (GtkApplication* app, gpointer data)
        {
          //Crea una ventana de aplicación
          GtkWidget *ventana = gtk_application_window_new(app);
           //Define su título y tamaño
          gtk_window_set_title(GTK_WINDOW(ventana), "Ejemplo");
           // creo un contenedor que divide horizontalmente para poner mis widgets
          // que deja 10 píxels entre los elementos
          GtkWidget* contenedor = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
           // agrega el contenedor a la ventana (que es un GtkContainer)
          gtk_container_add(GTK_CONTAINER(ventana), contenedor);
           // creo una entrada de texto
          GtkWidget* entrada = gtk_entry_new();
           // agrega la entrada de texto a la primera celda del contendor
          gtk_box_pack_start(GTK_BOX(contenedor), entrada, FALSE, FALSE, 0);
           // creo un botón predefinido con un ícono de "Aceptar"
          GtkWidget* boton = gtk_button_new_from_icon_name("gtk-ok", GTK_ICON_SIZE_BUTTON);
           // conecto la señal "clicked" del botón a la callback on_boton_clicked()
          // y le envío el widget entrada como dato adicional
          g_signal_connect(G_OBJECT(boton), "clicked", G_CALLBACK(on_boton_clicked), entrada);
           // agrega el botón a la segunda celda del contendor
          gtk_box_pack_start(GTK_BOX(contenedor), boton, FALSE, FALSE, 0);
           //Muestra todos sus componentes
          gtk_widget_show_all(ventana);
        }
         /* Programa */
        int main(int argc, char *argv[])
        {
          //Crea la aplicación sin nombre ni opciones particulares
          GtkApplication *app = gtk_application_new (NULL, G_APPLICATION_FLAGS_NONE);
          //Define el método de ejecución de la aplicación con el callback
          g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
          //Ejecuta la aplicación y bloquea
          int status = g_application_run(G_APPLICATION(app), argc, argv);
          //Libera el objeto app y todos sus recursos
          g_object_unref (app);
           return status;
        }
        ```

---
<div class="entry-content">
						<p>Agregamos una caja de <a href="http://library.gnome.org/devel/gtk/stable/GtkEntry.html">entrada de texto</a> y hacemos que al presionar el botón, se imprima el texto ingresado por el usuario por la salida estándar.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
