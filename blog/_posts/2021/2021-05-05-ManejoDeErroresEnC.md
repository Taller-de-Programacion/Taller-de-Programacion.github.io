---
layout: post
title: EOF
author: Federico Manuel Gomez Peter
date: 05/05/2021
tags: [correccion, Files]
snippets: none

---

Observar el siguiente ejemplo y reflexionar: ¿qué problema tiene?

```c
int main(int argc, const char *argv[]) {
	socket_t skt;
	socket_init(&skt);
	socket_connect(&skt, argv[1], argv[2]);
	// do something
	socket_uninit(&skt);
}
```

Como futuros profesionales, debemos contemplar que nuestros programas no siempre van a ir
por el camino feliz de la ejecución. Algo puede _malir sal_ y tenemos la responsabilidad
de que nuestros programas sean lo suficientemente robustos ante fallas inesperadas. 
¿Qué pasa si el usuario, al ejecutar el programa, no le pasa ningún argumento? 
¿Qué pasaría si el sistema operativo no pudo darme un _file descriptor_?
¿Qué pasaría si no logro conectarme a un servidor, y después quiero hacer
un `socket_send`? Nuestros programas pueden fallar, y debemos chequear que esto no suceda, 
y si sucede, abortar la ejecución de forma ordenada, liberando **todos** los recursos solicitados.

```c
#define ARGV_HOSTNAME_INDEX 1
#define ARGV_SERVICE_INDEX 2
#define ARGV_FILEPATH_INDEX 3
#define ARGC_MANDATORY_QUANTITY 4

int main(int argc, const char *argv[]) {
	if (argc != ARGC_MANDATORY_QUANTITY) {
		fprintf(stderr, "Uso: %s <hostname> <servicio> <path al archivo>\n", argv[0]);
		return -1;
	}

	socket_t skt;
	FILE *file;
	if (socket_init(&skt) < 0) {
		// Como no alloqué nada antes de esta función, no hago nada
		// (Se asume que lo que alloque la función socket_init fue liberado si
		// tuvo alguna falla interna)
		return -1;
	}

	if ((file = fopen(argv[ARGV_FILEPATH_INDEX], "r")) == NULL) {
		socket_uninit(&skt);
		return -1;
	}

	if (socket_connect(&skt, argv[ARGV_HOSTNAME_INDEX], argv[ARGV_SERVICE_INDEX]) < 0) {
		fclose(file);
		socket_uninit(&skt);
		return -1;
	}

	// do something
	
	fclose(file);
	socket_uninit(&skt);
	return 0;
}
```


Cualquiera de estas funciones pueden fallar, y si lo hacen, nos imposibilitaría a continuar la ejecución.
Por esta razon, se chequean errores y se liberan los recursos de forma ordenada. La contra es que 
el código se hace mas ilegible. En clases posteriores vamos a ver cómo en C++ podemos tener la misma robustez
que este programa, conservando la legibilidad del primer programa. Mientras tanto, en C podemos hacer algunas
mejoras. La primera es utilizar funciones auxiliares, para ir manejando de a 1 los recursos allocados en
cada capa.

```c
#define ARGV_HOSTNAME_INDEX 1
#define ARGV_SERVICE_INDEX 2
#define ARGV_FILEPATH_INDEX 3
#define ARGC_MANDATORY_QUANTITY 4

static int _open_file_and_do_something(socket_t *skt, const char *filepath) {
	FILE *file;
	if ((file = fopen(filepath, "r")) == NULL) {
		return -1;
	}

	int ret = do_something(skt, file);
	fclose(file);
	return ret;
}

int main(int argc, const char *argv[]) {
	if (argc != ARGC_MANDATORY_QUANTITY) {
		fprintf(stderr, "Uso: %s <hostname> <servicio> <path al archivo>\n", argv[0]);
		return -1;
	}

	socket_t skt;

	if (socket_init(&skt) < 0) {
		// Como no alloqué nada antes de esta función, no hago nada
		// (Se asume que lo que alloque la función socket_init fue liberado si
		// tuvo alguna falla interna)
		return -1;
	}

	if (socket_connect(&skt, argv[ARGV_HOSTNAME_INDEX], argv[ARGV_SERVICE_INDEX]) < 0) {
		socket_uninit(&skt);
		return -1;
	}

	int ret = _open_file_and_do_something(&skt, argv[ARGV_FILEPATH_INDEX]);
	socket_uninit(&skt);
	return ret;
}
```

De esta forma manejaríamos de a 1 recurso por función. La desventaja es que estarías llamando a varias funciones
anidadas (se podría solucionar con funciones `inline`). Otra alternativa es el uso del infame `goto`


```c
#define ARGV_HOSTNAME_INDEX 1
#define ARGV_SERVICE_INDEX 2
#define ARGV_FILEPATH_INDEX 3
#define ARGC_MANDATORY_QUANTITY 4

int main(int argc, const char *argv[]) {
	if (argc != ARGC_MANDATORY_QUANTITY) {
		fprintf(stderr, "Uso: %s <hostname> <servicio> <path al archivo>\n", argv[0]);
		return -1;
	}

	socket_t skt;
	FILE *file;
	int ret = 0;
	if ((ret = socket_init(&skt)) < 0) {
		goto socket_init_failed;
	}

	if ((file = fopen(argv[ARGV_FILEPATH_INDEX], "r")) == NULL) {
		ret = -1;
		goto file_open_failed;
	}

	if ((ret = socket_connect(&skt, argv[ARGV_HOSTNAME_INDEX], argv[ARGV_SERVICE_INDEX])) < 0) {
		goto socket_connect_failed;
	}

	ret = do_something(&skt, file);

socket_connect_failed:
	fclose(file);
file_open_failed:
	socket_uninit(&skt);
socket_init_failed:
	return ret;
}
```

Notar como la liberación de recursos se apilan al final de la función y cada goto libera
**solo los recursos que fueron allocados hasta el momento de esa falla**. De esta forma se
logra un comportamiento similar a lo que sucede con los objetos en C++. Sin embargo,
el uso de `goto` en esta materia (y en esta facultad), está prohibido.
