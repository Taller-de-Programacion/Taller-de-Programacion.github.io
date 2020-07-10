---
layout: post
title: Ventana dummy
author: admin
date: 21/08/2010
tags: [C GTK+]
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Basado en un ejemplo de 
         * https://developer.gnome.org/gtk3/stable/gtk-getting-started.html
         *
         * Se compila con:
         * gcc main.c $(pkg-config --cflags --libs gtk+-3.0)
         *
         */
         //Se incluyen todos los tipos de la librería (no óptimo) 
        #include <gtk/gtk.h>
          //Callback para iniciar la aplicación
        static void activate (GtkApplication* app, gpointer data)
        {
          //Crea una ventana de aplicación
          GtkWidget *window = gtk_application_window_new(app);
          //Define su título y tamaño
          gtk_window_set_title(GTK_WINDOW(window), "Ejemplo");
          gtk_window_set_default_size(GTK_WINDOW(window), 200, 200);
          //Muestra todos sus componentes
          gtk_widget_show_all(window);
        }
         int main (int argc, char **argv)
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
						<p>Una <a href="http://library.gnome.org/devel/gtk/stable/GtkWindow.html">ventana</a> que no hace nada, lo más simple que se puede hacer en GTK+.</p>
<p>ventana.c</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
											</div>
