---
layout: post
title: Botón de Salir
author: Pablo Roca
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
        static void on_imprimir_clicked(GtkWidget *widget, gpointer data)
        {
          g_print("[recibido el evento clicked] Imprimir\n");
        }
         /* Función 'callback' para atender la señal "clicked" del botón */
        static void on_salir_clicked(GtkWidget *widget, gpointer data)
        {
          g_print("[recibido el evento clicked] Salir\n");
          g_application_quit(data);
        }
         /* Función 'callback' para atender la señal del evento "delete_event" */
        static gboolean on_delete_event(GtkWidget *widget, GdkEvent *event, gpointer data)
        {
          g_print ("[recibido el evento delete_event]\n");
          return FALSE;
        }
         /* Función 'callback' para atender la señal "destroy" de la ventana. */
        static void destruir(GtkWidget *widget, gpointer data)
        {
          g_print ("[recibido el evento destroy]\n");
        }
         //Callback para iniciar la aplicación
        static void activate (GtkApplication* app, gpointer data)
        {
          //Crea una ventana de aplicación
          GtkWidget *ventana = gtk_application_window_new(app);
           //Define su título y tamaño
          gtk_window_set_title(GTK_WINDOW(ventana), "Ejemplo");
           // conecto la señal "delete_event" de la ventana a la callback
          // on_delete_event()
          g_signal_connect(G_OBJECT(ventana), "delete_event", G_CALLBACK(on_delete_event), NULL);
           // conecto la señal "destroy" de la ventana a la callback destruir()
          // esta señal se emite cuando se llama a gtk_widget_destroy()
          g_signal_connect(G_OBJECT(ventana), "destroy", G_CALLBACK(destruir), NULL);
           // crea un contenedor que divide horizontalmente para poner mis widgets
          // que deja 10 píxels entre los elementos
          GtkWidget* contenedor = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
           // agrega el contenedor a la ventana (que es un GtkContainer)
          gtk_container_add(GTK_CONTAINER(ventana), contenedor);
           // crea un botón para imprimir y uno para salir
          GtkWidget* imprimir = gtk_button_new_from_icon_name("gtk-ok", GTK_ICON_SIZE_BUTTON);
          GtkWidget* salir = gtk_button_new_from_icon_name("gtk-quit", GTK_ICON_SIZE_BUTTON);
           // agrega los botones en el contenedor
          gtk_box_pack_start(GTK_BOX(contenedor), imprimir, FALSE, FALSE, 0);
          gtk_box_pack_start(GTK_BOX(contenedor), salir, FALSE, FALSE, 0);
           // conecto la señal "clicked" de los botones a los callbacks
          g_signal_connect(G_OBJECT(imprimir), "clicked", G_CALLBACK(on_imprimir_clicked), NULL);
          g_signal_connect(G_OBJECT(salir), "clicked", G_CALLBACK(on_salir_clicked), app);
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
						<p>Tomando el ejemplo de <a title="Ventana dummy" href="/2010/08/21/Ventana-dummy.html">Ventana Dummy</a>, agregamos manejadores para la señal de <strong>destroy</strong> y el evento <strong>delete_event</strong> que pertenecen a la ventana para detectar el momento en que el usuario la cierra. Como agregado, proveemos un botón de salida que cierra la aplicación llamando a <strong>g_application_quit()</strong>.</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
