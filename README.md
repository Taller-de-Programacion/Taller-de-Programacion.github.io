# Taller de programación I

Sitio no oficial de la materia 7542 - Taller de programación I

## Como contribuir

### Clone

Primero clonamos el sitio

```shell
$ git clone https://github.com/Taller-de-Programacion/Taller-de-Programacion.github.io.git
Cloning into 'Taller-de-Programacion.github.io'...
remote: Counting objects: ...
...
Checking connectivity... done.
```

o bien, lo actualizamos si ya lo teníamos clonado localmente

```shell
$ cd Taller-de-Programacion.github.io
$ git pull
Already up-to-date.
```
Y estando dentro de la carpeta ```Taller-de-Programacion.github.io```, levantamos el sitio con docker

### Agregar un post

Simplemente escribir un post dentro de la carpeta ```_posts/[año]``` con un nombre sin espacios con el formato ```[año]-[mes]-[dia]-[nombre-del-post].md```.
Cada post debe tener un encabezado de la forma

```yaml
---
layout: post
title: titulo-aqui
author: tu-nombre
date: la-fecha-de-publicacion

---

```

### Verificar localmente el post

Se utilizará la imagen ```jekyll/jekyll:pages``` del proyecto [jekyll/docker](https://github.com/jekyll/docker) ya que es la más similar a github-pages. 

El comando ```run``` creara un container a partir de la imagen. Es necesario hacerlo una vez: con los comandos ```start``` y ```stop``` podremos iniciar y detener el container sin necesidad de crearlo desde cero.

```shell
$ sudo docker run --entrypoint /usr/local/bin/jekyll \
                  -v $(pwd):/srv/jekyll -p 127.0.0.1:4000:4000 \
                  jekyll/jekyll:pages \
                  serve --watch --incremental
Unable to find image 'jekyll/jekyll:pages' locally
pages: Pulling from jekyll/jekyll
6023f1cb0d92: Pull complete 
ee35ef63d4e7: Pull complete
Status: Downloaded newer image for jekyll/jekyll:pages
fetch http://mirror.envygeeks.io/...
fetch ...
OK: 255 MiB in 72 packages
Fetching gem metadata from https://rubygems.org/...
...
Resolving dependencies...
Installing ...
....
Installing github-pages
Bundle updated!
Configuration file: /srv/jekyll/_config.yml
Configuration file: /srv/jekyll/_config.yml
            Source: /srv/jekyll
       Destination: /srv/jekyll/_site
 Incremental build: enabled
      Generating... 
                    done in 0.926 seconds.
 Auto-regeneration: enabled for '/srv/jekyll'
Configuration file: /srv/jekyll/_config.yml
    Server address: http://0.0.0.0:4000/
  Server running... press ctrl-c to stop.
```

Este último comando:
 1. descarga de la internet la *imagen* ```jekyll/jekyll:pages```. Si la imagen ya esta descargada este paso se ignora.
 1. crea un *container* de docker temporal tal que:
    - ```--entrypoint /usr/local/bin/jekyll``` indica cual es el comando a ejecutar al cargar el container.
    - ```-v $(pwd):/srv/jekyll``` indica que la carpeta virtual dentro del container ```/srv/jekyll``` debe en realidad mapearse a la carpeta real ```$(pwd)``` (el directorio actual).
    - ```-p 127.0.0.1:4000:4000``` indica que el puerto virtual dentro del container ```4000``` debe mapearse al puerto real ```4000``` sobre la interfaz ```127.0.0.1```. Cambiar esta interfaz por ```0.0.0.0``` para exportar el servicio hacia afuera del host.
    - ```jekyll/jekyll:pages``` indica que imagen usar como punto de partida para el container.
    - ```serve --watch --incremental``` son los argumentos del comando ```/usr/local/bin/jekyll```. En este caso, jekyll servirá el sitio (y lo actualizará si hay un cambio en los fuentes). Agregar ```--drafts``` para que se sirvan tambien los drafts de jekyll.
 1. con el container creado, se ejecuta el comando ```/usr/local/bin/jekyll serve --watch --incremental```. Este a su vez
    1. Instala ciertos paquetes con ```apk``` (son los "fetchs" de la salida del comando anterior).
    1. Instala ciertas gemas de ruby con ```bundle```, entre ellas ```github-pages``` (son los "Installing" de la salida anterior).
    1. Corre finalmente jekyll con los parámetros pasados.

> Nota: A veces los permisos se alteran y pueden terminar mapeandose a un grupo inválido con GID 65533, asegurarse de corregirlo
```chown``` para evitar errores al levantar el servidor.

El container puede ser detenido y reiniciado segun se desee:
Uno puede detenerlo sabiendo el id del container:

```shell
$ sudo docker ps -a
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                                 NAMES
47647a3c6c6c        jekyll/jekyll:pages   "/usr/local/bin/jekyl"   16 minutes ago      Up 16 minutes       127.0.0.1:4000->4000/tcp, 35729/tcp   jovial_bohr
```

y luego,

```shell
$ sudo docker stop 47647a3c6c6c
47647a3c6c6c
```

Para levantarlo no hace falta mas que

```shell
$ sudo docker start -a TallerPages
```
> Nota: el flag ```-a``` es opcional y permite *attachear* la consola del container a la terminal actual, útil para ver los logs de jekyll.

### Proponer el post

Habiendo probado localmente el post es hora de proponerlo para que sea integrado al sitio oficialmente.
Basta con solo commitearlo y hacer un Pull Request.

