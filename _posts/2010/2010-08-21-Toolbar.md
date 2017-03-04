---
layout: post
title: Toolbar
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        /* vim: set et sw=4 sts=4 :
         *
         * Se compila con:
         * gcc -o toolbar `pkg-config --cflags --libs gtk+-2.0` toolbar.c
         *
         * Copyright (2008) Leandro Lucarella, under BOLA license:
         * http://auriga.wearlab.de/~alb/bola/
         */
         #include <glib.h>
        #include <gtk/gtk.h>
         /* forward declarations */
        static void destruir(GtkWidget* widget, gpointer data);
        static void on_load(GtkWidget* widget, gpointer data);
        static void on_save(GtkWidget* widget, gpointer data);
          struct app_t
        {
         GtkWidget* ventana;
         GtkWidget* imagen;
         GtkWidget* dialogo_cargar;
         GtkWidget* dialogo_guardar;
         char* filename;
        };
         /************************** FUNCIONES DE APP ********************************/
         static void app_init(struct app_t* app)
        {
         GtkWidget* toolbar;
         GtkWidget* vbox;
         GtkWidget* handlebox;
          /* por ahora no tenemos un archivo */
         app->filename = NULL;
          /********************************* VENTANA *******************************/
         /* creo ventana principal */
         app->ventana = gtk_window_new(GTK_WINDOW_TOPLEVEL);
          /* conecto la señal "destroy" de la ventana a la callback destruir()
         * esta señal se emite cuando se llama a gtk_widget_destroy() */
         g_signal_connect(G_OBJECT(app->ventana), "destroy", G_CALLBACK(destruir),
         NULL);
          /********************************** VBOX *********************************/
         /* creo un vbox para dividir la ventana en 2 verticalmente, así abajo
         * queda la imagen y arriba la barra de herramientas */
         vbox = gtk_vbox_new(FALSE, 0); /* los hijos no son iguales, 0 espacio) */
          /* agrego vbox a la ventana */
         gtk_container_add(GTK_CONTAINER(app->ventana), vbox);
          /******************************** HANDLEBOX ******************************/
         /* creo un HandleBox para poder desacoplar la barra de herramientas de la
         * ventana */
         handlebox = gtk_handle_box_new();
          /* agregar handlebox a vbox de forma que quede comprimido arriba de todo */
         gtk_box_pack_start(GTK_BOX(vbox), handlebox,
         FALSE, /* expandir? NO */
         FALSE, /* llenar? NO */
         0); /* espaciado */
          /********************************* TOOLBAR *******************************/
         /* crea una barra de herramientas */
         toolbar = gtk_toolbar_new();
          /* agregar botón de Cargar */
         gtk_toolbar_append_item(GTK_TOOLBAR(toolbar),
         "Cargar", /* texto para el botón */
         "Carga un mapa", /* texto para el tooltip */
         "Private", /* private tooltip, para usar con GtkTipsQuery */
         gtk_image_new_from_stock("gtk-open", 24), /* icono */
         G_CALLBACK(on_load), /* callback */
         app); /* user data */
          /* agregar botón de Guardar pero del stock */
         gtk_toolbar_insert_stock(GTK_TOOLBAR(toolbar),
         "gtk-save", /* stock id */
         "Guarda un mapa",  /* texto para el tooltip */
         "Private", /* private tooltip, para usar con GtkTipsQuery */
         G_CALLBACK(on_save), /* callback */
         app, /* user data */
         -1); /* posición (-1 es para insertar al final) */
          /* agregar toolbar al handlebox (para que se pueda desacoplar) */
         gtk_container_add(GTK_CONTAINER(handlebox), toolbar);
          /********************************** IMAGEN *******************************/
         /* creo una imagen a partir de un archivo inexistente para que se muestre el
         * ícono de roto */
         app->imagen = gtk_image_new_from_file("/");
          /* agrega la imagen a la ventana (que es un GtkContainer) */
         gtk_container_add(GTK_CONTAINER(vbox), app->imagen);
          /* creo dialogo de cargar */
         app->dialogo_cargar = gtk_file_chooser_dialog_new("Cargar Imagen",
         GTK_WINDOW(app->ventana),
         GTK_FILE_CHOOSER_ACTION_OPEN,
         GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
         GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
         NULL);
          /* creo dialogo de guardar */
         app->dialogo_guardar = gtk_file_chooser_dialog_new("Guardar Imagen",
         GTK_WINDOW(app->ventana),
         GTK_FILE_CHOOSER_ACTION_SAVE,
         GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
         GTK_STOCK_SAVE, GTK_RESPONSE_ACCEPT,
         NULL);
          /* pedimos que pregunte por confirmación si el archivo existe */
         gtk_file_chooser_set_do_overwrite_confirmation(
         GTK_FILE_CHOOSER(app->dialogo_guardar),
         TRUE);
        }
         static void app_show(struct app_t* app)
        {
         /* muestro la ventana y todos sus hijos */
         gtk_widget_show_all(app->ventana);
        }
         static void app_destroy(struct app_t* app)
        {
         /* liberar el string con el nombre de archivo */
         if (app->filename)
         g_free(app->filename);
          /* liberar dialogos */
         gtk_widget_destroy(app->dialogo_cargar);
         gtk_widget_destroy(app->dialogo_guardar);
        }
         static gboolean app_load_image(struct app_t* app)
        {
         GtkWidget* dialog = app->dialogo_cargar;
          if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT)
         {
         /* la primera vez que se llama a load_image() no hay filename, el resto
         * de las veces sí, así que hay que liberar la memoria del filename
         * viejo */
         if (app->filename)
         g_free(app->filename);
         app->filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
         gtk_image_set_from_file(GTK_IMAGE(app->imagen), app->filename);
         gtk_widget_hide(dialog);
         return TRUE;
         }
         gtk_widget_hide(dialog);
         return FALSE;
        }
         static void app_save_image(struct app_t* app)
        {
         GtkWidget* dialog = app->dialogo_guardar;
          /* ponemos como base, el nombre del archivo abierto */
         gtk_file_chooser_set_filename(GTK_FILE_CHOOSER(app->dialogo_guardar),
         app->filename);
          if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT)
         {
         /* cuando se llama a este evento, siempre había previamente un filename
         * asociado, así que hay que liberarlo incondicionalmente */
         g_free(app->filename);
         app->filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
         gdk_pixbuf_save(gtk_image_get_pixbuf(GTK_IMAGE(app->imagen)),
         app->filename,
         "png", /* formato */
         NULL,   /* error */
         NULL);  /* parámetros opcionales */
         }
          gtk_widget_hide(dialog);
        }
         /****************************** CALLBACKS ***********************************/
         /* Función 'callback' para atender la señal "destroy" de la ventana. */
        static void destruir(GtkWidget* widget, gpointer data)
        {
         g_print ("[recibido el evento destroy]\n");
          /* finaliza el loop de gtk_main() y libera memoria */
         gtk_main_quit();
        }
         /* Función callback para cuando se apreta el botón de Cargar */
        static void on_load(GtkWidget* widget, gpointer data)
        {
         g_print ("[recibido el evento de botón de Cargar de toolbar]\n");
         app_load_image((struct app_t*) data);
        }
         /* Función callback para cuando se apreta el botón de Guardar */
        static void on_save(GtkWidget* widget, gpointer data)
        {
         g_print ("[recibido el evento de botón de Guardar de toolbar]\n");
         app_save_image((struct app_t*) data);
        }
          /***************************** PROGRAMA *************************************/
         int main(int argc, char* argv[])
        {
         /* GtkWidget almacena cualquier tipo de widget */
         struct app_t app;
          /* inicializamos aplicación */
         gtk_init(&argc, &argv);
          /* inicializamos aplicación */
         app_init(&app);
          /* si apretó cancelar al cargar imagen, salimos */
         if (!app_load_image(&app))
         return 1;
          /* si no, empezamos la aplicación */
         app_show(&app);
          /* comienza el loop de eventos */
         gtk_main();
          /* libera recursos de la aplicación */
         app_destroy(&app);
          return 0;
        }
        ```

---
<div class="entry-content">
						<p>Extiende el ejemplo anterior agregando una   		<a href="http://library.gnome.org/devel/gtk/stable/GtkToolbar.html">barra 		de herramientas</a> <a href="http://library.gnome.org/devel/gtk/stable/GtkHandleBox.html">flotante</a> para <a href="http://library.gnome.org/devel/gtk/stable/GtkFileChooser.html">cargar 		o guardar</a> la imagen.</p>
<div><div id="highlighter_355167" class="">{{page.snippets[0] | markdownify }}</div></div>
											</div>
