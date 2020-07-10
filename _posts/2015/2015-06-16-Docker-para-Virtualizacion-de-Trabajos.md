---
layout: post
title: Docker para Virtualización de Trabajos
author: Pablo Roca
date: 16/06/2015
tags: [tutorial docker]
snippets: none
---

El siguiente artículo presenta las herramientas básicas para el uso de Docker, una plataforma de virtualización basada en el uso de contenedores.

# Instalación y Primeros Pasos

La instalación de Docker es muy secilla. Simplemente se debe ejecutar el comando:

```
sudo apt-get install docker.io
```

Luego, se puede comprobar que el sistema se encuentre correctamente configurado con ejecutando la forma más simple de un comando Docker:

```
$ sudo docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
```

El comando `ps` muestra las instancias de contenedores en ejecución. Al no haber ningún contenedor al momento, no hay resultados.

Para crear nuestro primer contenedor, ejecutamos:
```
$ sudo docker run ubuntu ls
bin
boot
...
```

Con este simple comando, pedimos a Docker que cree un contenedor basado en ubuntu y ejecute el comando `ls` dentro del mismo. Al finalizar la ejecución de `ls`, el contenedor finaliza y se cierra. Si queremos ejecutar comandos interactivos dentro de un contenedor, tenemos que ejecutar una consola de `bash` e indicar los flags `ti` (terminal interactivo):

```
$ sudo docker run -ti ubuntu /bin/bash
root@3153a87881c0:/#
```

En esta ocasión, se crea un contenedor que se mantiene abierto permitiendo la ejecución de varias instrucciones. Estas instrucciones pueden incluir la ejecución de comandos que modifiquen al contenedor, por ejemplo mediante la instalación de librerías.

Para más ejemplos sobre la sintaxis básica de los comandos Docker, es posible ejecutar un tutorial online en:

[https://www.docker.com/tryit/](https://www.docker.com/tryit/)

# Dockerfile y Construcción de Imágenes

Para automatizar la creación de imágenes de contenedores, con ciertas librerías se utiliza un formato de archivo llamado Dockerfile. A continuación, ejemplificamos el contenido de uno de estos archivos:

```
FROM ubuntu
RUN apt-get update
RUN apt-get install -qqy vim
```

Este archivo indica que las imágenes construidas se basan en una imagen previa conocida como `ubuntu`, más la ejecución de 2 comandos `apt-get.`

Para construir una imagen basada en esta configuración, ejecutamos el comando `build` y le damos un nombre, por ejemplo `imagen-prueba`:

```
$ sudo docker build -t imagen-prueba .
Sending build context to Docker daemon 40.45 kB
Sending build context to Docker daemon 
Step 0 : FROM ubuntu
 ---> 6d4946999d4f
Step 1 : RUN apt-get update
 ---> Using cache
 ---> 096d3f4e4c87
Step 2 : RUN apt-get install -qqy vim
 ---> Running in 01d44c891d58
dpkg-preconfigure: unable to re-open stdin: 
Selecting previously unselected package libgpm2:amd64.
(Reading database ... 11528 files and directories currently installed.)
Preparing to unpack .../libgpm2_1.20.4-6.1_amd64.deb ...
Unpacking libgpm2:amd64 (1.20.4-6.1) ...
...
```

Ahora podemos utilizar `imagen-prueba` como base para nuestros contenedores:

```
$ sudo docker run imagen-prueba vim
Vim: Warning: Output is not to a terminal
Vim: Warning: Input is not from a terminal

                VIM - Vi IMproved 
...
```

 
# Comandos Avanzados

## Publicar Variables de Entorno

Dado que las imágenes son estáticas (siempre que creamos una instancia se usa la imagen como plantilla de sólo lectura), resulta importante entender las formas de compartir información desde y hacia el contenedor virtualizado.

Las variables de entorno son una buena manera de comunicar valores al contenedor para configurar operaciones dentro del mismo. Para definir una variable de entorno, sólo es necesario utilizar el comando `e` como en el siguiente ejemplo:

```
$ sudo docker run -ti -e MESSAGE="Hola Mundo" ubuntu /bin/bash
root@3a72995361d0:/# echo $MESSAGE
Hola Mundo
```
`Compartir Archivos y Directorios`

Este comando resulta muy útil para utilizar archivos externos dentro del contenedor, modificarlos y que dichos cambios trasciendan la vida de la instancia creada. Para compartir archivos y directorios se utilizar el comando `v` que mapea archivos/directorios externos con una ruta definida dentro del contenedor.

Si se trata de una nueva ruta, el mapeo la define y monta el archivo/directorio externo. Si, por el contrario, la ruta ya existía en la imagen utilizada como plantilla, el mapeo la sobreescribe con la información externa. Veamos un ejemplo simple de uso:

```bash
$ sudo docker run -ti -v /tmp:/home/tmp ubuntu /bin/bash
root@74f0f9e45a7a:/# cd /home
root@74f0f9e45a7a:/home# ls
tmp
root@74f0f9e45a7a:/home# touch tmp/NuevoArchivo.txt
root@74f0f9e45a7a:/home# exit
exit
$ cd /tmp
$ ls *.txt
NuevoArchivo.txt
```

## Exponer Puertos

Utilizando esta capacidad, es posible conectar un contenedor con el sistema externo para intercambiar información por sockets. De la misma forma, permite conectar varios contenedores entre sí. El comando utilizado es `p` que requiere indicar el puerto origen (interno al contenedor) y el puerto destino (externo al contenedor, en el entorno no virtualizado) para realizar el mapeo. El siguiente ejemplo ejecuta un contenedor que abre el puerto 9000 y lo mapea al puerto 9001 del entorno no virtualizado mientras una segunda consola intenta obtener información de dicho puerto:

**Consola 1**

```
$ sudo docker run -ti -p 9001:9000 ubuntu /bin/bash
root@4c50749533c9:/# nc -l 9000
```

**Consola 2**

```
$ nc 127.0.0.1 9001
Hola
Hola
Mundo
Mundo
```

Este comando combinado con el comando `link`, permite conectar dos contenedores mediante un alias y establecer una comunicación por sockets entre los mismos.

# Ejemplos Prácticos

En la siguiente sección se exponen 2 casos típicos que son necesarios para la construcción de trabajos prácticos utiliziando Docker. En ambos casos, se incluye el código de referencia y los pasos de ejecución mediante scripts.

## Entorno de Ventanas dentro de Docker

En el modo de ejecución más  simple, las aplicaciones visuales creadas dentro de un contenedor Docker,  no pueden ser mostradas en el sistema no virtualizado. Para lograr que esto funcione se requiere compartir el sistema de ventanas ya sea mediante el formato X11 nativo o mediante algún sistema de manejo remoto como VNC. El siguiente ejemplo utiliza la primera opción dada su simplicidad.

En primer lugar, se define un archivo Dockerfile que instale el servidor X11 y algunas herramientas para poder crear un programa GTK+ dentro del contenedor:

```
FROM ubuntu
RUN apt-get update
RUN apt-get install -qqy x11-apps
RUN apt-get install -qqy build-essential
RUN apt-get install -qqy cmake libgtk2.0-dev pkg-config
ENV DISPLAY :0
```

La última instrucción, es muy importante para definir que el primer monitor del servidor X será compartido hacia afuera.

Luego, creamos el contenedor ejecutando:
```
sudo chmod +x build.sh
./build.sh
```

Este script simplemente ejecuta ‘sudo docker build -t sandbox .’, creando una imagen nueva llamada `sandbox`. Luego, para iniciar el contenedor es necesario definir ciertas variables de entorno con el comando `e` y un mapeo de directorios para montar nuestro código fuente dentro del servidor. El siguiente script realiza los pasos:

```
sudo chmod +x run.sh
./run.sh
```

Por último, ya dentro del contenedor, compilamos un pequeño programa GTK+ y lanzamos su ventana. La ventana será vista en nuestro sistema Linux gracias al mapeo del servidor X:

```
$ ./run.sh 
root@d621851baad4:/# cd /home/src
root@d621851baad4:/home/src# make
gcc -c -o main.o main.c -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include ...-I/usr/include/pixman-1 -I/usr/include/libpng12
gcc -o main main.o -pthread -I/usr/include/gtk-2.0 -I/usr/lib/x86_... -lcairo -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lfreetype 
root@d621851baad4:/home/src# ./main
Gtk-Message: Failed to load module "canberra-gtk-module"
```

El siguiente archivo posee los scripts y un directorio src con un Makefile y una simple ventana:

![](/assets/2010/08/file-zip.gif)

[single_docker_with_gtk.zip](/assets/2015/06/single_docker_with_gtk.zip)
 
## Cliente-Servidor Comunicados con Docker

En este caso, creamos una imagen con un Dockerfile simple, sin librerías particulares:

```bash
$ sudo chmod +x build.sh
$ ./build.sh
```

Luego, ejecutamos 2 contenedores Docker: un cliente y un servidor. El servidor debe ser creado primero con un nombre que nos servirá para conectarlo con el cliente y con un mapeo del puerto 9000 (elegido arbitrariamente para este ejemplo).

Finalmente, se lanza el contendor cliente y se crean los programas cliente-servidor en los respectivos entornos:


```bash
*Consola 1*

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
                                  
                                  * Consola 2 *
                                  $ ./run.sh client
                                  root@2e911df6c0a2:/# cd /home/src/
                                  root@2e911df6c0a2:/home/src# ./client server_machine 9000
New client. Sending message...
                                  Receiving message...
                                  Message received: A
Message sent. Closing connection...

```

El contenido del script de ejecución es ligeramente más complejo que en otros casos:

```
#!/bin/bash
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
fi
```

El siguiente archivo posee los scripts y un directorio src con un Makefile y los códigos del cliente-servidor:

![](/assets/2010/08/file-zip.gif)

[two_dockers_connected_by_ports.zip](/assets/2015/06/two_dockers_connected_by_ports.zip)
