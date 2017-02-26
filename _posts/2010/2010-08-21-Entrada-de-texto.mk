---
layout: post
title: Entrada de texto
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de http://www.gtk.org/tutorial/
         *
         * Se compila con:
         * gcc -o entrada `pkg-config --cflags --libs gtk+-2.0` entrada.c
         *
         */
         #include <glib.h>
        #include <glib/gprintf.h>
        #include <gtk/gtk.h>
         /* Función 'callback' para atender la señal "clicked" del botón */
        static void on_boton_clicked(GtkWidget *widget, gpointer data)
        {
         /* convierto el dato adicional a un GtkEntry */
         GtkEntry* entrada = GTK_ENTRY(data);
          g_print("[recibido el evento clicked]\n");
          /* muestro el contenido de la entrada de texto */
         g_printf("Texto ingresado: %s\n", gtk_entry_get_text(entrada));
        }
         /* Función 'callback' para atender la señal del evento "delete_event" */
        static gboolean on_delete_event(GtkWidget *widget, GdkEvent *event,
         gpointer data)
        {
         g_print ("[recibido el evento delete_event]\n");
          return FALSE;
        }
         /* Función 'callback' para atender la señal "destroy" de la ventana. */
        static void destruir(GtkWidget *widget, gpointer data)
        {
         g_print ("[recibido el evento destroy]\n");
          /* finaliza el loop de gtk_main() y libera memoria */
         gtk_main_quit();
        }
         /* Programa */
        int main(int argc, char *argv[])
        {
         /* GtkWidget almacena cualquier tipo de widget */
         GtkWidget* ventana;
         GtkWidget* contenedor;
         GtkWidget* boton;
         GtkWidget* entrada;
          /* configura el idioma del GTK para que se ajuste al idioma del usuario */
         gtk_set_locale();
          /* procesa línea de comandos e inicializa */
         gtk_init(&argc, &argv);
          /********************************* VENTANA *******************************/
         /* creo ventana principal */
         ventana = gtk_window_new(GTK_WINDOW_TOPLEVEL);
          /* conecto la señal "delete_event" de la ventana a la callback
         * on_delete_event() */
         g_signal_connect(G_OBJECT(ventana), "delete_event",
         G_CALLBACK(on_delete_event), NULL);
          /* conecto la señal "destroy" de la ventana a la callback destruir()
         * esta señal se emite cuando se llama a gtk_widget_destroy() */
         g_signal_connect(G_OBJECT(ventana), "destroy", G_CALLBACK(destruir),
         NULL);
          /* pongo un borde a la ventana (espacio libre al rededor del borde) */
         gtk_container_set_border_width(GTK_CONTAINER(ventana), 10);
          /******************************** CONTENEDOR *****************************/
         /* creo un contenedor que divide horizontalmente para poner mis widgets
         * TRUE es para que todos los elementos sean de igual tamaño
         * 10 es para que deje 10 píxels entre los elementos */
         contenedor = gtk_hbox_new(TRUE, 10);
          /* agrega el contenedor a la ventana (que es un GtkContainer) */
         gtk_container_add(GTK_CONTAINER(ventana), contenedor);
          /**************************** ENTRADA DE TEXTO ***************************/
         /* creo una entrada de texto */
         entrada = gtk_entry_new();
          /* agrega la entrada de texto a la primera celda del contendor */
         gtk_container_add(GTK_CONTAINER(contenedor), entrada);
          /********************************** BOTON ********************************/
         /* creo un botón predefinido con un ícono de "Aceptar" */
         boton = gtk_button_new_from_stock("gtk-ok");
          /* conecto la señal "clicked" del botón a la callback on_boton_clicked()
         * y le envío el widget entrada como dato adicional */
         g_signal_connect(G_OBJECT(boton), "clicked", G_CALLBACK(on_boton_clicked),
         entrada);
          /* agrega el botón a la segunda celda del contendor */
         gtk_container_add(GTK_CONTAINER(contenedor), boton);
          /********************************* PROGRAMA ******************************/
         /* muestro la ventana y todos sus elementos */
         gtk_widget_show_all(ventana);
          /* comienza el loop de eventos */
         gtk_main();
          return 0;
        }
        ```

---
<div class="entry-content">
						<p>Agregamos una caja de 		<a href="http://library.gnome.org/devel/gtk/stable/GtkEntry.html">entrada de texto</a> y hacemos que al presionar el botón, se imprima 	       	el texto ingresado por el usuario por la salida estándar.</p>
<div><div id="highlighter_337368" class="">{{page.snippets[0] | markdownify }}</div></div>
											</div>
