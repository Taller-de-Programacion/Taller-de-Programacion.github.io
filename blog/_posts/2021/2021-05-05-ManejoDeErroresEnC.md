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
		fprintf(stderr, "Falló socket_init (%s)\n", strerror(errno));
		return -1;
	}

	if ( (file = fopen(argv[ARGV_FILEPATH_INDEX], "r")) == NULL) {
		fprintf(stderr, "No pude abrir el archivo (%s)\n", strerror(errno));
		socket_uninit(&skt);
		return -1;
	}

	if (socket_connect(&skt, argv[ARGV_HOSTNAME_INDEX], argv[ARGV_SERVICE_INDEX]) < 0) {
		fprintf(stderr, "No pude conectarme (%s)\n", strerror(errno));
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
que este programa, conservando la legibilidad del primer programa. Mientras tanto, en C nos tenemos que conformar
con esto (en C existen otros métodos para mejorar la legibilidad, pero requieren el uso del infame `goto` y 
en la facultad eso es palabra prohibida).