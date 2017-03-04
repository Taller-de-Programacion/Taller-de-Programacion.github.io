---
layout: post
title: Docker para Virtualización de Trabajos
author: Pablo Roca
date: 16/06/2015
snippets: none

---
<div class="entry-content">
						<p>El siguiente artículo presenta las herramientas básicas para el uso de Docker, una plataforma de virtualización basada en el uso de contenedores.</p>
<h1>Instalación y Primeros Pasos</h1>
<p>La instalación de Docker es muy secilla.&nbsp;Simplemente se debe ejecutar el comando:</p>
<pre>sudo apt-get install docker.io</pre>
<p>Luego, se puede comprobar&nbsp;que el sistema&nbsp;se encuentre correctamente configurado con ejecutando la forma más simple de un comando Docker:</p>
<pre>$ sudo docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES</pre>
<p>El comando <strong>ps</strong>&nbsp;muestra las instancias de contenedores en ejecución. Al no haber ningún contenedor al momento, no hay resultados.</p>
<p>Para crear nuestro primer contenedor, ejecutamos:</p>
<pre>$ sudo docker run ubuntu ls
bin
boot
...</pre>
<p>Con este simple comando, pedimos a Docker que cree un contenedor basado en ubuntu y ejecute el comando <strong>ls</strong> dentro del mismo. Al finalizar la ejecución de <strong>ls</strong>, el contenedor finaliza y se cierra. Si queremos ejecutar comandos interactivos dentro de un contenedor, tenemos que ejecutar una consola de <strong>bash</strong> e indicar los flags <strong>ti</strong> (terminal interactivo):</p>
<pre>$ sudo docker run -ti ubuntu /bin/bash
root@3153a87881c0:/#</pre>
<p>En esta ocasión, se crea un contenedor que se mantiene abierto permitiendo la ejecución de varias instrucciones. Estas instrucciones pueden incluir la ejecución de comandos que modifiquen al contenedor, por ejemplo mediante la instalación de librerías.</p>
<p>Para más ejemplos sobre la sintaxis básica de los comandos Docker, es posible ejecutar un tutorial online en:</p>
<ul>
<li><a href="https://www.docker.com/tryit/">https://www.docker.com/tryit/</a></li>
</ul>
<p>&nbsp;</p>
<h1>Dockerfile y&nbsp;Construcción de Imágenes</h1>
<p>Para automatizar la creación de imágenes de contenedores, con ciertas librerías se utiliza un formato de archivo llamado Dockerfile. A continuación, ejemplificamos el contenido de uno de estos archivos:</p>
<pre>FROM ubuntu
RUN apt-get update
RUN apt-get install -qqy vim</pre>
<p>Este archivo indica que las imágenes construidas se basan en una imagen previa conocida como <strong>ubuntu</strong>, más la ejecución de 2 comandos <strong>apt-get.</strong></p>
<p>Para construir una imagen basada en esta configuración, ejecutamos el comando <strong>build</strong> y le damos un nombre, por ejemplo <strong>imagen-prueba</strong>:</p>
<pre>$ sudo docker build -t imagen-prueba .
Sending build context to Docker daemon 40.45 kB
Sending build context to Docker daemon 
Step 0 : FROM ubuntu
 ---&gt; 6d4946999d4f
Step 1 : RUN apt-get update
 ---&gt; Using cache
 ---&gt; 096d3f4e4c87
Step 2 : RUN apt-get install -qqy vim
 ---&gt; Running in 01d44c891d58
dpkg-preconfigure: unable to re-open stdin: 
Selecting previously unselected package libgpm2:amd64.
(Reading database ... 11528 files and directories currently installed.)
Preparing to unpack .../libgpm2_1.20.4-6.1_amd64.deb ...
Unpacking libgpm2:amd64 (1.20.4-6.1) ...
...</pre>
<p>Ahora podemos utilizar <strong>imagen-prueba</strong> como base para nuestros contenedores:</p>
<pre>$ sudo docker run imagen-prueba vim
Vim: Warning: Output is not to a terminal
Vim: Warning: Input is not from a terminal

                VIM - Vi IMproved 
...</pre>
<p>&nbsp;</p>
<h1>Comandos Avanzados</h1>
<h2>Publicar Variables de Entorno</h2>
<p>Dado que las imágenes son estáticas (siempre que creamos una instancia se usa la imagen como plantilla de sólo lectura),&nbsp;resulta importante entender las formas de compartir información desde y hacia el contenedor virtualizado.</p>
<p>Las variables de entorno son una buena manera de&nbsp;comunicar valores al contenedor para configurar operaciones dentro del mismo. Para definir una variable de entorno, sólo es necesario utilizar el comando <strong>e</strong> como en el siguiente ejemplo:</p>
<pre>$ sudo docker run -ti -e MESSAGE="Hola Mundo" ubuntu /bin/bash
root@3a72995361d0:/# echo $MESSAGE
Hola Mundo</pre>
<h2>Compartir Archivos y Directorios</h2>
<p>Este comando resulta muy útil para utilizar archivos externos dentro del contenedor, modificarlos y que dichos cambios trasciendan la vida de la instancia creada. Para compartir&nbsp;archivos y directorios se utilizar el comando <strong>v&nbsp;</strong>que mapea archivos/directorios externos con una ruta definida dentro del contenedor. Si se trata de una nueva ruta, el mapeo la define y monta el archivo/directorio externo. Si, por el contrario, la ruta ya existía en la imagen utilizada como plantilla, el mapeo la sobreescribe con la información externa. Veamos un ejemplo simple de uso:</p>
<pre>$ sudo docker run -ti -v /tmp:/home/tmp ubuntu /bin/bash
root@74f0f9e45a7a:/# cd /home
root@74f0f9e45a7a:/home# ls
tmp
root@74f0f9e45a7a:/home# touch tmp/NuevoArchivo.txt
root@74f0f9e45a7a:/home# exit
exit
$ cd /tmp
$ ls *.txt
NuevoArchivo.txt</pre>
<h2>Exponer&nbsp;Puertos</h2>
<p>Utilizando esta capacidad, es posible conectar un contenedor con el sistema externo para intercambiar información por sockets. De la misma forma, permite conectar varios contenedores entre sí. El comando utilizado es <strong>p</strong>&nbsp;que requiere indicar el puerto origen&nbsp;(interno al&nbsp;contenedor) y el puerto destino (externo al contenedor, en el entorno no virtualizado) para realizar el mapeo. El siguiente ejemplo ejecuta un contenedor que abre el puerto 9000&nbsp;y&nbsp;lo mapea al puerto 9001 del entorno no virtualizado mientras una segunda consola intenta obtener información de dicho puerto:</p>
<pre style="padding-left: 30px;"><strong>Consola 1</strong>
$ sudo docker run -ti -p 9001:9000 ubuntu /bin/bash
root@4c50749533c9:/# nc -l 9000
                                      <strong>Consola 2</strong>
                                      $ nc 127.0.0.1 9001
                                      Hola
Hola
                                      Mundo
Mundo
</pre>
<p>Este comando combinado con el comando <strong>link</strong>, permite conectar&nbsp;dos contenedores mediante un alias y establecer una comunicación por sockets entre los mismos.</p>
<h1>Ejemplos Prácticos</h1>
<p>En la siguiente sección se&nbsp;exponen 2 casos típicos que son necesarios para la construcción de trabajos prácticos&nbsp;utiliziando Docker. En ambos casos, se incluye&nbsp;el código de referencia y los pasos de ejecución mediante scripts.</p>
<h2>Entorno de Ventanas dentro de Docker</h2>
<p>En el modo de ejecución más &nbsp;simple, las aplicaciones visuales creadas dentro de un contenedor Docker, &nbsp;no pueden ser mostradas en el sistema no virtualizado. Para lograr que esto funcione se requiere compartir el sistema de ventanas ya sea mediante el formato X11 nativo o mediante algún sistema de manejo remoto como VNC. El siguiente ejemplo utiliza la primera opción dada su simplicidad.</p>
<p>En primer lugar, se define un archivo Dockerfile que&nbsp;instale el servidor X11 y algunas herramientas para poder crear un programa GTK+ dentro del contenedor:</p>
<pre>FROM ubuntu
RUN apt-get update
RUN apt-get install -qqy x11-apps
RUN apt-get install -qqy build-essential
RUN apt-get install -qqy cmake libgtk2.0-dev pkg-config
ENV DISPLAY :0</pre>
<p>La última instrucción, es muy importante para definir que el&nbsp;primer monitor del servidor X será compartido hacia afuera.</p>
<p>Luego, creamos el contenedor ejecutando:</p>
<pre>sudo chmod +x build.sh
./build.sh</pre>
<p>Este script simplemente ejecuta ‘sudo docker build -t sandbox .’, creando una imagen nueva llamada <strong>sandbox</strong>. Luego, para iniciar el contenedor es necesario definir ciertas variables de entorno con el comando <strong>e</strong> y un mapeo de directorios para montar nuestro código fuente dentro del servidor. El siguiente script realiza los pasos:</p>
<pre>sudo chmod +x run.sh
./run.sh</pre>
<p>Por último,&nbsp;ya dentro del contenedor, compilamos un pequeño programa GTK+ y lanzamos su ventana. La ventana será vista en nuestro sistema Linux gracias al mapeo del servidor X:</p>
<pre>$ ./run.sh 
root@d621851baad4:/# cd /home/src
root@d621851baad4:/home/src# make
gcc -c -o main.o main.c -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include ...-I/usr/include/pixman-1 -I/usr/include/libpng12
gcc -o main main.o -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_... -lcairo -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lfreetype 
root@d621851baad4:/home/src# ./main
Gtk-Message: Failed to load module "canberra-gtk-module"</pre>
<p>El siguiente archivo posee los scripts y un directorio src con un Makefile y una simple ventana:</p>
<p><img class="  wp-image-72 alignleft" src="http://7542.fi.uba.ar/wp-content/uploads/2010/08/file-zip.gif" alt="Archivo ZIP" width="61" height="61"></p>
<p><a href="/assets/2015/06/single_docker_with_gtk.zip">single_docker_with_gtk.zip</a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h2>Cliente-Servidor&nbsp;Comunicados con&nbsp;Docker</h2>
<p>En este caso, creamos una imagen con un Dockerfile simple, sin librerías particulares:</p>
<pre>$ sudo chmod +x build.sh
$ ./build.sh</pre>
<p>Luego, ejecutamos 2 contenedores Docker: un cliente y un servidor. El servidor debe ser creado primero con un nombre que nos servirá para conectarlo con el cliente y con un mapeo del puerto 9000 (elegido arbitrariamente para este ejemplo). Luego, se lanza el contendor&nbsp;cliente y se crean los programas cliente-servidor en los respectivos entornos:</p>
<pre><strong>Consola 1</strong>
$ sudo chmod +x run.sh
$ ./run.sh server
ad2f62441ac7
ad2f62441ac7
root@0ff376ec794d:/# cd /home/src
root@0ff376ec794d:/home/src# ls 
Makefile client.c server.c
root@0ff376ec794d:/home/src# make
gcc -c -o server.o server.c 
gcc -o server server.o 
gcc -c -o client.o client.c 
gcc -o client client.o 
root@0ff376ec794d:/home/src# ./server 9000
Accepting connections at 9000...
                                  <strong>Consola 2</strong>
                                  $ ./run.sh client
                                  root@2e911df6c0a2:/# cd /home/src/
                                  root@2e911df6c0a2:/home/src# ./client server_machine 9000
New client. Sending message...
                                  Receiving message...
                                  Message received: A
Message sent. Closing connection...
</pre>
<p>El contenido del script de ejecución es&nbsp;ligeramente más complejo que en otros casos:</p>
<pre>#!/bin/bash
SERVER_ALIAS=server_machine
SERVER_PORT=9000

FOLDER_FLAGS="-v $PWD/src:/home/src"

if [[ $1 == server ]]; then
 SERVER_PORTS_FLAGS="-p $SERVER_PORT:$SERVER_PORT --name sandbox_server"
 SERVER_ID=$(sudo docker ps -a | grep "sandbox_server" | awk '{print $1}')
 if [[ ! -z "$SERVER_ID" ]]; then
 sudo docker stop $SERVER_ID
 sudo docker rm $SERVER_ID
 fi
 sudo docker run -ti $DISPLAY_FLAGS $FOLDER_FLAGS $SERVER_PORTS_FLAGS sandbox-server-client /bin/bash
elif [[ $1 == client ]]; then
 CLIENT_PORTS_FLAGS="--link sandbox_server:$SERVER_ALIAS"
 sudo docker run -ti $DISPLAY_FLAGS $FOLDER_FLAGS $CLIENT_PORTS_FLAGS sandbox-server-client /bin/bash
else
 echo "USAGE: ./run.sh (client|server)"
fi</pre>
<p>El siguiente archivo posee los scripts y un directorio src con un Makefile y los códigos del cliente-servidor:</p>
<p><a href="/assets/2010/08/file-zip.gif"><img class="  wp-image-72 alignleft" src="http://7542.fi.uba.ar/wp-content/uploads/2010/08/file-zip.gif" alt="Archivo ZIP" width="55" height="55"></a></p>
<p><a href="/assets/2015/06/two_dockers_connected_by_ports.zip">two_dockers_connected_by_ports.zip</a></p>
<p>&nbsp;</p>
											</div>
