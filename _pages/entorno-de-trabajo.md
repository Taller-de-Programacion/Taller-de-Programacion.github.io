---
layout: main-topic-page
title: Entorno de trabajo
sidebar-include: sidebar-guia-electronica.html
permalink: /entorno-de-trabajo
hide_post_meta: true
tags: [Trabajos Prácticos]
nav-trabajos-practicos: active

---

El sistema de entregas
<a href="{{ site.sercom_url }}" target="_blank">Sercom</a> compila y
testea los trabajos en un Ubuntu Focal 20.04 de 64 bits.

Como compilador de C/C++ se usa el GCC 9.3.0; y para la verificación se
usa [cppcheck](http://cppcheck.sourceforge.net/) 1.90,
[cpplint](https://github.com/cpplint/cpplint) 1.4.5 (verificación estática),
[valgrind](https://valgrind.org/) 3.15.0 (verificación dinámica) y
[tiburoncin](https://github.com/eldipa/tiburoncin) 2.1.1 (verificación
de protocolo).

Es necesario que tengas un entorno de building igual o muy similar al
del Sercom para que puedas probar tu código localmente.

Para ello tenes varias alternativas:

 - **Todo en uno**: usas un Ubuntu para desarrollar, buildear y testear
 - **Con una VM**: usas un Windows/Linux donde desarrollas y una máquina virtual con un
Ubuntu donde buildear y testear.
 - **Con un Docker**: usas un Windows/Linux donde desarrollas y el docker de Taller donde
buildear y testear.,

Sea cual sea, que tu **entorno de desarrollo sea comodo y te haga lo mas
productivo posible**.

## Todo en uno

La idea es tener en una misma máquina tanto el entorno de desarrollo
como el de building.

Cualquier Linux moderno debería funcionar mientras provea un compilador
compatible con los estándares C17, C++17 y POSIX 2008  pero te
recomendamos que instales el mismo Linux que tiene el Sercom.

Para ello necesitaras un [Ubuntu](https://ubuntu.com/) o su variante mas ligera
[Xubuntu](https://xubuntu.org/).

Si queres usar otra distribución que no sea Ubuntu esta perfecto, pero
ten en cuenta que tendrás que ajustar/adaptar algunas cosas de este
texto.

### Instalar las herramientas

Solo tenes que correr:

```shell
$ sudo apt-get update
$ sudo apt-get install              \
            make                    \
            git                     \
            gcc                     \
            g++                     \
            python3                 \
            python3-pip             \
            python3-dev             \
            valgrind                \
            gdb                     \
            bsdmainutils            \
            diffutils               \
            manpages-dev            \
            build-essential         \
            strace                  \
            unzip                   \
            cppcheck
```

Como veras hay algunas herramientas adicionales para debugging:
[GDB](https://www.gnu.org/software/gdb/) y
[strace](https://man7.org/linux/man-pages/man1/strace.1.html)

No es necesario que uses GDB pero lo que **sí** es necesario es que uses
algún debugger compatible con GCC.

Recordá que tu **entorno te haga lo mas productivo posible**: debuggear
con `printf` es **lento**.

Para instalar [tiburoncin](https://github.com/eldipa/tiburoncin) sólo tenes
que clonarte el repositorio y compilarlo:

```shell
$ git clone https://github.com/eldipa/tiburoncin.git
$ cd tiburoncin
$ make
$ sudo cp tiburoncin /usr/bin/
$ cd ..
```

## Con una VM

La idea es separar el donde trabajas (desarrollas/codeas) del donde
compilas y testeas.

Podes trabajar en el Windows o en el Linux de tu preferencia (o en una
Mac si queres) y usar una máquina virtual para compilar/testear.

Una máquina virtual (VM) te permite tener una computadora dentro de otra,
totalmente aislada de la máquina real, *el host*.

Si el host es un hardware de 64 bits relativamente moderno, la VM
correrá casi con una performance casi nativa (como si fuera el host).

Solo tenes que tener activado VT-x/AMD-V en la máquina virtual.

Hay varios virtualizadores para usar:
[VirtualBox](https://www.virtualbox.org/),
[QEMU](https://www.qemu.org/), [VMware](https://www.vmware.com) y si
estas usando Windows 10, podes usar [Hyper
V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

De los mencionados, VirtualBox y VMware son los mas fáciles de usar.

> Si tenes Windows 10, puede que tengas que *deshabilitar* Hyper V para
> poder usar otro virtualizador.

Una vez que tengas instalado el virtualizador que desees tendrás que
crearte una máquina virtual e instalarle el Linux que usar el Sercom.

Con la máquina creada tendras que instalarle todas las herramientas de
compilación como se muestra en las sección `Todo en uno`

### Compartir archivos entre el host y la VM

Si queres desarrollar en el host tendrás que configurar tu VM para que cierta
carpeta estén *compartidas* entre la VM y el host.

Lo que se conoce como *shared folders*.

Así podes desarrollar en tu máquina local guardando los archivos en una
carpeta compartida y luego desde la VM los compilas y testeas.


## Con un Docker

Al igual que en la sección `Con una VM`, la idea es separar
el donde trabajas (desarrollas/codeas) del donde compilas y testeas.

Podes trabajar en el Windows o en el Linux de tu preferencia (o en una
Mac si queres) y usar un container de [Docker](https://www.docker.com/)
para compilar/testear
(tene en cuenta que el soporte de Docker en Windows es muy nuevo así que
lo preferible es que tu host sea un Linux).

La imagen del container de Docker será la misma que la que usar el
Sercom que ya vienen con todas las herramientas necesarias para
trabajar.

Para descargarte la image tenes que tener `docker` instalado y luego
ejecutar:

```shell
$ sudo docker pull eldipa/sercom-student-ubuntu
```


### Creación del container

Para crearte un container usado dicha imagen deberás ejecutar:

```shll
$ sudo docker run --name taller -it -w /mnt/ -v /home/user/wd:/mnt/ eldipa/sercom-student-ubuntu bash
```

Ese comando te creará un container llamado `taller` y te dará una
consola para que puedas ejecutar comandos ahí.

El flag `-v /home/user/wd:/mnt/` hará que la carpeta local `/home/user/wd`
sea accesible dentro del container como la carpeta `/mnt/` quien pasará
a ser el *current working* con `-w /mnt/`.

Con ese parámetro podrás compartir archivos entre el host y el docker y
de esa manera podrás desarrollas/codear en el host y compilar/testear en
el docker.

Obviamente deberás cambiar `/home/user/wd` por **tu** carpeta local.

Si el container ya estaba creado ese `docker run` te fallará.

Podes inicializar un container previamente creado con:

```shell
$ sudo docker start -a taller bash
```

### Multiples consolas

Si ya tenes un container creado e inicializado y queres tener mas de una
consola, podes abrir consolas adicionales corriendo:

```shell
$ sudo docker exec -it taller bash
```

### Gotcha

Al compartir una carpeta puede que tengas el ownership/permisos de los
files compartidos incorrectos.

El por que pasa y como solucionarlo esta en
[Fix Ownership of Files in a Mounted Volume](https://book-of-gehn.github.io/articles/2022/02/01/Fix-Ownership-of-Files-in-a-Mounted-Volume.html)
