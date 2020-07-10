---
layout: post
title: Ventana con botón en GTK+
author: admin
date: 21/08/2010
tags: [C GTK+]
snippets: 
    - |
        ```cpp
        //Callback para imprimir 'Hola Mundo'
        static void print(GtkWidget *widget, gpointer data)
        {
          g_print ("Hola Mundo\n");
        }
           ...
          GtkWidget *button = gtk_button_new_with_label("Imprimir");
          g_signal_connect(button, "clicked", G_CALLBACK(print), NULL);
          ...
        ```

    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de https://developer.gnome.org/gtk3/stable/gtk-getting-started.html
         *
         * Se compila con:
         * gcc main.c $(pkg-config --cflags --libs gtk+-3.0)
         *
         */
         //Se incluyen todos los tipos de la librería (no óptimo) 
        #include <gtk/gtk.h>
          //Callback para imprimir 'Hola Mundo'
        static void print(GtkWidget *widget, gpointer data)
        {
          g_print ("Hola Mundo\n");
        }
          //Callback para iniciar la aplicación
        static void activate(GtkApplication* app, gpointer data)
        {
          //Crea una ventana de aplicación
          GtkWidget *window = gtk_application_window_new(app);
          //Define su título y tamaño
          gtk_window_set_title(GTK_WINDOW(window), "Ejemplo");
          gtk_window_set_default_size(GTK_WINDOW(window), 200, 200);
          //Crea un área para contener al botón
          GtkWidget *box = gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
          gtk_container_add(GTK_CONTAINER(window), box);
          //Crea al botón y registra la señal de clicked
          GtkWidget *button = gtk_button_new_with_label("Imprimir");
          g_signal_connect(button, "clicked", G_CALLBACK(print), NULL);
          gtk_container_add(GTK_CONTAINER(box), button);
           //Muestra todos sus componentes
          gtk_widget_show_all(window);
        }
          int main (int argc, char **argv)
        {
          //Crea la aplicación sin nombre ni opciones particulares
          GtkApplication *app = gtk_application_new (NULL, G_APPLICATION_FLAGS_NONE);
          //Define el método de ejecución de la aplicación con el callback
          g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
          //Ejecuta la aplicación y bloquea
          int status = g_application_run (G_APPLICATION (app), argc, argv);
          //Libera el objeto app y todos sus recursos
          g_object_unref (app);
           return status;
        }
        ```

---
<div class="entry-content">
						<p>Tomando el ejemplo de <a title="Ventana dummy" href="/2010/08/21/Ventana-dummy.html">Ventana Dummy</a>, agregamos un botón que utiliza <a href="https://developer.gnome.org/gtk-tutorial/stable/x159.html">señales</a> para imprimir <a href="https://developer.gnome.org/glib/stable/glib-Warnings-and-Assertions.html"> un mensaje por salida estándar</a>:</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
<p>Integrando el bloque anterior con la estructura simple de aplicación en GTK+ obtenemos:</p>
<div><div>{{page.snippets[1] | markdownify }}</div></div>
											</div>
