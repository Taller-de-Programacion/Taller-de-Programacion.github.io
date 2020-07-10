---
layout: post
title: Imágen y MessageDialog
author: admin
date: 21/08/2010
tags: [C gtk]
---

Una ventana que muestra una [imagen](http://library.gnome.org/devel/gtk/stable/GtkImage.html) cargada a través de un [PixBuf](http://library.gnome.org/devel/gdk-pixbuf/stable/) y reporta errores al cargar la imagen a través de una [ventana](http://library.gnome.org/devel/gtk/stable/GtkMessageDialog.html) de diálogo de mensajes

```cpp
/* vim: set et sw=4 sts=4 :
 *
 * Se compila con:
 * gcc -o imagen `pkg-config --cflags --libs gtk+-2.0` imagen.c
 *
 * Copyright (2008) Leandro Lucarella, under BOLA license:
 * http://auriga.wearlab.de/~alb/bola/
 */
#include <glib.h>
#include <gtk/gtk.h>

/* Función 'callback' para atender la señal "destroy" de la ventana. */
static void destruir(GtkWidget* widget, gpointer data);

/* Programa */
int main(int argc, char* argv[]) {
  /* GtkWidget almacena cualquier tipo de widget */
  GtkWidget* ventana;
  GtkWidget* imagen;
  GdkPixbuf* pixbuf;
  gtk_init(&argc, &argv);
  /* chequeo de parámetros */
  if (argc < 2) {
    g_printerr("Necesito una imagen! Uso: %s imagen\n", argv[0]);
    return 1;
  }
  /* cargo imagen desde archivo */
  pixbuf = gdk_pixbuf_new_from_file(argv[1], /* error */ NULL);
  if (!pixbuf) {
    gint result;
    /* hubo un error, mostramos un mensaje a través de un diálogo */
    GtkWidget* dialog = gtk_message_dialog_new(NULL, /* padre */
      0, /* flags */
      GTK_MESSAGE_ERROR, /* imagen */
      GTK_BUTTONS_CLOSE, /* botones */
      "No se pudo cargar la imagen %s.\n", argv[1]); /* mensaje */
    /* muestra el diálogo bloqueando hasta que apretan un botón
    * en "result" queda qué botón fue apretado (por ejemplo
    * GTK_RESPONSE_CLOSE) */
    result = gtk_dialog_run(GTK_DIALOG(dialog));
    /* tenemos que destruir el diálogo nosotros después de usarlo si no
    * tiene un padre o no usamos el flag GTK_DIALOG_DESTROY_WITH_PARENT */
    gtk_widget_destroy(dialog);
    return 1;
  }
  /********************************* VENTANA *******************************/
  /* creo ventana principal */
  ventana = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  /* conecto la señal "destroy" de la ventana a la callback destruir()
  * esta señal se emite cuando se llama a gtk_widget_destroy() */
  g_signal_connect(G_OBJECT(ventana), "destroy", G_CALLBACK(destruir),
  NULL);
  /* pongo un borde a la ventana (espacio libre al rededor del borde) */
  gtk_container_set_border_width(GTK_CONTAINER(ventana), 10);
  /********************************** IMAGEN *******************************/
  /* creo una imagen a partir del pixbuf */
  imagen = gtk_image_new_from_pixbuf(pixbuf);
  /*imagen = gtk_image_new_from_file(argv[1]);*/
  /* agrega la imagen a la ventana (que es un GtkContainer) */
  gtk_container_add(GTK_CONTAINER(ventana), imagen);
  /********************************* PROGRAMA ******************************/
  /* muestro la ventana y todos sus hijos */
  gtk_widget_show_all(ventana);
  /* comienza el loop de eventos */
  gtk_main();
  return 0;
}

static void destruir(GtkWidget* widget, gpointer data) {
  g_print ("[recibido el evento destroy]\n");
  /* finaliza el loop de gtk_main() y libera memoria */
  gtk_main_quit();
}
```