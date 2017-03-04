---
layout: post
title: Impresión de Dibujos en gtkmm
author: Pablo Roca
date: 28/02/2012
snippets: none

---
<div class="entry-content">
						<p>La operación de impresión utilizando <em>gtkmm</em> resulta muy simple y útil a la vez permitiendo la escritura de dibujos tanto en la impresora como en archivos PDF.</p>
<p>Supongamos que se tiene el siguiente código <em>cairomm:</em></p>
<pre><code>	const double width = print_context-&gt;get_width();
	const double height = print_context-&gt;get_height();
	Cairo::RefPtr cairo_ctx = print_context-&gt;get_cairo_context();
	cairo_ctx-&gt;set_source_rgb(0, 0, 0);
	cairo_ctx-&gt;set_font_size(28.0);
	std::string text("Taller de Programación - FIUBA");
	Cairo::TextExtents extents;
	cairo_ctx-&gt;get_text_extents(text, extents);
	cairo_ctx-&gt;move_to (width/2.0 + - extents.x_bearing - extents.width/2, height/2.0);
	cairo_ctx-&gt;show_text(text);
</code></pre>
<p>Este pequeño bloque obtiene el tamaño del contexto de impresión y dibuja el texto “Taller de Programación – FIUBA” en el centro. Las operaciones utilizadas se pueden encontrar en la referencia de cairomm o bien en el tutorial [1]. Es importante destacar que el código anterior sólo depende de un objeto llamado <em>print_context</em> que entrega un <em>Cairo::Context</em> pero que se puede adaptar fácilmente a un DrawingArea donde el <em>Cairo::Context</em> de dibujo es recibido por parámetro [2].</p>
<p>Para permitir la impresión del texto anterior es necesario definir una clase heredera de&nbsp;<em>Gtk::PrintOperation</em> y realizar la escritura en su <em>print_context</em> como se detalla a continuación:</p>
<pre><code>class CustomPrintOperation : public Gtk::PrintOperation
{
public:
	static Glib::RefPtr create();

protected:
	virtual void on_begin_print(const Glib::RefPtr&amp; context);
	virtual void on_draw_page(const Glib::RefPtr&amp; context, int page_nr);

};

Glib::RefPtr CustomPrintOperation::create()
{
	return Glib::RefPtr(new CustomPrintOperation());
}

void CustomPrintOperation::on_begin_print(
        const Glib::RefPtr&amp; print_context)
{
	set_n_pages(1);
}

void CustomPrintOperation::on_draw_page(const Glib::RefPtr&amp; print_context, int page_nr)
{
	const double width = print_context-&gt;get_width();
	const double height = print_context-&gt;get_height();
	Cairo::RefPtr cairo_ctx = print_context-&gt;get_cairo_context();
	cairo_ctx-&gt;set_source_rgb(0, 0, 0);
	cairo_ctx-&gt;set_font_size(28.0);
	std::string text("Taller de Programación - FIUBA");
	Cairo::TextExtents extents;
	cairo_ctx-&gt;get_text_extents(text, extents);
	cairo_ctx-&gt;move_to (width/2.0 + - extents.x_bearing - extents.width/2, height/2.0);
	cairo_ctx-&gt;show_text(text);

void on_printoperation_done(Gtk::PrintOperationResult result, const Glib::RefPtr&amp; operation)
{
[...] //realizar chequeo de finalización de operación.
}

Glib::RefPtr print = CustomPrintOperation::create();

print-&gt;set_track_print_status();
print-&gt;set_default_page_setup(m_refPageSetup);
print-&gt;set_print_settings(m_refSettings);

print-&gt;signal_done().connect(sigc::bind(sigc::ptr_fun(&amp;on_printoperation_done), print));
try
{
print-&gt;run(Gtk::PRINT_OPERATION_ACTION_PRINT_DIALOG, currentWindow);
}
catch (const Gtk::PrintError&amp; ex)
{
std::cerr &lt;&lt; "An error occurred while trying to run a print operation:"
&lt;&lt; ex.what() &lt;&lt; std::endl;
}
</code></pre>
<p>Como resultado se obtendrá un cuadro de diálogo de impresión que permitirá elegir entre una exportación a PDF o una impresión en papel del dibujo resultante del código cairomm antes visto.</p>
<p>Para más información sobre esta funcionalidad de gtkmm, referirse al capítulo de impresión del tutorial de gtkmm [3].</p>
<p>Se adjunta un ejemplo de código completo basado en mencionado tutorial:</p>
<blockquote><p><a href="/assets/2012/02/CustomPrintOperation.zip">Descargar ejemplo CustomPrintOperation</a></p></blockquote>
<p>[1] http://cairographics.org/tutorial/<br>
[2]&nbsp;http://developer.gnome.org/gtkmm-tutorial/3.2/sec-cairo-drawing-model.html<br>
[3] http://developer.gnome.org/gtkmm-tutorial/3.2/chapter-printing.html</p>
											</div>
