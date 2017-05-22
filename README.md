# Taller de programación I

Sitio no oficial de la materia 7542 - Taller de programación I

## Como levantar localmente el sitio con docker

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

Se utilizará la imagen ```jekyll/jekyll:pages``` del proyecto [jekyll/docker](https://github.com/jekyll/docker) ya que es la más similar a github-pages. 

```shell
$ sudo docker run --rm --entrypoint /usr/local/bin/jekyll \
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
    - ```--rm``` remueve el container una vez terminada la ejecución.
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

## Como detener el servicio del sitio

Uno puede detener al ejecución de jekyll sabiendo el id del container:

```shell
$ sudo docker ps -a
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                                 NAMES
47647a3c6c6c        jekyll/jekyll:pages   "/usr/local/bin/jekyl"   16 minutes ago      Up 16 minutes       127.0.0.1:4000->4000/tcp, 35729/tcp   jovial_bohr
```

y luego, pararlo

```shell
$ sudo docker stop 47647a3c6c6c
47647a3c6c6c
```

## Como levantar localmente el sitio con docker (versión offline)

En muchas ocaciones no queremos estar descargandonos la última versión de jekyll para tan solo escribir un post.
Para levantar el sitio sin necesitar estar online hay que hacer algunos pasos extra.

### Setup (se necesita estar online)

En vez de correr un comando en un container temporal, podemos (y debemos!) hacer un container persistente.

```shell
$ sudo docker run --name TallerPages --entrypoint /usr/local/bin/jekyll \
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

Este es el mismo comando que el anterior pero hemos removido el flag ```--rm``` para hacer al container persistente y agregado el ```--name TallerPages``` para darle un nombre. Puedes cambiar el nombre ```TallerPages``` por otro si quieres.

Ahora en otra consola deberemos entrar al container y modificar el script ```/usr/local/bin/jekyll``` para que no realize ninguna actualización.
Para ello, en otra consola hacemos

```shell
$ sudo docker exec -it TallerPages /bin/bash
bash-4.3# vi /usr/local/bin/jekyll
```

Y buscamos el siguiente código dentro del archivo
```bash
if [ -f Gemfile ]; then                         
  apk --update add build-base ruby-dev         
  bundle update -j 12                          
  
  sudo -EHu jekyll bundle exec ruby \           
    /usr/local/bin/args "$@" || status=$?
```

y lo reemplazamos por 

```bash
if [ -f Gemfile ]; then                         
  #apk --update add build-base ruby-dev         
  #bundle update -j 12                          
  cp /var/Gemfile* .                            
  sudo -EHu jekyll bundle exec ruby \           
    /usr/local/bin/args "$@" || status=$?
```

que basicamente comenta las líneas de código que hacen el update y agrega una línea más que "restaura" los archivos actualizados.
Continuando dentro del shell del container es necesario hacer un backup de los archivos ```Gemfile*``` para que el script los encuentre

```shell
bash-4.3# cp Gemfile* /var                                                                                                    
bash-4.3# exit
```


### Start / Stop (offline)

Habiendo hecho esto, podemos frenar e iniciar el sitio sin necesidad de conectarnos a la internet simplemente con un stop y un start.

```shell
$ sudo docker stop TallerPages
TallerPages

$ sudo docker start -a TallerPages
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

Nota: el flag ```-a``` es opcional y permite *attachear* la consola del container a la terminal actual, útil para ver los logs de jekyll.

