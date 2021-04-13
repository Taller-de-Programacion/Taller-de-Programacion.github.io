---
layout: main-topic-page
title: Entorno de trabajo
sidebar-include: sidebar-guia-electronica.html
permalink: /entorno-de-trabajo
hide_post_meta: true
tags: [Trabajos Prácticos]
nav-trabajos-practicos: active

---

Aunque habitualmente hablamos del *entorno de desarrollo* como uno solo,
en realidad se tratan de varios *entornos*.

Uno entorno para el *desarrollo* en sí del software, otro para la
compilación o *building* y uno o varios entornos de *testing*.

Para Taller te alcanzará con solo los dos primeros (el entorno de
building lo usaras como el entorno de testing)

El entorno *desarrollo* es donde tenes todas las herramientas para
la programación. Léase editores de texto, IDEs, paginas de manual,
internet.

Es una elección personal. Podes usar Windows, Linux o MacOS. Podes usar
desde IDEs completos como Eclipse hasta editores de texto como Vim
(jugas en *God-mode* con Vim).

Sea cual sea, que tu **entorno de desarrollo sea comodo y te haga lo mas
productivo posible**.

El otro es el *entorno de compilación* o *building*: es donde el código
fuente es compilado al *artefacto* o producto final, típicamente una
lib o un programa.

En Taller usaremos Linux tanto para la compilación como para el testing.

Cualquier Linux moderno debería funcionar mientras provea un compilador
compatible con los estándares C11, C++11 y POSIX 2008.

El sistema de entregas
<a href="{{ site.sercom_url }}" target="_blank">Sercom</a> compila y
testea los trabajos en un Ubuntu Focal 20.04 de 64 bits.

Como compilador de C/C++ se usa el GCC 9.3.0; y para la verificación se
usa [cppcheck](http://cppcheck.sourceforge.net/) 1.90,
[cpplint](https://github.com/cpplint/cpplint) 1.4.5 (verificación estática),
[valgrind](https://valgrind.org/) 3.15.0 (verificación dinámica) y
[tiburoncin](https://github.com/eldipa/tiburoncin) 2.1.1 (verificación
de protocolo).

Tu entorno de building no necesariamente tiene que ser igual pero **se
recomienda tener uno lo mas similar al usado por el Sercom**.

Aunque posible, instalar las herramientas necesarias en tu computadora
no es lo ideal.

Podes no tener las mismas versiones de las tools o peor, podes estar
trabajando en 2 proyectos que requieran herramientas incompatibles entre
sí (digamos que estas haciendo Taller y otra materia).

Hay dos formas simples de tener *entornos aislados*.

## Máquina virtual

Una máquina virtual (VM) te permite tener una computadora dentro de otra,
totalmente aislada de la máquina real, *el host*.

Si el host es un hardware de 64 bits relativamente moderno, la VM
correrá casi con una performance casi nativa (como si fuera el host).

Hay varios virtualizadores para usar:
[VirtualBox](https://www.virtualbox.org/),
[QEMU](https://www.qemu.org/), [VMware](https://www.vmware.com) y si
estas usando Windows 10, podes usar [Hyper
V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

De los mencionados, VirtualBox y VMware son los mas fáciles de usar.

Si tenes Windows 10, puede que tengas que *deshabilitar* Hyper V para
poder usar otro virtualizador.

Una vez que tengas instalado el virtualizador que desees tendrás que
crearte una máquina virtual e instalarle un OS. Te recomendamos
instalarle el mismo OS que el Sercom: [Ubuntu Focal
20.04](https://releases.ubuntu.com/20.04/).

Instalar las herramientas de compilación es bastante simple.

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

Tu VM es un entorno de building, no necesariamente de desarrollo. Si
queres desarrollar en el host podes configurar tu VM para que cierta
carpeta estén *compartidas* entre la VM y el host.

Lo que se conoce como *shared folders*.

Así podes desarrollar en tu máquina local guardando los archivos en una
carpeta compartida y usar la VM para compilar y testear.

Si preferís, también podes usar tu VM como entorno de desarrollo y
codear ahí directamente.

## Containers

Si tu máquina local es un Linux relativamente moderno, podes hacer uso
de *containers*.

Un container es una asolación de tu Linux (una compartición). Es el
mismo OS (kernel) pero tiene su propias librerías y programas, su propia
interfaz de red, sus propios usuarios y procesos.

Al igual que una VM, un container pude *montar* una carpeta del host y
hacer que la carpeta este compartida.

Así podes desarrollar en el host y compilar y testear en el container.

Al igual que con las VMs, hay varios *orquestadores* de containers:
[LXC](https://linuxcontainers.org/) y [Docker](https://www.docker.com/)

Docker es el más usado y el que recomendamos en Taller.

A diferencia de una VM, un container es mucho mas ligero y consume mucha
menos memoria y CPU.

La contra es que es una tecnología para Linux. Si tenes un Windows,
Docker puede funcionar pero detrás de escena se levantara una VM con un
Linux.

Un container consta de una *imagen* pre armada con el OS, libs y
programas ya instalados y configurados.

Por suerte para vos, el Sercom usa Docker y podes usar la misma imagen
para compilar y testear.

Podes descargártela corriendo:

```shell
$ sudo docker pull eldipa/sercom-student-ubuntu
```

Para correr un container podes ejecutar:

```shll
$ sudo docker run --rm -it -w /mnt/ -v /home/user/wd:/mnt/ eldipa/sercom-student-ubuntu bash
```

Esta linea creará un container temporal (flag `--rm`), interactivo (`-it`) basado
en la imagen `eldipa/sercom-student-ubuntu` con la carpeta local
`/home/user/wd` montada en la carpeta `/mnt/` dentro del container que
pasa a ser el *current working* con `-w /mnt/`.

Obviamente deberás cambiar `/home/user/wd` por tu carpeta local.

El último parámetro es el comando a ejecutar en el container. En este
ejemplo `bash` pero podrías ejecutar `make` para compilar (asumiendo que
en `/home/user/wd` tengas el código y el Makefile.


