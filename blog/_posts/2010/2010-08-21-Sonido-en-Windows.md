---
layout: post
title: Sonido en Windows
author: admin
date: 21/08/2010
tags: [C audio windows]
---

# Entrada / salida de sonido en Windows

* **Resumen**: El siguiente documento explica la forma de grabar y reproducir sonido en Windows

* **Versión**: 2.0

* **Sistema Operativo**: WINDOWS 9x, Me, NT, 2000, XP

* **Autor**: Gabriel Agustín Praino

* **Fecha**: 30/11/2001

* **Búsqueda**: audio - wave - sonido

El presente material se encuentra inscripto en el Registro Nacional de Propiedad Intelectual. Todos los derechos reservados. La reproducción de la presente publicación se encuentra sujeta a los términos establecidos en la página principal de la presente obra. Prohibida la reproducción total o parcial de esta publicación en forma independiente.

## Introducción

Representación digital de una señal de audio

Una señal de audio es captada por un micrófono como una señal eléctrica analógica. Se dice que una señal es analógica, cuando la misma está formada por valores continuos, tanto en el tiempo como en amplitud.

Si bien esta señal puede ser procesada en forma analógica por medios electrónicos, para su procesamiento en una computadora es necesario digitalizarla. Este proceso de digitalización se realiza con un dispositivo conocido como **conversor analógico digital** (o **ADC** por sus siglas en inglés), y se lleva a cabo en dos pasos: muestreo y discretización.

El primer paso se conoce con el nombre de muestreo, y consiste en tomar muestras de la señal en forma periódica.

![](/assets/2010/08/Image02.gif)

El segundo paso se conoce como discretización, y consiste en aproximar el valor continuo a una escala discreta.

![](/assets/2010/08/Image03.gif)

El resultado es una secuencia finita de valores enteros, que pueden ser procesados digitalmente:

![](/assets/2010/08/Image04.gif)

La precisión con la cual de lleve a cabo la digitalización determinará la calidad de la onda, y está gobernada principalmente por dos parámetros: **frecuencia de muestreo** y **precisión de discretización**.

La *frecuencia de muestreo* especifica la cantidad de muestras que se toman de la señal por unidad de tiempo. Los valores típicos para audio son:

* 11025 muestras por segundo (calidad telefónica)

* 22050 muestras por segundo (calidad radio)

* 44100 muestras por segundo (calidad CD)

La **precisión de discretización** determina la cantidad de valores utilizados al discretizar las muestras. Los valores típicos son:


* 256 (8 bits)

* 65536 (16 bits)

* Existen algunos sistemas que trabajan incluso con 32 bits, pero esto es muy poco frecuente.

A continuación se muestran los resultados de duplicar cada uno de estos parámetros en la figura de arriba:

![](/assets/2010/08/Image06.gif)

![](/assets/2010/08/Image07.gif)

### Nota

Surge una incongruencia al referirnos a los dispositivos de audio de PC. Al trabajar con 8 bits de precisión, se utilizan valores sin signo (0 – 255), con lo cual el valor de sonido nulo será 128, en tanto que al trabajar con 16 bits de precisión, se utilizan valores con signo (-32768 a 32767) y el valor de sonido nulo será 0. Esta incongruencia en el standard obliga a realizar molestas consideraciones al implementar software para ambos tipos de señales.

## Reproducción

La reproducción de la señal se realiza en forma inversa, utilizando un **conversor digital analógico** (o **DAC** por sus siglas en inglés).

## Procesamiento digital

El procesamiento digital de señales de audio presenta numerosas ventajas frente al analógico:

* Es posible cuantificar la distorsión que sufrirá la señal por los procesos de conversión A/D y D/A

* La señal digital no sufre distorsión

* Puede hardware genérico y de bajo costo para el procesamiento de la señal, el cual puede ser fácilmente modificado

* Permite un aprovechamiento de canales de transmisión en forma más eficiente

* Pueden utilizarse algoritmos de compresión de datos para optimizar canales de transmisión y almacenamiento

No es el objetivo de este curso analizar el procesamiento digital de señales, tema que requiere un análisis mucho más profundo. Tan sólo se mencionarán algunos efectos útiles:

### Filtro pasa altos

$s[n] = s[n] - s[n-1]$

### Filtro pasa bajos

$s[n] = (s[n+1] + s[n] + s[n-1]) / 3$

### Eco

$s[n] = s[n] + a * s[n-r]$

Donde:

* $s[n]$ es la n-esima muestra de la señal

* $a$ es un factor de atenuación (entre 0 y 1)

* $r$ es un retardo (mayor a 0)

El proceso completo se muestra en el siguiente diagrama:

![](/assets/2010/08/Image05.gif)

## El dispositivo de audio en Windows

Hasta ahora hemos visto como es el proceso de grabación y reproducción de audio. Ahora veamos cómo controlar el dispositivo de audio en Window, para poder realizar esto.

Windows cuenta con una librería especial `mmsystem.h`, con funciones especiales para grabar y reproducir audio. Todas estas funciones comienzan con los nombres `waveIn…` y `waveOut…`

Un sistema operativo Window puede contar con más de un dispositivo de audio. Es posible utilizar las funciones `waveInGetNumDevs()` y `waveOutGetNumDevs()` para conocer la cantidad de dispositivos de entrada y salida audio que hay instalados en el sistema.

#### Nota

En Windows 9x/Me, si nuestro programa se cierra sin cerrar el dispositivo de audio, Windows lo cerrará automáticamente. En NT no es así, y el dispositivo de audio no podrá ser utilizado nuevamente hasta que no se reinicie el sistema. Es por esto que es recomendable desarrollar programas de audio bajo Windows 9X/Me.

### Reproducción de audio
Para poder reproducir audio, es necesario realizar 3 pasos:

1. Abrir el dispositivo de audio

2. Prepara un buffer con la señal a reproducir

3. Iniciar la reproducción del audio

Una vez hecho esto, es necesario realizar dos pasos más para cerrar el dispositivo

1. Desinicializar el buffer de audio

2. Cerrar el dispositivo de audio

#### Apertura del dispositivo de audio

Antes de poder reproducir audio, es necesario abrir el dispositivo de salida de audio. Este dispositivo sólo puede estar abierto una vez, por lo tanto, mientras nuestro programa o cualquier otro tenga abierto el dispositivo, ningún otro programa podrá utilizarlo.

La función para abrir el dispositivo de audio es:

MMRESULT waveOutOpen(
   LPHWAVEOUT phwo,
   UINT_PTR uDeviceID,
   LPWAVEFORMATEX pwfx,
   DWORD_PTR dwCallback,
   DWORD_PTR dwCallbackInstance,
   DWORD fdwOpen);

El primer parámetro `phwo` es un puntero a una variable donde retornar el `handle` utilizado para controlar el dispositivo. El segundo parámetro es el identificador del dispositivo de audio a abrir. Puede utilizarse `WAVE_MAPPER`, para utilizar el dispositivo por defecto. El tercer parámetro es un puntero a una estructura con la descripción de los parámetros del conversor analógico digital. Por ejemplo:

```c
WAVEFORMATEX wf;
wf.cbSize = sizeof (wf); // Tamaño de la estructura.
wf.wFormatTag = WAVE_FORMAT_PCM; // Señal standard sin compresión
wf.nChannels = 2; // Cantidad de canales (Stereo)
wf.nSamplesPerSec = 22050; // Frecuencia de muestreo
wf.wBitsPerSample = 16; // Bits por muestra
wf.nBlockAlign = (wf.wBitsPerSample / 8) * wf.nChannels;
wf.nAvgBytesPerSec = wf.nBlockAlign * wf.nSamplesPerSec;
```

Los restantes 3 parámetros de la función `waveOutOpen()` permiten definir el método en que el sistema operativo debe notificar a la aplicación los eventos ocurridos, como finalización de la grabación. Entre estos métodos se encuentran:

* Envío de mensajes a una ventana

* Llamada a una función callback (la llamada a funciones del sistema operativo desde esta función está restringido)

* Disparo de un evento

#### Inicialización del buffer de audio

La función `waveOutPrepareHeader()` permite inicializar un buffer  para reproducir audio. A continuación se muestra un ejemplo:

```c
WAVEHDR Hdr;
memset (&Hdr, 0, sizeof (Hdr));
Hdr.lpData = (LPSTR)malloc (64000);
Hdr.dwBufferLength = 64000;
Hdr.dwLoops = 1;
waveOutPrepareHeader (hWaveOut, &Hdr, sizeof (Hdr));
```

#### Reproducir el buffer
Para reproducir el buffer de audio inicializado, basta con llamar a `waveOutWrite()` con el buffer recién preparado, tal como se muestra  a continuación:

```c
waveOutWrite (hWaveOut, &Hdr, sizeof (Hdr));
```

#### Desinicializar el buffer

Una vez reproducido el audio, debe liberarse el buffer:

```c
free (Hdr.lpData);
waveOutUnprepareHeader (hWaveOut, &Hdr, sizeof (Hdr));
```

#### Finalmente, se debe cerrar el dispositivo de audio

```c
waveOutClose (hWaveOut);
```

##### Nota

Es posible utilizar más de un buffer de audio, e incluso llamar a `waveOutWrite()` con un nuevo buffer de audio, antes de que se  complete la reproducción del anterior. En este caso, el segundo buffer de audio  permanecerá encolado, hasta que se termine de reproducir el anterior.

Esto es especialmente útil cuando se debe reproducir sonido en forma  continua, por un largo período de tiempo, o antes de que se posea la totalidad  del sonido a reproducir. Generalmente se trabaja con dos buffers de audio, lo  cual permite inicialiar y encolar uno mientras se reproduce el otro. El tamaño  de estos buffers se determina en base al retardo aceptable para reproducir el audio.

Por ejemplo, si trabajamos con una frecuencia de muestreo de 22050 muestras por segundo, 8 bits/muestra y 1 canal (mono), el audio ocupará 22050 bytes por segundo. Si además utilizásemos buffers de 44100 bytes, deberemos completar 2 segundos de audio antes de poder reproducir el buffer.

### Grabación de audio

El proceso de grabado de audio es similar al de reproducción, sólo que ahora se utilizan las funciones `waveIn…` en lugar de `waveOut…`

Al igual que al reproducir audio, es posible trabajar con un esquema de varios buffers (generalmente dos), para poder grabar audio en forma continua. El tamaño de estos buffers se determina en base al retardo aceptable al recibir el audio; Si no nos interesa analizar el audio mientras este se está grabando, podemos utilizar un buffer tan grande como queramos, pero si esto no es así, el tamaño del buffer deberá ser tal que se complete en el tiempo esperado.

Por ejemplo, si trabajamos con una frecuencia de muestreo de 22050 muestras por segundo, 8 bits/muestra y 1 canal (mono), el audio ocupará 22050 bytes por segundo, y podemos tolerar un retardo de 0,1 segundo, deberemos trabajar con buffers de 2205 bytes.

Cabe destacar que trabajar con buffers muy pequeños aumenta el uso de procesador requerido.
