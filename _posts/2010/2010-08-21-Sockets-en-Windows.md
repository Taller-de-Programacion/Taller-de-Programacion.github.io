---
layout: post
title: Sockets en Windows
author: admin
date: 21/08/2010
snippets: 
    - |
        ```cpp
        #include <winsock.h>
        #include <iostream.h>
         int c;
         void main (void)
        {
         SOCKADDR_IN remend; //info del servidor remoto
         SOCKADDR_IN lclend; //info de la maquina local
          WORD wVersionRequested; //para inicializar el winsock
         WSADATA wsaData; //para inicializar el winsock
         wVersionRequested = MAKEWORD(1, 1); //para inicializar el winsock
         WSAStartup(wVersionRequested, &wsaData); //para inicializar el winsock
          SOCKET remot = socket(AF_INET, SOCK_STREAM, 0);//creo un socket
         // if(remot!=INVALID_SOCKET) cout <<"ok";
         setsockopt (remot, IPPROTO_TCP, SO_REUSEADDR | SOCK_STREAM, (char*)&c, sizeof(int));
         // le cargo las caracteristicas de la coneccion
         // | TCP_NODELAY
          lclend.sin_family = AF_INET; //tipo de comunicacion
         u_short alport = IPPORT_RESERVED; //ultimo port asignablw
         lclend.sin_addr.s_addr = 0; //direccion local
         do {
           remend.sin_port = htons(alport);
           alport--;
         }while (bind (remot, (LPSOCKADDR)&lclend, sizeof (SOCKADDR_IN)) != 0);
          // servidor de http de yahoo
         remend.sin_addr.s_addr = (64) | (58<<8) | (76<<16) | (227<<24);
         remend.sin_port = ntohs(80); //port del http
         remend.sin_family = AF_INET;
          /*cout <<*/ connect(remot, (LPSOCKADDR)&remend, sizeof (SOCKADDR_IN)); //conectarse
         char *buff = new char[100];
         strcpy(buff, "GET /index.html\n");
         send (remot, buff, strlen(buff), 0); //pedido de info
          while (recv(remot, buff, 1, 0)) //copio de a 1 por que no es un string
         // y sino al tirarlo a la pantalla hace fruta
          cout << (char)*buff; //mandar todo lo recibido a la panrtalla
         delete[] buff;
          //la comunicacion tcp esta terminada cuando recv devolvio 0
         closesocket (remot); //cierra el socket
        }
        ```

---
<div class="entry-content">
						<table border="1">
<tbody>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Tema</strong></td>
<td>Sockets</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Versión</strong></td>
<td width="10%">1.01</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Resumen</strong></td>
<td colspan="3">Este documento describe como iniciar una conexión TCP       usando la API de winsock</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Sistema Operativo</strong></td>
<td colspan="3">WINDOWS 9x, Me, NT, 2000, XP</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Autor</strong></td>
<td>Gonzalo D. Merayo</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Fecha</strong></td>
<td width="10%">23/8/2001</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Búsqueda</strong></td>
<td colspan="3">Socket – WSAStartup –setsockopt – bind – connect –       send – recv</td>
</tr>
</tbody>
</table>
<h2>1) Inicialización de Winsock</h2>
<p>Antes de llamar a cualquier función de la API de winsock hay que iniciarla.</p>
<p>Inicialización de la API Winsock:</p>
<p>La misma se crea mediante el uso de la función <strong>WSAStartup</strong>. La misma recibe 2 parámetros:</p>
<p>1. <strong>wVersionRequested</strong>: La versión más reciente de winsock el programador puede usar, para lo que necesitamos es suficiente con MAKEWORD(1, 1).</p>
<p>2. <strong>lpWSAData</strong>: un puntero a una estructura WSADATA que recibirá detalles sobre la versión de Winsock.</p>
<h2>2) Creación y Configuración del Socket</h2>
<p>Antes de iniciar la conexión hay que crear y configurar un socket</p>
<h3>Creación del Socket:</h3>
<p>La misma se logra usando la función <strong>Socket</strong> con los siguientes parámetros:</p>
<p>1. <strong>af</strong>: Formato de las direcciones, debe ser AF_INET.</p>
<p>2. <strong>type</strong>: Tipo de conexión, existen muchas características sobre la conexión para configurar, básicamente alcanza con SOCK_STREAM.</p>
<p>3. <strong>protocol</strong>: Protocolo a usar, en caso de comunicaciones por internet puede ser IPPROTO_TCP o IPPROTO_UDP. Existen otros tipos de protocolo para redes IPX y otros, pero no son compatibles con internet. 0 si no se desea especificar protocolo.</p>
<p>El valor devuelto es del tipo SOCKET, en realidad es int, y si no hubo error es distinto de 0</p>
<h3>Configuración del Socket</h3>
<p>Para configurar el socket se usa <strong>setsockopt</strong> con los siguientes parámetros:</p>
<p>1. <strong>s</strong>: el socket que configuraremos.</p>
<p>2. <strong>level</strong>: para nosotros IPPROTO_TCP</p>
<p>3. <strong>optname</strong>: opciones de la comunicación SO_REUSEADDR | SOCK_STREAM.</p>
<p>4. <strong>optval</strong>: Puntero a buff donde se guardan las opciones.</p>
<p>5. <strong>optlen</strong>: tamaño del buffer.</p>
<h3>Binding del Socket</h3>
<p>Antes de conectarse con el servidor remoto, se debe obtener un puerto local para la conexión. Para esto se usa la función bind que toma:</p>
<p>1. <strong>s</strong>: Socket al que se le asignara el puerto.</p>
<p>2. <strong>addr</strong>: Dirección local del socket.</p>
<p>3. <strong>namelen</strong>: Longitud de addr.</p>
<p>Devuelve 0 si todo sale bien</p>
<h2>3) Conexión del Socket</h2>
<p>Conexión del Socket</p>
<p>Esta es a través de la función connect con los siguientes parámetros:</p>
<p>1. <strong>s</strong>: Socket al que se le asignara el puerto.</p>
<p>2. <strong>name</strong>: Dirección remota del socket.</p>
<p>3. <strong>namelen</strong>: Longitud de name.</p>
<p>Devuelve 0 si todo sale bien.</p>
<h2>4) Transferencia de datos</h2>
<h3>Envío de datos</h3>
<p>Se hace a través de send con estos parámetros:</p>
<p>1. <strong>s</strong>: Identificador del Socket.</p>
<p>2. <strong>buf</strong>: Puntero a la información a enviar.</p>
<p>3. <strong>len</strong>: Longitud de los datos a enviar.</p>
<p>4. <strong>flags</strong>: no se necesita ninguno para sock stream, 0</p>
<p>Devuelve la cantidad de bytes enviados exitosamente.</p>
<h3>Recepción de datos</h3>
<p>Se hace a través de recv:</p>
<p>1. <strong>s</strong>: Identificador del socket</p>
<p>2. <strong>buff</strong>: buffer donde se recibirán los datos</p>
<p>3. <strong>len</strong>: longitud del buffer</p>
<p>4. <strong>flags</strong>: 0</p>
<p>Devuelve la cantidad de bytes puestos en el buffer, 0 significa que la conexión se cerro. Si el socket no tiene ninguna información esperando, entonces recv espera que llegue algún paquete.</p>
<p>Si tiene alguna cantidad de bytes, pone tantos como puede en el buffer y sale.</p>
<h2>5) Destrucción del Socket</h2>
<p>Para cerrar un socket se llama a la función <strong>closesocket</strong> que recibe un único parámetro que es el numero de socket.</p>
<h2>6) Ejemplo</h2>
<p>Este ejemplo se conecta a el servidor de http de yahoo y baja el contenido del index a la pantalla:</p>
<div><div id="highlighter_258055" class="">{{page.snippets[0] | markdownify }}</div></div>
											</div>
