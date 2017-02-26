---
layout: post
title: GTK+ y pthread
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        /*
         * Ejemplo de progress bar usando POSIX Threads.
         *
         * Este ejemplo está basado en el ejemplo de progress bar del tutorial de GTK+
         * al que se le agregó un thread que va cambiando el porcentaje de manera
         * aleatoria.
         *
         * http://www.gtk.org/tutorial/sec-progressbars.html
         *
         * Modificado por Leandro Lucarella [luca en llucax.hn.org]
         * sáb may 21 16:32:22 ART 2005
         *
         */
         #include <stdlib.h>
        #include <unistd.h>
        #include <pthread.h>
        #include <gtk/gtk.h>
         typedef struct _ProgressData {
         GtkWidget *window;
         GtkWidget *pbar;
         int timer;
         gboolean activity_mode;
         gdouble val;
         /* mutex para el valor que será accedido desde varios threads */
         pthread_mutex_t val_mutex;
        } ProgressData;
         /* indica si hay un thread andando (no lo protejo porque es trivial y lo peor
         * que puede pasar en los casos límite es que se lancen 2 threads, avanzando
         * más rápido el contador, o que no se lance un nuevo thread al apretar limpiar
         * y haya que apretarlo de nuevo, dos efectos que no son graves para este
         * ejemplo en particular) */
        int running = 0;
         /* Función que corre en un thread y va actualizando el contador */
        static void* count_add(void* data)
        {
         ProgressData* pdata = (ProgressData*)data;
         running = 1; /* empezó a correr */
         pthread_mutex_lock(&(pdata->val_mutex));
         pdata->val = 0.0; /* reseteo contador */
         while (pdata->val < 1.0)
         {
         pdata->val += 0.05;
         if (pdata->val > 1.0) pdata->val = 1.0; /* error de redondeo */
         pthread_mutex_unlock(&(pdata->val_mutex));
         usleep(rand()%400000+100000); /* duerme entre 0.1 y 0.4 segundos */
         pthread_mutex_lock(&(pdata->val_mutex));
         }
         pthread_mutex_unlock(&(pdata->val_mutex));
         running = 0;
         return NULL;
        }
         /* Callback para resetear el contador */
        static void count_reset( GtkWidget    *widget,
         ProgressData *pdata )
        {
         /* si no está corriendo, lo lanzo de nuevo */
         if (!running)
         {
         /* creo un nuevo thread y lo 'libero' */
         pthread_t thread;
         pthread_create(&thread, NULL, count_add, pdata);
         pthread_detach(thread);
         }
         else /* si está corriendo, lo reseteo */
         {
         pthread_mutex_lock(&(pdata->val_mutex));
         pdata->val = 0.0;
         pthread_mutex_unlock(&(pdata->val_mutex));
         }
        }
         /* Update the value of the progress bar so that we get
         * some movement */
        static gboolean progress_timeout( gpointer data )
        {
         ProgressData *pdata = (ProgressData *)data;
          if (pdata->activity_mode)
         gtk_progress_bar_pulse (GTK_PROGRESS_BAR (pdata->pbar));
         else
         {
         gdouble new_val;
         /* obtengo el valor lockeando para que no lo corrompa otro thread mientras
         * lo obtengo */
         pthread_mutex_lock(&(pdata->val_mutex));
         new_val = pdata->val;
         pthread_mutex_unlock(&(pdata->val_mutex));
          /* Set the new value */
         gtk_progress_bar_set_fraction (GTK_PROGRESS_BAR (pdata->pbar), new_val);
         }
          /* As this is a timeout function, return TRUE so that it
         * continues to get called */
         return TRUE;
        }
         /* Callback that toggles the text display within the progress bar trough */
        static void toggle_show_text( GtkWidget    *widget,
         ProgressData *pdata )
        {
         const gchar *text;
          text = gtk_progress_bar_get_text (GTK_PROGRESS_BAR (pdata->pbar));
         if (text && *text)
         gtk_progress_bar_set_text (GTK_PROGRESS_BAR (pdata->pbar), "");
         else
         gtk_progress_bar_set_text (GTK_PROGRESS_BAR (pdata->pbar), "some text");
        }
         /* Callback that toggles the activity mode of the progress bar */
        static void toggle_activity_mode( GtkWidget    *widget,
         ProgressData *pdata )
        {
         pdata->activity_mode = !pdata->activity_mode;
         if (pdata->activity_mode)
         gtk_progress_bar_pulse (GTK_PROGRESS_BAR (pdata->pbar));
         else
         gtk_progress_bar_set_fraction (GTK_PROGRESS_BAR (pdata->pbar), 0.0);
        }
         /* Callback that toggles the orientation of the progress bar */
        static void toggle_orientation( GtkWidget    *widget,
         ProgressData *pdata )
        {
         switch (gtk_progress_bar_get_orientation (GTK_PROGRESS_BAR (pdata->pbar))) {
         case GTK_PROGRESS_LEFT_TO_RIGHT:
         gtk_progress_bar_set_orientation (GTK_PROGRESS_BAR (pdata->pbar),
         GTK_PROGRESS_RIGHT_TO_LEFT);
         break;
         case GTK_PROGRESS_RIGHT_TO_LEFT:
         gtk_progress_bar_set_orientation (GTK_PROGRESS_BAR (pdata->pbar),
         GTK_PROGRESS_LEFT_TO_RIGHT);
         break;
         default:;
         /* do nothing */
         }
        }
         /* Clean up allocated memory and remove the timer */
        static void destroy_progress( GtkWidget    *widget,
         ProgressData *pdata)
        {
         g_source_remove (pdata->timer);
         pdata->timer = 0;
         pdata->window = NULL;
         g_free (pdata);
         pthread_mutex_destroy(&(pdata->val_mutex));
         gtk_main_quit ();
        }
         int main( int   argc,
         char *argv[])
        {
         pthread_t thread;
         ProgressData *pdata;
         GtkWidget *align;
         GtkWidget *separator;
         GtkWidget *table;
         GtkWidget *button;
         GtkWidget *check;
         GtkWidget *vbox;
          gtk_init (&argc, &argv);
          /* Allocate memory for the data that is passed to the callbacks */
         pdata = g_malloc (sizeof (ProgressData));
          /* Inicializo mutex */
         pthread_mutex_init(&(pdata->val_mutex), NULL);
          pdata->window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
         gtk_window_set_resizable (GTK_WINDOW (pdata->window), TRUE);
          g_signal_connect (G_OBJECT (pdata->window), "destroy",
         G_CALLBACK (destroy_progress),
         (gpointer) pdata);
         gtk_window_set_title (GTK_WINDOW (pdata->window), "GtkProgressBar");
         gtk_container_set_border_width (GTK_CONTAINER (pdata->window), 0);
          vbox = gtk_vbox_new (FALSE, 5);
         gtk_container_set_border_width (GTK_CONTAINER (vbox), 10);
         gtk_container_add (GTK_CONTAINER (pdata->window), vbox);
         gtk_widget_show (vbox);
          /* Create a centering alignment object */
         align = gtk_alignment_new (0.5, 0.5, 0, 0);
         gtk_box_pack_start (GTK_BOX (vbox), align, FALSE, FALSE, 5);
         gtk_widget_show (align);
          /* Create the GtkProgressBar */
         pdata->pbar = gtk_progress_bar_new ();
         pdata->activity_mode = FALSE;
          gtk_container_add (GTK_CONTAINER (align), pdata->pbar);
         gtk_widget_show (pdata->pbar);
          /* Add a timer callback to update the value of the progress bar */
         pdata->timer = g_timeout_add (100, progress_timeout, pdata);
          separator = gtk_hseparator_new ();
         gtk_box_pack_start (GTK_BOX (vbox), separator, FALSE, FALSE, 0);
         gtk_widget_show (separator);
          /* rows, columns, homogeneous */
         table = gtk_table_new (2, 3, FALSE);
         gtk_box_pack_start (GTK_BOX (vbox), table, FALSE, TRUE, 0);
         gtk_widget_show (table);
          /* Add a check button to select displaying of the trough text */
         check = gtk_check_button_new_with_label ("Show text");
         gtk_table_attach (GTK_TABLE (table), check, 0, 1, 0, 1,
         GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
         5, 5);
         g_signal_connect (G_OBJECT (check), "clicked",
         G_CALLBACK (toggle_show_text),
         (gpointer) pdata);
         gtk_widget_show (check);
          /* Add a check button to toggle activity mode */
         check = gtk_check_button_new_with_label ("Activity mode");
         gtk_table_attach (GTK_TABLE (table), check, 0, 1, 1, 2,
         GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
         5, 5);
         g_signal_connect (G_OBJECT (check), "clicked",
         G_CALLBACK (toggle_activity_mode),
         (gpointer) pdata);
         gtk_widget_show (check);
          /* Add a check button to toggle orientation */
         check = gtk_check_button_new_with_label ("Right to Left");
         gtk_table_attach (GTK_TABLE (table), check, 0, 1, 2, 3,
         GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
         5, 5);
         g_signal_connect (G_OBJECT (check), "clicked",
         G_CALLBACK (toggle_orientation),
         (gpointer) pdata);
         gtk_widget_show (check);
          /* Agrego botón para resetear contador */
         button = gtk_button_new_from_stock ("gtk-clear");
         g_signal_connect (G_OBJECT (button), "clicked",
         G_CALLBACK (count_reset),
         pdata);
         gtk_box_pack_start (GTK_BOX (vbox), button, FALSE, FALSE, 0);
         gtk_widget_show (button);
          /* Add a button to exit the program */
         button = gtk_button_new_from_stock ("gtk-quit");
         g_signal_connect_swapped (G_OBJECT (button), "clicked",
         G_CALLBACK (gtk_widget_destroy),
         G_OBJECT (pdata->window));
         gtk_box_pack_start (GTK_BOX (vbox), button, FALSE, FALSE, 0);
          /* This makes it so the button is the default. */
         GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
          /* This grabs this button to be the default button. Simply hitting
         * the "Enter" key will cause this button to activate. */
         gtk_widget_grab_default (button);
         gtk_widget_show (button);
          gtk_widget_show (pdata->window);
          /* Creo thread y lo dejo en libertad (para no tener que hacer un join
         * después */
         pthread_create(&thread, NULL, count_add, pdata);
         pthread_detach(thread);
          gtk_main ();
          return 0; /* no debería ejecutarse nunca */
        }
        ```

---
<div class="entry-content">
						<p>Programa en GTK+ con una barra de progreso que cambia según 		el progreso de un thread. Este ejemplo es una versión 		modificada del ejemplo de <em lang="en">progress 		bar</em> del tutorial de GTK+ al que se le agregó un 		thread POSIX (pthread).</p>
<p>progressbar.c</p>
<div><div id="highlighter_840178" class="">{{page.snippets[0] | markdownify }}</div></div>
<p>Makefile</p>
<pre>CC = gcc

CFLAGS = -Wall			 	\
	-DG_DISABLE_DEPRECATED 	 	\
	-DGDK_DISABLE_DEPRECATED 	\
	-DGDK_PIXBUF_DISABLE_DEPRECATED \
	-DGTK_DISABLE_DEPRECATED

progressbar: progressbar.c
	$(CC) progressbar.c -o progressbar $(CFLAGS) `pkg-config gtk+-2.0 --cflags --libs` -lpthread

clean:
	rm -f *.o progressbar
</pre>
											</div>
