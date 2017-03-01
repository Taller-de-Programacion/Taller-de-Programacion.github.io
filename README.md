# Taller de programación I

Sitio no oficial de la materia 7542 - Taller de programación I

## Jekyll para docker

Se utilizará la imagen jekyll/jekyll:pages ya que es la más similar a github-pages


## Crear una página de 0

Para crear una página de jekyll desde 0, crearemos un container temporal con el siguiente comando

	docker run --rm --entrypoint /usr/local/bin/jekyll -v <path-site>:/srv/jekyll jekyll/jekyll:pages new .

Notese que el comando termina en un punto, ya que el comando new necesita de una carpeta de destino

[!] Notar que el entrypoint está buggeado y puede ser necesario sobreescribirlo con *--entrypoint /usr/local/bin/jekyll*
[!] A veces los permisos se alteran y pueden terminar mapeandose a un grupo invalido con GID 65533, asegurarse de corregirlo
chown para evitar errores al levantar el servidor.

## Levantar el servidor

Para crear un container de docker para correr Jekyll, correr el comando

	docker create --name *nombre* --entrypoint /usr/local/bin/jekyll -v <path-site>:/srv/jekyll -p 4000:4000 jekyll/jekyll:pages serve

Luego correr con docker start *nombre*

*Tip*: Usar -a para adjuntar la consola.


## Algunos comandos usados

	docker create --entrypoint /usr/local/bin/jekyll --name 7542-site -v $PWD/7542-site:/srv/jekyll -p 4000:4000 jekyll/jekyll:pages serve --watch

* Watch activa el rebuild automático ante cambios.

	docker