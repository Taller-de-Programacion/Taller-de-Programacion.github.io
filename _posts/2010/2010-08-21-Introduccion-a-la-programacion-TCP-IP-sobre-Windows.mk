---
layout: post
title: Introducción a la programación TCP/IP sobre Windows
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        #include <stdio.h>
        #include <windows.h>
        #include <winsock.h>
         /* El chequeo de errores ha sido removido por claridad */
        void main(void)
        {
          /* Inicializar WinSock */
          WSADATA WsaData;
          WORD  wVersionRequerida = MAKEWORD (2, 2);
          WSAStartup (wVersionRequerida, &WsaData);
           SOCKET SockEscucha;
           SockEscucha = socket (AF_INET, SOCK_STREAM, 0);
           SOCKADDR_IN DireccionLocal;
          memset (&DireccionLocal, 0, sizeof (DireccionLocal));
          DireccionLocal.sin_family = AF_INET;
          DireccionLocal.sin_port = 5000;
           bind (SockEscucha, (SOCKADDR*)&DireccionLocal, sizeof (DireccionLocal));
           int iResult = listen (SockEscucha, 5);
           SOCKET SockConexion = accept (SockEscucha, NULL, NULL);
          closesocket (SockEscucha);
           unsigned Dato;
          recv (SockConexion, (char *)&Dato, sizeof (Dato), 0);
           unsigned Rta = Dato * 2;
          send (SockConexion, (char *)&Rta, sizeof (Rta), 0);
          printf ("Dato recibido: %u, Respuesta enviada: %u\n", Dato, Rta);
           closesocket (SockConexion);
          WSACleanup();
        }
        ```

    - |
        ```cpp
        #include <stdio.h>
        #include <windows.h>
        #include <winsock.h>
         /* El chequeo de errores ha sido removido por claridad */
        void main(void)
        {
          WSADATA WsaData;
          WORD  wVersionRequerida = MAKEWORD (2, 2);
           /* Inicializar WinSock */
          WSAStartup (wVersionRequerida, &WsaData);
           SOCKET Sock;
           Sock = socket (AF_INET, SOCK_STREAM, 0);
           SOCKADDR_IN DireccionServer;
          memset (&DireccionServer, 0, sizeof (DireccionServer));
          DireccionServer.sin_family = AF_INET;
          DireccionServer.sin_addr.S_un.S_un_b.s_b1 = 127;
          DireccionServer.sin_addr.S_un.S_un_b.s_b2 = 0;
          DireccionServer.sin_addr.S_un.S_un_b.s_b3 = 0;
          DireccionServer.sin_addr.S_un.S_un_b.s_b4 = 1;
          DireccionServer.sin_port = 5000;
           int iResult = connect (Sock, (SOCKADDR*) &DireccionServer, \
          sizeof(DireccionServer));
           if (iResult)
          {
            printf ("No se puede conectar\n");
            return;
          }
           unsigned Dato = 2;
          send (Sock, (char *)&Dato, sizeof (Dato), 0);
           unsigned Rta;
          recv (Sock, (char *)&Rta, sizeof (Rta), 0);
          printf ("Dato enviado: %u, Respuesta recibida: %u\n", Dato, Rta);
           closesocket (Sock);
          WSACleanup();
        }</span><span><span style="color: #ff0000;">
        ```

---
<div class="entry-content">
						<table width="100%" border="1">
<tbody>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Tema</strong></td>
<td><strong>Introducción a la programación TCP/IP sobre Windows</strong></td>
<td width="10%" bgcolor="#c0c0c0"><strong>Versión</strong></td>
<td width="10%">2.00</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Resumen</strong></td>
<td colspan="3">El presente documento constituye una introducción a la       programación TCP/IP utilizando sockets.</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Sistema Operativo</strong></td>
<td colspan="3">WINDOWS 9x, Me, NT, 2000, XP, UNIX</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Autor</strong></td>
<td>Gabriel Agustín Praino</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Fecha</strong></td>
<td width="10%">30/11/2001</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Búsqueda</strong></td>
<td colspan="3">sockets, network</td>
</tr>
</tbody>
</table>
<table width="100%" border="1" bgcolor="#ffff00">
<tbody>
<tr>
<td><span style="color: #000000;">El presente material se encuentra inscripto en el       Registro Nacional de Propiedad Intelectual. Todos los derechos reservados.       La reproducción de la presente publicación se encuentra sujeta a los       términos establecidos en la página principal de la presente obra.       Prohibida la reproducción total o parcial de esta publicación en forma       independiente.</span></td>
</tr>
</tbody>
</table>
<h2>Introducción</h2>
<p>En este capítulo veremos rápidamente la forma de programar aplicaciones cliente-servidor, sobre redes TCP/IP. Nos basaremos para ello en el sistema operativo Windows, en cualquiera de sus versiones de 32 bits 95/98/Me/NT4/2000.</p>
<p>Este capitulo sólo pretende presentar una introducción al tema, para permitir al usuario continuar con el estudio por sus propios medios. También se supone que el lector ya posee algunos conocimientos básicos sobre el conjunto de protocolos TCP/IP. No se analizarán las características avanzadas del protocolo TCP/IP.</p>
<p>La interfaz o API de programación de redes más estandarizada, y utilizada en Windows se conoce de sockets. El sistema operativo Windows copia su implementación de sockets del sistema operativo UNIX, sin realizar prácticamente ningún cambio. Esta implementación de sockets en muchos casos resulta inadecuada para el modelo de programación orientado a eventos que plantea Windows. Por ejemplo, en muchos casos, las llamadas a funciones se implementan en forma sincrónica o bloqueante. Esto es, al realizar una dada operación la función se queda a la espera de un evento y no retorna inmediatamente. Por ejemplo, al recibir datos, la función de lectura no retorna hasta que no se reciban datos. En una aplicación single-thread o de un único hilo de ejecución, la aplicación dejaría de atender eventos si esto ocurre, y ya se ha visto los problemas que esto trae.<br>
Por esta razón, Microsoft extendió la librería, fundamentalmente agregándole las características de eventos, creando así la llamada Windows Sockets, muchas veces denominada ‘WinSock’. Las nuevas características definen ahora un nuevo conjunto de funciones que permiten trabajar en forma asincrónica. En este caso, las operaciones se realizan en background, e informan a la aplicación el resultado de las mismas mediante mensajes.</p>
<p>En el protocolo IP, cada interfaz de un equipo, que de ahora en adelante llamaremos ‘host’, con una red está identificada por una dirección IP, compuesta por 4 dígitos decimales (0-255) separados por punto.<br>
El protocolo TCP es un protocolo orientado a la conexión. Esto significa que antes de poder transmitir información, debe establecerse una conexión entre dos equipos. Para poder establecer varias conexiones utilizando la misma interfaz, el protocolo TCP utiliza un número de 16 bits denominado port o puerto TCP. El conjunto de protocolos TCP/IP dispone también de un protocolo no orientado a la conexión denominado UDP, que transmite la información fragmentada en pequeños paquetes denominados datagramas. Con el objetivo de simplificar el tema, lo dejaremos de lado.</p>
<p>En este capítulo veremos la programación de sockets utilizando la librería Windows Socket, tal como es provista por el sistema operativo. En la actualidad, Visual C++ 6.0 provee una clase denominada CSocket que encapsula el acceso a la librería, aunque prácticamente no aporta diferencias, y la forma en que está programada puede traer problemas en aplicaciones Multi-thread. Por esta razón, la dejaremos de lado por ahora.</p>
<p>Finalmente, debe decirse que en este momento existen 2 versiones básicas de la librería Windows Sockets. La 1.x, y la 2.0 La segunda mantiene todas las carecterística de la primera, y agrega algunas extensiones. La principal de ellas es la posibilidad de definir TimeOuts en operaciones, tales como lectura/escritura, lo cual es escencial en muchas aplicaciones.</p>
<h2>Primer ejemplo</h2>
<p>Antes de analizar el funcionamiento de la librería en detalle, iremos desarrollando un ejemplo, que explicaremos paso a paso, para luego analizar en detalle el funcionamiento del conjunto. Para ello desarrollaremos un par de aplicaciones, que transmitirán datos entre sí. A una de ellas llamaremos aplicación cliente o simplemente cliente, y a la otra aplicación servidor o simplemente servidor.</p>
<p>Si bien nos centraremos en la programación Windows, este ejemplo es completamente compatible con sistemas operativos UNIX.</p>
<h3>Notas</h3>
<ul>
<li>En estas aplicaciones se ha eliminado todo el código de     chequeo de errores, por claridad.</li>
<li>Ya que se desarrollará en paralelo el cliente y el     servidor, se utilizará la siguiente convensión de colores para distinguir     el código de ambas aplicaciones:<br>
<span style="color: #ff0000;"> </span> <span style="color: #ff0000;">color     rojo: código correspondiente al servidor<br>
</span><span style="color: #0000ff;"> </span><span style="color: #ff0000;"> </span><span style="color: #0000ff;">color azul: código correspondiente al cliente</span></li>
</ul>
<p>El header que contiene las definiciones correspondientes para poder utilizar la librería de sockets de Windows es:</p>
<p><strong><em>winsock.h </em></strong>para Windows Sockets 1</p>
<p>ó</p>
<p><strong><em>winsock2.h </em></strong>para Windows Sockets 2</p>
<p>Antes de poder utilizar la librearía de sockets, la aplicación debe inicializar la librería llamando a la función WSAStartup(), tal como se muestra a continuación:</p>
<blockquote>
<pre><span style="color: #ff0000;">/* Inicializar WinSock en la aplicación Servidor */
WSADATA WsaData;
WORD wVersionRequerida = MAKEWORD (2, 2);
WSAStartup (wVersionRequerida, &amp;WsaData);</span></pre>
<pre><span style="color: #0000ff;">/* Inicializar WinSock en la aplicación Cliente */
WSADATA WsaData;
WORD wVersionRequerida = MAKEWORD (2, 2);
WSAStartup (wVersionRequerida, &amp;WsaData);</span></pre>
</blockquote>
<p>Una vez hecho esto, una aplicación debe crear un extremo de conexión bidireccional. Este extremo de conexión recibe el nombre de socket.<br>
La creación de un socket se realiza llamando a la función del mismo nombre, con tres parámetros, tal como se muestra a continuación:</p>
<blockquote>
<pre>Sock = socket (AF_INET, SOCK_STREAM, 0);</pre>
</blockquote>
<p>El primer parámetro especifica la creación un socket estilo Internet. El segundo especifica que se utilizará un protocolo para envío de streams (SOCK_STREAM). El tercer parámetro no será utilizado en este caso.</p>
<p>Un socket creado de esta forma es, por defecto, bloqueante, es decir que, salvo que se especifique lo contrario, las llamadas a las funciones de socket no retornarán sino hasta que la operación solicitada se complete, ya sea exitosamente o con error.</p>
<p>En nuestro caso deberemos crear dos sockets, uno en la aplicación cliente y otro en el servidor.</p>
<blockquote>
<pre><span style="color: #ff0000;">SockEscucha = socket (AF_INET, SOCK_STREAM, 0);</span></pre>
</blockquote>
<blockquote>
<pre><span style="color: #0000ff;">Sock = socket (AF_INET, SOCK_STREAM, 0);</span></pre>
</blockquote>
<p>Antes de poder transmitir datos, debe establecerse una conexión entre los dos equipos que participarán de la misma, utilizando un modelo denominado cliente-servidor. Este modelo hace referencia a la forma utilizada para establecer la conexión. En el mismo, una aplicación debe iniciar una escucha en un port determinado de una interfaz de red, y otra aplicación, ya sea en este host o en otro, debe iniciar la conexión. Para ello debe, en ambos extremos, asociarse una dirección con el socket.</p>
<p>En el cliente la dirección del host con el que se desea establecer la conexión, así como también el port TCP. En el servidor, debe indicarse el port sobre el cual se quiere recibir una conexión. Si el equipo está conectado a más de una red de redes, puede especificarse sobre qué interfaz se quiere recibir la conexión. Dejaremos esto último de lado para simplificar el tema.</p>
<p>Para hacer esto, se definen una serie de estructuras SOCKADDR. Estas estructuras permiten especificar una dirección en una red de redes. Ya que, dependiendo del protocolo utilizado la forma de escribir la dirección cambiará, no se tiene una única estructura sino una serie de estructuras. En el caso del protocolo TCP/IP, se utiliza la estructura SOCKADDR_IN, que está definida como sigue:</p>
<pre>struct sockaddr_in {
	short sin_family;
	u_short sin_port;
	struct in_addr sin_addr;
	char sin_zero[8];
};</pre>
<p>y la estructura in_addr está definida como sigue:</p>
<pre>struct in_addr {
	union {
		struct { u_char s_b1,s_b2,s_b3,s_b4; } S_un_b;
		struct { u_short s_w1,s_w2; } S_un_w;
		u_long S_addr;
	} S_un;
};</pre>
<p>A continuación veremos como hacer esto en el servidor y en el cliente.</p>
<h3>Servidor</h3>
<blockquote>
<pre><span style="color: #ff0000;">SOCKADDR_IN DireccionLocal;
memset (&amp;DireccionLocal, 0, sizeof (DireccionLocal));
DireccionLocal.sin_family = AF_INET;
DireccionLocal.sin_port = 5000;
bind (SockEscucha, (SOCKADDR*)&amp;DireccionLocal, sizeof (DireccionLocal));</span></pre>
</blockquote>
<p>La función bind() utilizada aquí arriba asocia una dirección local con el socket. En este caso estamos especificando que el socket deberá recibir llamadas entrantes en cuyo port destino se especifice 5000. Los ports 1024 y superiores pueden ser utilizados por las aplicaciones. Los menores a este valor están reservados por el sistema operativo, si bien también pueden ser utilizados por las aplicaciones, aunque pueden requerirse permisos especiales.</p>
<p>El siguiente paso es iniciar la espera de conexiones, llamando a la función listen():</p>
<blockquote>
<pre><span style="color: #ff0000;">int iResult = listen (SockEscucha, 1);</span></pre>
</blockquote>
<p>El último parámetro especifica la cantidad de conexiones que pueden ser encoladas en espera de ser atendidas. Si se reciben más llamadas, las mismas serán rechazadas automáticamente.</p>
<p>Finalmente, el último paso es esperar la llegada de una conexión:</p>
<blockquote>
<pre><span style="color: #ff0000;">SOCKET SockConexion = accept (SockEscucha, NULL, NULL);</span></pre>
</blockquote>
<p>La función accept() espera la llegada de conexiones. La llamada a esta función no retornará hasta que se reciba una llamada entrante.</p>
<p>Si se utilizase el socket SockEscucha para comunicarse con el cliente ¿cómo podría, el servidor recibir nuevas conexiones, si el socket que se estaba utilizando para recibir llamadas ahora lo está utilizando para la conexión con el cliente? Para ello, la función accept de la librería duplica el socket. El nuevo socket debe ser utilizado para comunicarse con el cliente, y el antiguo socket puede seguir siendo utilizado para recibir nuevas llamadas, o cerrado si no se lo utiliza. En nuestro caso, ya que no trabajaremos con varios clientes, simplemente lo cerramos.</p>
<blockquote>
<pre><span style="color: #ff0000;">closesocket (SockEscucha);</span></pre>
</blockquote>
<h3>Cliente</h3>
<p>En el cliente la tarea se limita a iniciar la conexión con el servidor, utilizando la función connect(). En este caso, la conexión se establecerá con el port 5000 del host 127.0.0.1. Esta dirección se denomina loopback, es decir que la conexión se establece con el host local, o dicho de otra forma, con el mismo equipo. Esto permite correr ambas aplicaciones en el mismo host. La función connect() iniciará un intercambio de paquetes TCP entre ambos equipos, que establecerá la conexión.</p>
<blockquote>
<pre><span style="color: #0000ff;">SOCKADDR_IN DireccionServer;
memset (&amp;DireccionServer, 0, sizeof (DireccionServer));
DireccionServer.sin_family = AF_INET;
DireccionServer.sin_addr.S_un.S_un_b.s_b1 = 127;
DireccionServer.sin_addr.S_un.S_un_b.s_b2 = 0;
DireccionServer.sin_addr.S_un.S_un_b.s_b3 = 0;
DireccionServer.sin_addr.S_un.S_un_b.s_b4 = 1;
DireccionServer.sin_port = 5000;</span></pre>
<pre><span style="color: #0000ff;">int iResult = connect (Sock, (SOCKADDR*) &amp;DireccionServer, \
  sizeof(DireccionServer));</span></pre>
<pre><span style="color: #0000ff;">if (iResult)
{
	printf ("No se puede conectar\n");
	return;
}</span></pre>
</blockquote>
<h3>Intercambio de información</h3>
<p>Una vez establecida la conexión, ambos extremos pasan a tener las mismas características, y el modelo cliente-servidor, desde el punto de vista programático, ya no tiene aplicación. Si bien, generalmente las aplicaciones siguen manteniendo este modelo en forma conceptual: los clientes (que iniciaron la conexión) envían requerimientos a un servidor central, y este los responde, no siempre es así. Por ejemplo, en una aplicación simple tipo ‘chat’ entre dos equipos, una vez establecida la conexión ambos extremos se comportan en forma idéntica y este modelo ya no tiene ninguna validez.</p>
<p>En nuestro caso, el diálogo entre ambas aplicaciones se limitará a un envío de un número entero, del cliente al servidor, el cual responderá el producto de este número por 2.</p>
<p>El servidor, deberá iniciar una lectura en el socket, esperando recibir información:</p>
<blockquote>
<pre><span style="color: #ff0000;">unsigned Dato;
recv (SockConexion, (char *)&amp;Dato, sizeof (Dato), 0);</span></pre>
</blockquote>
<p>y luego deberá enviar la respuesta:</p>
<blockquote>
<pre><span style="color: #ff0000;">unsigned Rta = Dato * 2;
send (SockConexion, (char *)&amp;Rta, sizeof (Rta), 0);
printf ("Dato recibido: %u, Respuesta enviada: %u\n", Dato, Rta);</span></pre>
</blockquote>
<p>En cliente deberá transmitir el dato a procesar:</p>
<blockquote>
<pre><span style="color: #0000ff;">unsigned Dato = 2;
send (Sock, (char *)&amp;Dato, sizeof (Dato), 0);</span></pre>
</blockquote>
<p>y luego recibir la respuesta:</p>
<blockquote>
<pre><span style="color: #0000ff;">unsigned Rta;
recv (Sock, (char *)&amp;Rta, sizeof (Rta), 0);
printf ("Dato enviado: %u, Respuesta recibida: %u\n", Dato, Rta);</span></pre>
</blockquote>
<p>El código restante se limita a cerrar la conexión, en ambos extremos, llamando a closesocket(), y luego liberar la librería de Windows Socket, llamando a WSACleanup:</p>
<blockquote>
<pre><span style="color: #ff0000;">closesocket (Sock);
WSACleanup();</span></pre>
<pre><span style="color: #0000ff;">closesocket (SockConexion);
WSACleanup();</span></pre>
</blockquote>
<p>A continaución se presenta el código completo del cliente y del servidor.</p>
<h3>Servidor.cpp</h3>
<pre><span style="color: #ff0000;"><div><div id="highlighter_850479" class="">{{page.snippets[0] | markdownify }}</div></div>
<p></p>
<h3>Cliente.cpp</h3>
<pre><span style="color: #0000ff;"><div><div id="highlighter_870043" class="">{{page.snippets[1] | markdownify }}</div></div>
<p><br>
Como sería de esperar, un programa tan simple como este, el mismo presenta algunos puntos cuestionables. En primer lugar, generalmente no se especifica la dirección IP de un host, sino el nombre del mismo. La librería de sockets dispone de la función <strong><em>gethostbyname()</em></strong> que, dado el nombre de un equipo retorna su dirección IP. Esta función recae en el sistema de conversión de nombres del sistema operativo, basado generalmente en servidores DNS o tablas de configuración locales, que si no operan correctamente, no podrá obtenerse la dirección IP. De todas formas, el uso de una dirección IP en lugar del nombre no es incorrecto.</p>
<p>Pero la forma en que se recive el dato, utilizando la función recv sí es incorrecta. El tercer parámetro de <strong><em>recv </em></strong>especifica la longitud del buffer donde recibir la información, no la cantidad de bytes a recibir. Esta función retornará inmediatamente, al recibir un dato, aunque el buffer no se haya completado. Si por alguna razon el protocolo de red debe fragmentar la información, es posible que se reciba una cantidad menor a la solicitada. En este caso, es impensable que el protocolo TCP vaya a fragmentar un paquete con sólo 4 bytes de información, por lo que el programa funcionará correctamente, pero no puede suponerse que esto no vaya a ocurrir.</p>
<p>Por ejemplo, si se debiesen enviar varios números enteros, mendiante sucesivas llamadas a la función <em><strong>send() </strong></em>tal como se hizo arriba, el sistema operativo podría almancenar en un único paquete TCP varios de estos números, y mandar el n-ésimo entero dividido en dos paquetes consecutivos.</p>
<h3>Importante</h3>
<ul>
<li><strong>Es posible que la información enviada (a nivel     aplicación) será dividida en varios paquetes TCP, y por ende sea recibida     en sucesivas llamada a recv().</strong></li>
<li><strong>Es posible que información enviada en sucesivas     llamadas a la función send() sea transmitida en un único paquete TCP, y     por ende sea recibida como un único bloque de información en una llamada a     recv().</strong></li>
</ul>
<p>¿Cómo se deberían corregirse las aplicaciones de arriba para garantizar que funcionen correctamente? Simplementa verificando que efectivamente se reciban 4 bytes, y continuar recibiendo información si esto no ocurre. Esto puede hacerse reemplazando las llamadas a <strong><em>recv()</em></strong> por el siguiente código:</p>
<pre>	unsigned Dato;
	int BytesAlmacenados = 0;

	while (BytesAlmacenados &lt; sizeof (Dato))
	{
		int BytesRecibidos;
		BytesRecibidos = recv (SockConexion, ((char *)&amp;Dato) + BytesAlmacenados,
			sizeof (Dato) - BytesAlmacenados, 0);

		if (BytesRecibidos &lt;= 0)
		{
			printf ("Se cortó la conexión o se produjo un error\n");
			return;
		}
		BytesAlmacenados += BytesRecibidos;
	}</pre>
<p>Es común encontrar programas que en algún caso no realizan este chequeo, y producen errores difíciles de encontrar.</p>
<h2>Transmisión de datos utilizando Sockets</h2>
<p>En el ejemplo de arriba se transmiten datos de longitud conocida, esto es, quien recibe la información sabe cuantos bytes debe leer antes de comenzar a procesar la información. Sin embargo esto rara vez ocurre. Como se vió antes, las funciones de Windows Sockets no proveen ninguna forma de saber cuantos bytes fueron enviados por el host remoto, ni si la información fue dividida o contiene varios datos. Esta tarea recae en la capa de aplicación. Por ejemplo, un servidor de mail no tiene forma de saber donde termina el mismo, a no ser que el mismo protocolo establezca la forma de codificar de alguna forma el fin del mensaje.</p>
<p>Como solución se suelen utilizar las siguientes alternativas:</p>
<p>1 – Utilizar siempre bloques de información del mismo tamaño. Esto puede ser muy ineficiente. Es muy raro que una aplicación pueda transmitir siempre bloques de datos del mismo tamaño sin caer en un uso más que ineficiente de la red.</p>
<p>2 – Utilizar un caracter o secuencia de caracteres para indicar el fin de los datos. Esto impide transmitir este caracter o secuencia de caracteres junto con los datos, salvo que se utilice un código de escape. Muchos protocolos de Internet operan de esta forma. Por ejemplo, el protocolo FTP (File Transport Protocol) utiliza en sálto de línea para indicar el final de un comando, transmitido al servidor. El protocolo HTTP (Hyper Text Transport Protocol) utiliza dos saltos de línea consecutivos para indicar el final de un requerimiento HTTP. El protocolo SMTP (Simple Mail Transport Protocol) utiliza la secuencia salto de línea – punto – salto de línea para indicar el final de un mail. Este último impide transmitir mails que contengan un punto como único caracter de una línea, lo cual de vez en cuando ocaciona problemas.</p>
<p>3 – Transmitir estructuras de tamaño fijo. Esta es una variante del primer método, pero en lugar de transmitirse siempre bloques de información del mismo tamaño, se definen una serie de estructuras de tamaño conocido. Los primeros n bytes especifican el tipo de estructura, lo cual permite saber al host remoto cuantos bytes debe recibir. En este caso el host que recibe los datos opera como sigue:</p>
<p>Inicia la recepción de n bytes, que contienen la identificación de la estructura a recibir. Una vez hecho esto,&nbsp; determina el tamaño de la estructura, y a continuación recibe tantos bytes como sea necesario.</p>
<p>Este método es muy utilizado, por su facilidad de implementación.</p>
<p>4 – Este método es una variante del método anterior, y es el más eficiente. El mismo consiste en codificar, en primer lugar, la cantidad de bytes a transmitir, utilizando una cantidad fija de bytes, seguida por los datos transmitidos. Es similar al método anterior, sólo que en lugar de codificarse el tipo de estructura, se codifica la cantidad de bytes a transmitir.</p>
<p>En este caso el host que recibe los datos opera como sigue:</p>
<p>Inicia la recepción de n bytes, en los cuales se codifica la cantidad de bytes a leer. Una vez hecho esto recibe tantos bytes como sea necesario.</p>
<p>Este método es utilizado, cuando la longitud de los datos puede ser muy variable.</p>
<h3>Elección de la forma de codificación</h3>
<p>Para determinar qué metodo es conveniente utilizar en un programa, debe analizarse las caracteríticas del mismo y los tipos de datos a transmitir. Nada impide utilizar esquemas mixtos, aunque esto puede resultar confuso.</p>
<p>Generalmente se utiliza el método 2 cuando la aplicación solo deberá transmitir texto. Cuando se deben transmitir registros de bases de datos, se suele utilizar el método 3, y cuando el tipo de datos a transmitir es muy variable, el método 4.</p>
<h2>Atención a múltiples clientes</h2>
<p>Es común que un servidor deba atender a varios clientes en forma simultánea. En ejemplo anterior, en lugar de cerrarse el socket <strong><em>SockEscucha</em></strong>, debería continuar recibiéndose llamadas entrantes.</p>
<p>¿Cómo puede el servidor procesar los requerimientos del cliente, y atender nuevas llamadas? Notar que para esto, deben atenderse dos sockets simultáneamente.</p>
<p>El código visto hasta ahora es idético para Windows y para UNIX, pero ahora se presenta la primer diferencia. Tanto Windows como UNIX proveen las funciones necesarias para esperar eventos de más de un socket en un único punto del programa, pero las mismas llevan a un código tan complejo e ineficiente que rara vez son utilizadas. En lugar de ello, en ambas plataformas la solución consiste en crear una nueva rama de ejecución, una para seguir esperando conexiones, y otra para atender al cliente. La forma de hacer esto en ambas plataformas difiere.</p>
<p>En UNIX se utiliza generalmente la función <strong><em>fork()</em></strong>, para crear un nuevo proceso que es una copia idéntica del anterior. El nuevo proceso no sólo crea un nuevo punto de ejecución, sino que literalmente duplica el proceso, duplicándose también toda la memoria utilizada por el proceso padre y todos los recursos del mismo.</p>
<p>El nuevo proceso creará una copia de los dos sockets abiertos por el padre (<strong><em>SockEscucha </em></strong>y <strong><em>SockConexion</em></strong>), con lo cual se tendrán 4 sockets. El nuevo proceso debe, en primer lugar, cerrar el socket <strong><em>SockEscucha</em></strong>, que no utilizará, y el padre debe cerrar el socket <strong><em>SockConexion</em></strong>.</p>
<p>Este tipo de programación lleva a programas muy simples y fáciles de leer. Al no haber interacción entre los procesos, los mismos pueden continuar ejecutándose en forma prácticamente independiente.</p>
<p>En Windows al solución consiste generalmente en crear una nueva thread o hilo de ejecución. Junto con la nueva thread se crea una pila y se duplican los registros del sistema, pero el nuevo punto de ejecución comparte la memoria con la thread inicial. Esto lleva a aplicaciones más eficientes, que pueden realizar un mejor uso de los recursos del sistema. De todas formas, ciertas características de Windows hacen que el resultado no sea tan bueno como podría esperarse. Debe aclararse que las versiones recientes de UNIX soportan la utilización de Threads.</p>
<p>Una vez creada la nueva thread o hebra de ejecución no se requiere ejecutar ninguna acción adicional. Generalmente la misma procesa los requerimientos del cliente, y cuando la conexión termina la Thread también lo hace.</p>
<p>La programación utilizando Threads puede resultar sumamente compleja, y los errores suelen ser difíciles de encontrar, ya que en muchos casos pueden deberse a concurrencia de threads sobre un mismo recurso, situación que es muy difícil de reproducir. Por ejemplo, un servidor, antes de cerrarse debería esperar a que todas las hebras creadas terminen, lo cual puede ser difícil de resolver.</p>
<h2>Socket asincrónicos</h2>
<p>Hasta ahora hemos visto la forma de programar utilizando sockets sincrónicos o bloqueantes, tal como fueron desarrollados por UNIX. Este tipo de programación presenta inconvenientes en la programación Windows. En nuestra aplicación anterior, que trabaja en modo consola. es admisible que la thread principal se quede “bloqueada” esperando una respuesta, pero en un programa con ventanas, la thread principal, encargada de atender los eventos y mensajes de la aplicación, de ninguna manera puede hacer esto. Una aternativa consiste en el uso de threads, lo cual suele ser una muy buena solución en muchos casos, pero no en todos.</p>
<p>El uso de threads que utilicen sockets bloqueates es una muy buena alternativa en programas que operan en forma independiente, tal como servidores autónomos, donde la interacción con el usuario es escasa, y por ende las threads trabajan en forma razonablemente independiente. Sin embargo, en programas que requieren una gran interacción con el usuario, el cual controlará los eventos de red, el código necesario para sincronizar las threads puede ser complejo. Como solución a este problema, Microsoft extendió el modelo de sockets copiado de UNIX, permitiendo el funcionamiento en forma no bloqueante. Cuando un socket es configurado como no bloquente, todas las funciones de red retornarán inmedatamente indicando el resultado de la misma, y en ningún caso dejarán trabada la aplicación en espera de un evento. Por ejemplo, si se llama a la función <strong><em>recv()</em></strong>, sin que se hayan recibido datos del host remoto, esta función retornará inmediatamente con un código de error WSAEWOULDBLOCK, que indica que la operación no se pudo realizar ya que para ello debe dejarse bloqueado el socket.</p>
<p>Utilizando la función <strong><em>setsockopt()</em></strong> es posible configurar el socket como bloqueante y no bloqueante en cualquier momento, incluso si el socket ya está conectado.</p>
<p>Microsoft no sólo extendió el funcionamiento de los sockets para evitar realizar operaciones que puedan dejar bloqueado el socket, sino que además agregó la posibilidad de realizar operaciones en background, el lo que llamó sockets asincrónicos. Por ejemplo, si se inicia una conexión con un host remoto utilizando un socket asincrónico, la llamada a la función <em><strong>connect()</strong></em> retornará inmediatamente, y el sistema operativo se encargará de realizar la conexión en background, informándole posteriormente a la aplicación el resultado de la misma.</p>
<p>Surge claramente la necesidad de incorporar una forma en que el sistema operativo (Windows) pueda entonces informar a la aplicación los eventos ocurridos. Por ejemplo, la aplicación necesita saber cuando se completa un requerimiento de conexión y el resultado del mismo, antes de comensar la transmisión o emitir un mensaje de error. De idéntica forma, necesita saber cuando se han recibido datos para poder llamar a la función <strong><em>recv()</em></strong> para que la aplicación los reciba.</p>
<p>Para lograr esto Microsoft recurrió a los clásicos mensajes de Windows, enviados en este caso por el sistema operativo a una ventana definida por la aplicación. Esto se hace utilizando la función WSAAsyncSelect(). Esta función está definida como sigue:</p>
<p>WSAAsyncSelect (SOCKET s, HWND hWnd, unsigned int wMsg, long lEvent);</p>
<p>El primer parámetro indica el socket que se quiere configurar. El segundo (hWnd) indica la ventana a la cual se deberán enviar las notificaciones. El tercero es un mensaje definido por el usuario, que se enviará a la ventana. Microsoft define una constante WM_USER, a partir de la cual las aplicaciones pueden definir mensajes propios. Finalmente el cuarto parámetro (lEvent) indica los eventos de los cuales la aplicación quiere ser notificada. Por código muy común es el siguiente, utilizando para solicitar a Windows que notifique a la aplicación los eventos de recepción de datos y corte de conexión:</p>
<pre>#define WM_RECIBIR_DATOS (WM_USER+10)
{
	SOCKET s;
	/* Establecer la conexión */
	...
	WSAAsyncSelect (s, hWnd, WM_RECIBIR_DATOS, FD_READ|FD_CLOSE);
	...
}</pre>
<p>Cuando se produzca el evento solicitado, Windows notificará a la aplicación enviándole un mensaje WM_RECIBIR_DATOS, en WPARAM indicará el socket en el cual se produjo el evento, en los 16 bits más significativos de LPARAM se indicará el resultado de la operación, y en los 16 bits menos significativos se indicará el evento producido.</p>
<p>No es posible en ningún caso definir más de un mensaje para un mismo socket. Es decir, si se escribiese algo como sigue:</p>
<pre>	WSAAsyncSelect (s, hWnd, WM_RECIBIR_DATOS, FD_READ);
	WSAAsyncSelect (s, hWnd, WM_SOCKET_CERRADO, FD_CLOSE);</pre>
<p>la segunda línea anularía a la primera.</p>
<h3>Importante</h3>
<p>Cabe destacar que:</p>
<ol>
<li>En el caso de los dos WSAAsyncSelect(), si bien la segunda     línea anula a la primera, es posible que algún evento correspondiente a la     llegada de datos ya haya sido encolado.</li>
<li>2) Todo socket, al ser creado es configurado inicialmente     como bloqueante.</li>
<li>Una llamada a WSAAsyncSelect() automáticamente configura     el socket como no bloquante.</li>
<li>Para que un socket pueda ser configurado como no bloquente     nuevamente es necesario que se deshabilite primero la recepción de     mensajes. Esto es, debe llamarse a WSAAsyncSelect() tal como se muestra a     continuación:<br>
WSAAsyncSelect (s, hWnd, 0, 0);<br>
Notar nuevamente que, si bien Windows no enviará más mensajes, es posible     que aún queden mensajes encolados.</li>
<li>Si se configura un socket para que notifique a la     aplicación la llegada de datos, Windows enviará un mensaje a la     aplicación cuando esto ocurra. Hasta que estos datos no hayan sido leídos     por la aplicación en su totalidad, Windows no enviará más eventos     relacionados con el socket. Por esta razón, es fundamental garantizar que,     al recibir una notificación de llegada de datos, toda la información     encolada sea leída.</li>
</ol>
											</span></pre></span></pre></div>
