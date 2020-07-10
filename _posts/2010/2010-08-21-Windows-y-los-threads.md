---
layout: post
title: Windows y los threads
author: admin
date: 21/08/2010
tags: [C windows threads]
snippets: 
    - |
        ```cpp
        typedef struct {
        ...
        }TDatosAplicacion;
         // Este código se ejecutará en paralelo con el resto del programa
        // Cuando esta función termina, la thread termina
        DWORD WINAPI ThreadProc (LPVOID lpParameter)
        {
           TDatosAplicacion *pDatos = (TDatosAplicacion *)lpParameter;
           ...
           return 0;
        }
         void Funcion (void)
        {
           TDatosAplicacion Datos;
           DWORD dwThreadId;
           ...
            // Crear la thread
           HANDLE hThread = CreateThread (
              NULL,       // Atributo de seguridad: Usar el de la thread actual
              0,          // Tamaño del stack. Usar el tamaño por defecto
              ThreadProc, // Función inicial de la thread
              (LPVOID)&Datos,    // Datos a pasar a la thread
              0,          // Flags de creación
              &dwThreadId);
            ...
            // Esperar a que termine la thread
           DWORD dwExitCode;
           BOOL bRet;
           do {
              bRet = GetExitCodeThread (hThread, &dwExitCode);
              if (bRet && dwExitCode == STILL_ACTIVE)
               Sleep (100);
           }while (bRet && dwExitCode == STILL_ACTIVE);
            CloseHandle (hThread);
        }
        ```

---
<div class="entry-content">
						<table width="100%" border="1">
<tbody>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Tema</strong></td>
<td><strong>Threads y mensajes</strong></td>
<td width="10%" bgcolor="#c0c0c0"><strong>Versión</strong></td>
<td width="10%">2.00</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Resumen</strong></td>
<td colspan="3">El presente documento busca explicar el funcionamiento de       las threads en Windows y el sistema de mensajería.</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Sistema Operativo</strong></td>
<td colspan="3">Windows 9x, Me, NT, 2000, XP</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Autor</strong></td>
<td>Gabriel Agustín Praino</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Fecha</strong></td>
<td width="10%">30/11/2001</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Búsqueda</strong></td>
<td colspan="3">threads, mensajes</td>
</tr>
</tbody>
</table>
<table border="1" bgcolor="#ffff00">
<tbody>
<tr>
<td><span style="color: #000000;">El presente material se encuentra inscripto en el       Registro Nacional de Propiedad Intelectual. Todos los derechos reservados.       La reproducción de la presente publicación se encuentra sujeta a los términos       establecidos en la página principal de la presente obra. Prohibida la       reproducción total o parcial de esta publicación en forma independiente.</span></td>
</tr>
</tbody>
</table>
<h2>Introducción</h2>
<p>Es habitual que los programadores Windows desarrollen sus programas sin conocer realmente cómo funciona el sistema de mensajería de Windows. Aunque esto último no es un requisito indispensable para programar, su desconocimiento puede llevar a programas ineficientes o con errores.</p>
<p>Antes de analizar cómo funciona el mismo, es necesario presentar un nuevo concepto, las <strong><em>threads</em></strong>.</p>
<h2>Threads</h2>
<p>Una <em>thread</em> es básicamente un hilo o camino de ejecución. Es la unidad mínima de ejecución que Windows puede manejar, está asociada al proceso que la creó, y está identificada por un número entero de 32 bits.</p>
<p>Una <em>thread</em> está compuesta por:</p>
<ul>
<li>Un número entero de 32 bits que la identifica unívocamente</li>
<li>El estado de los registros del procesador</li>
<li>Una pila (stack)</li>
<li>Parámetros de seguridad (Session ID y Security Descriptor)</li>
<li>Un valor de prioridad. La prioridad real de la thread es función de este     valor y la prioridad del proceso a que pertenece.</li>
<li>Una entrada en la lista de ejecuciones de Windows</li>
<li>Opcionalmente, una cola de mensajes</li>
</ul>
<p>Cada <em>thread</em> tiene asociado un usuario (SID: <em>Session ID</em>) y unos parámetros de seguridad (<em>SD Security Descriptor</em>), que determinan los permisos de la <em>thread</em> dentro del sistema operativo, y que por defecto coinciden con los de la <em>thread</em> principal del proceso.</p>
<p>Un proceso se compone se una o más <em>threads</em>, además del código, los datos y otros recursos del programa. Todas las <em>threads</em> de un proceso comparten tanto el código como los datos y se ejecutan en forma independiente. Es por ello que, cuando una o más <em>threads</em> deban trabajar con un mismo conjunto de datos, deberá utilizarse un sistema de semáforos, para evitar que los datos puedan verse corrompidos.</p>
<p>La creación de una <em>thread</em> se realiza utilizando la función <em>CreateThread()</em>. Veamos un ejemplo:</p>
<div><div>{{page.snippets[0] | markdownify }}</div></div>
<p>Al llamar el programa a la función <em>Funcion()</em>, el programa crea una thread, llamando a la función <em>CreateThread()</em>. Esta nueva thread comenzará su ejecución en la función <em>ThreadProc()</em>, y terminará cuando la misma retorne de esta función, o llame a la función <em>ExitThread()</em>. No existe ninguna forma segura de terminar una thread desde otra thread, y si bien existe la función <em>TerminateThread() </em>para tal fin, no se recomienda su uso.</p>
<p>Si se está utilizando MFC, no debe utilizarse la función <em>CreateThread()</em>, sino <em>AfxBeginThread()</em>, cuya sintaxis es similar. Esto debe hacerse, porque las MFC implementan internamente una lista de las <em>threads </em>que el programa está utilizando, y redefinen la función de creación de <em>threads </em>para poder conocer esto. El no utilizar esta función puede llevar a pérdida de memoria o a un programa inestable, si dentro de la <em>thread </em>se utilizan funciones de las MFC.</p>
<p>La función <em>CreateThread()</em> devuelve dos valores. El identificador de la thread o <em>dwThreadId</em>, que identifica a la thread, y un handle a la thread <em>hThread</em>, que permite realizar operaciones sobre la misma. Se podría preguntar porqué Windows utiliza un handle para realizar operaciones sobre la <em>thread</em>, y no directamente el <em>Thread ID</em>. La respuesta es que el <em>handle </em>a la <em>thread </em>no sólo identifica una <em>thread</em>, sino que define las operaciones que están permitidas realizar sobre la misma.</p>
<p>El <em>handle </em>devuelto debe ser cerrado cuando ya no se use, utilizando <em>CloseHandle()</em>, y puede ser utilizado entre otras cosas para conocer el estado de la <em>thread</em>.</p>
<h3>C Runime Library y Multithreading</h3>
<p>Muchas funciones de C no fueron pensadas para trabajar con <em>multithreading</em>. Por ejemplo, la función time() clásica devuelve a un puntero a una estructura estática time_t, que si fuese llamada en paralelo por varias threads de un proceso podría ser sobreescrita. Para solucionar esto, es necesario que esta librería de C en tiempo real (C run-time library o C RTL) realice algunas operaciones adicionales al crearse o liberarse una thread. Por este motivo la C-RTL proporciona sus propias funciones de creación / terminación de threads: <strong><em>beginthread() </em></strong>/ <em><strong>exitthread()</strong></em>.</p>
<p>Las MFC proporcionan también sus propias funciones de creación / terminación de threads: <strong><em>AfxBeginThread()</em></strong> y <strong><em>AfxExitThread()</em></strong>.</p>
<p>De más está decir que la llamada a funciones de threads del API es más eficiente que sus pares C, y estas más eficientes que las de las MFC, ya que las últimas deben llamar a su vez a las anteriores.</p>
<table cellspacing="0" cellpadding="0" width="100%" bordercolor="#ffffff" border="1" bgcolor="#ffff00">
<tbody>
<tr>
<td width="100%"><strong>Importante: Cualquiera de los tres grupos de funciones       de threads puede utilizarse, siempre y cuando se respete la siguiente       tabla.</strong></td>
</tr>
</tbody>
</table>
<table width="100%" border="1">
<tbody>
<tr>
<td width="25%"><strong>Operación</strong></td>
<td width="25%"><strong>Funciones API<br>
Ej: CreateThread()</strong></td>
<td width="25%"><strong>Funciones de la librería de C. Ej: beginthread()</strong></td>
<td width="25%"><strong>MFC<br>
Ej: AfxBeginThread()</strong></td>
</tr>
<tr>
<td width="25%">Llamada a funciones API</td>
<td width="25%">Sí</td>
<td width="25%">Sí</td>
<td width="25%">Sí</td>
</tr>
<tr>
<td width="25%">Llamada a funciones C</td>
<td width="25%">No</td>
<td width="25%">Sí</td>
<td width="25%">Sí</td>
</tr>
<tr>
<td width="25%">Uso de funciones/clases MFC</td>
<td width="25%">No</td>
<td width="25%">No</td>
<td width="25%">Sí</td>
</tr>
</tbody>
</table>
<h2>Mensajes</h2>
<p>Antes de ver como implementa Windows el sistema de mensajería, repasemos algunos conceptos fundamentales:</p>
<ul>
<li>Un programa o aplicación es visto por el sistema operativo como un     proceso, identificado por un número entero, llamado process ID o PID.</li>
<li>Un proceso se compone de una o más threads, cada una de las cuales está     identificada por un número entero llamado Thread ID.</li>
<li>Cada thread puede o no tener asociada una cola de mensajes.</li>
<li>Toda ventana tiene asociada una función (callback) de procesamiento de     mensajes.</li>
<li>Toda ventana tiene asociada un proceso y una thread, que es la thread que     la creó.</li>
<li>La función callback de la ventana es ejecutada siempre por la thread que     creó la ventana.</li>
<li>Si bien no se lo explicó, se dijo que todo programa (o en realidad thread)     que procese mensajes tendrá un código similar al siguiente:MSG Msg;<br>
while (GetMessage (&amp;Msg, NULL, 0, 0);<br>
{<br>
TranslateMessage (&amp;Msg);<br>
DispatchMessage (&amp;Msg);<br>
}</li>
</ul>
<p>Cuando un programa encola/envía un mensaje a una ventana, este mensaje es en realidad encolado/enviado a la thread de la ventana. Por eso, para que una thread pueda recibir mensajes, previamente debe crear la cola de mensajes, lo cual ocurre automáticamente cuando la misma llama por primera vez a cualquiera de las funciones de lectura de mensajes (<em>GetMessage()</em> en nuestro caso).</p>
<p>El envío de mensajes (SendMessage ()) y el encolado de mensajes (PostMessage()) es procesado de forma diferente, razón por la cual veremos estos casos por separado.</p>
<h2>Encolado de mensajes</h2>
<p>El manejo de mensajes se muestra esquemáticamente a continuación:</p>
<p><a href="/assets/2010/08/Threads01.gif"><img class="alignnone size-full wp-image-118" title="Threads01" src="/assets/2010/08/Threads01.gif" alt="" width="453" height="353"></a></p>
<p>1) Cuando un programa encola un mensaje para una ventana utilizando la función <em>PostMessage()</em>, el mismo es insertado dentro de la cola de mensajes de la <em>thread </em>de la ventana, y en el campo <em>hWnd </em>del mensaje indica la ventana destino. Función <em>PostMessage()</em> retorna inmediatamente y la <em>thread </em>que encoló el mensaje continúa su procesamiento normal.</p>
<p>Existe también la función <em>PostThreadMessage()</em>, que trabaja en forma similar a <em>PostMessage()</em>, sólo que en lugar de indicarse un ventana como destino, se indica una <em>thread</em>. En este caso, el mensaje será encolado en forma idéntica, pero el campo <em>hWnd </em>tendrá un valor NULL.</p>
<p>2) La función <em>GetMessage()</em> / <em>PeekMessage()</em> lee y/o retira un mensaje de la cola. Los mensajes encolados por la propia thread tienen prioridad por los encolados por cualquier otra <em>thread</em>.</p>
<p>3) La función <em>TranslateMessage()</em>, realiza ciertas conversiones, como por ejemplo, modificar un click en el botón <img src="http://www.7542.fi.uba.ar/tutorials/threads/Threads02.gif" alt="" width="18" height="16" border="0"> en un mensaje WM_CLOSE.</p>
<p>4) La función <em>DispatchMessage()</em> llama a la función <em>callback </em>de la ventana correspondiente, la cual procesa el mensaje y devuelve una respuesta.</p>
<p>5) Si la función que envió el mensaje fue <em>PostMessage()</em> / <em>PostThreadMessage()</em>, esta respuesta se descarta.</p>
<h2>Envío de mensajes</h2>
<p>Si una misma <em>thread</em> envía un mensaje (<em>SendMessage()</em>) para la misma <em>thread</em>, este mensaje es no es encolado sino que es enviado directamente a la función <em>callback</em>, como una llamada a una función cualquiera.</p>
<p>Si una <em>thread</em> cualquiera envía un mensaje a una ventana de otra <em>thread</em>, no es posible llamar directamente a la función <em>callback</em> de otra ventana. Si esto se hiciese así, el código de la función <em>callback</em> se ejecutaría bajo los parámetros de seguridad de la <em>thread</em> que envió el mensaje, lo cual vulneraría toda la seguridad del sistema. Por ejemplo, si Windows simplemente llamase a la función <em>callback</em> para informar un evento como el movimiento del mouse, esta función se ejecutaría con los parámetros de seguridad del kernel, lo cual permitiría la aplicación realizar cualquier operación.</p>
<p>Para evitar esto, cuando una <em>thread</em> envía un mensaje para una ventana de otra <em>thread</em>, este mensaje es encolado en forma similar a un <em>PostMessage()</em>, pero la <em>thread</em> permanece bloqueada, hasta que la <em>thread</em> destino procese el mensaje y devuelva su respuesta.</p>
<h2>Problemas que pueden presentarse</h2>
<p>El sistema de procesamiento de mensajes de Windows no es infalible, si bien generalmente se programa como si lo fuese. Entre existen dos problemas comúnmente ignorados que deben ser tenidos en cuenta:</p>
<ul>
<li>Cuando una <em>thread</em> envía un mensaje para otra <em>thread</em>, la     primera permanece en estado de espera hasta que la segunda procese el     mensaje y devuelva una respuesta. Si la segunda <em>thread</em> se     “colgó” o por cualquier razón no procesa mensajes, la segunda     quedará esperando indefinidamente. Para evitar esto, es posible utilizar la     función <em>SendMessageTimeout()</em>, que permite especificar el tiempo que     debe esperarse la respuesta. Transcurrido este tiempo, la función retorna     especificando un código de error.</li>
<li>Es común que los programadores crean que Windows garantiza el envío de     los mensajes. Sin embargo esto no es así. La cola de mensajes de Windows,     (como toda cola) es finita, y por ende es posible que se llene. Las     funciones <em>PostMessage()</em> y <em>PostThreadMessage() </em>retornan siempre     un valor indicando si el mensaje pudo o no ser encolado.</li>
</ul>
<p>En muy raro que los programadores controlen esto en sus programas, y esta es una de las razones fundamentales por la que muchos programas fallan cuando el sistema se ve limitado de recursos o el uso del procesador es muy elevado.</p>
<p>Pero lamentablemente, es programáticamente muy difícil controlar estas situaciones cada vez que se envía/encola un mensaje, y es aquí donde interviene el criterio del programador. Se recomienda que estas situaciones sean controladas cuando se envía/encola un mensaje a una ventana o <em>thread</em> de la cual no se conoce completamente el comportamiento o el estado de la misma, como por ejemplo al enviar/encolar un mensaje para otra aplicación.</p>
<p>Dado que es mucho menos frecuente y más peligroso el envío de mensajes entre <em>threads</em> que dentro de una misma <em>thread</em>, también se recomienda controlar esto al enviar/encolar mensajes para una <em>thread</em> diferente a la actual.</p>
<p>La decisión de controlar estas situaciones y otros errores es una decisión que se toma en base a la experiencia, tomando en cuenta la probabilidad de falla, el ambiente donde correrá el programa, el costo de desarrollo de controlar estos errores y las implicancias de una falla.</p>
											</div>
