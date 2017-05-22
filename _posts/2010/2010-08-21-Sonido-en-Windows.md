---
layout: post
title: Sonido en Windows
author: admin
date: 21/08/2010
snippets: none

---
<div class="entry-content">
						<table width="100%" border="1">
<tbody>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Tema</strong></td>
<td><strong>Entrada / salida de sonido en Windows</strong></td>
<td width="10%" bgcolor="#c0c0c0"><strong>Versión</strong></td>
<td width="10%">2.00</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Resumen</strong></td>
<td colspan="3">El siguiente documento explica la forma de grabar y        reproducir sonido en Windows</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Sistema Operativo</strong></td>
<td colspan="3">WINDOWS 9x, Me, NT, 2000, XP</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Autor</strong></td>
<td>Gabriel Agustín Praino</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Fecha</strong></td>
<td width="10%">30/11/2001</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Búsqueda</strong></td>
<td colspan="3">audio – wave – sonido</td>
</tr>
</tbody>
</table>
<table border="1" bgcolor="#ffff00">
<tbody>
<tr>
<td><span style="color: #000000;">El presente material se encuentra inscripto en el        Registro Nacional de Propiedad Intelectual. Todos los derechos reservados.        La reproducción de la presente publicación se encuentra sujeta a los        términos establecidos en la página principal de la presente obra.        Prohibida la reproducción total o parcial de esta publicación en forma        independiente.</span></td>
</tr>
</tbody>
</table>
<h1><strong>Entrada / salida de sonido en Windows</strong></h1>
<h2>Introducción</h2>
<h3>Representación digital de una señal de audio</h3>
<p>Una señal de audio es captada por un micrófono como una señal eléctrica  analógica. Se dice que una señal es analógica, cuando la misma está formada por  valores continuos, tanto en el tiempo como en amplitud.</p>
<p><a href="/assets/2010/08/Image01.gif"><img class="alignnone size-full wp-image-97" title="Image01" src="/assets/2010/08/Image01.gif" alt="" width="336" height="75"></a></p>
<p>Si bien esta señal puede ser procesada en forma analógica por medios  electrónicos, para su procesamiento en una computadora es necesario  digitalizarla. Este proceso de digitalización se realiza con un dispositivo  conocido como <strong><em>conversor analógico digital </em></strong>o (<em><strong>ADC </strong></em>por  sus siglas en inglés), y se lleva a cabo en dos pasos: muestreo y  discretización.</p>
<p>El primer paso se conoce con el nombre de muestreo, y consiste en tomar  muestras de la señal en forma periódica.</p>
<p><a href="/assets/2010/08/Image02.gif"><img class="alignnone size-full wp-image-98" title="Image02" src="/assets/2010/08/Image02.gif" alt="" width="324" height="84"></a></p>
<p>El segundo paso se conoce como discretización, y consiste en aproximar el  valor continuo a una escala discreta.</p>
<p><a href="/assets/2010/08/Image03.gif"><img class="alignnone size-full wp-image-99" title="Image03" src="/assets/2010/08/Image03.gif" alt="" width="324" height="90"></a>.</p>
<p>El resultado es una secuencia finita de valores enteros, que pueden ser  procesados digitalmente:</p>
<p><a href="/assets/2010/08/Image04.gif"><img class="alignnone size-full wp-image-100" title="Image04" src="/assets/2010/08/Image04.gif" alt="" width="355" height="116"></a></p>
<p>La precisión con la cual de lleve a cabo la digitalización determinará la  calidad de la onda, y está gobernada principalmente por dos parámetros:  <strong><em>frecuencia de muestreo</em></strong> y <strong><em>precisión de  discretización</em></strong>.</p>
<p>La <strong>f<em>recuencia de muestreo</em> </strong>especifica la cantidad de muestras  que se toman de la señal por unidad de tiempo. Los valores típicos para audio  son:</p>
<ul>
<li>11025 muestras por segundo (calidad telefónica)</li>
<li>22050 muestras por segundo (calidad radio)</li>
<li>44100 muestras por segundo (calidad CD)</li>
</ul>
<p>La <strong><em>precisión de discretización </em></strong>determina la cantidad de valores  utilizados al discretizar las muestras. Los valores típicos son:</p>
<ul>
<li>256 (8 bits)</li>
<li>65536 (16 bits)</li>
<li>Existen algunos sistemas que trabajan incluso con 32 bits, pero esto es    muy poco frecuente.</li>
</ul>
<p>A continuación se muestran los resultados de duplicar cada uno de estos  parámetros en la figura de arriba:</p>
<p><a href="/assets/2010/08/Image06.gif"><img class="alignnone size-full wp-image-102" title="Image06" src="/assets/2010/08/Image06.gif" alt="" width="487" height="115"></a></p>
<p><a href="/assets/2010/08/Image07.gif"><img class="alignnone size-full wp-image-103" title="Image07" src="/assets/2010/08/Image07.gif" alt="" width="489" height="116"></a></p>
<h4>Nota</h4>
<p>Surge una incongruencia al referirnos a los dispositivos de audio de PC. Al  trabajar con 8 bits de precisión, se utilizan valores sin signo (0 – 255), con  lo cual el valor de sonido nulo será 128, en tanto que al trabajar con 16 bits  de precisión, se utilizan valores con signo (-32768 a 32767) y el valor de  sonido nulo será 0. Esta incongruencia en el standard obliga a realizar molestas  consideraciones al implementar software para ambos tipos de señales.</p>
<h3>Reproducción</h3>
<p>La reproducción de la señal se realiza en forma inversa, utilizando un  <strong><em>conversor digital analógico</em></strong> (o <strong><em>DAC </em></strong>por sus siglas en  inglés).</p>
<h3>Procesamiento digital</h3>
<p>El procesamiento digital de señales de audio presenta numerosas ventajas  frente al analógico:</p>
<ul>
<li>Es posible cuantificar la distorsión que sufrirá la señal por los procesos    de conversión A/D y D/A</li>
<li>La señal digital no sufre distorsión</li>
<li>Puede hardware genérico y de bajo costo para el procesamiento de la señal,    el cual puede ser fácilmente modificado</li>
<li>Permite un aprovechamiento de canales de transmisión en forma más    eficiente</li>
<li>Pueden utilizarse algoritmos de compresión de datos para optimizar canales    de transmisión y almacenamiento</li>
</ul>
<p>No es el objetivo de este curso analizar el procesamiento digital de señales,  tema que requiere un análisis mucho más profundo. Tan sólo se mencionarán  algunos efectos útiles:</p>
<h4>Filtro pasa altos</h4>
<p>s[n] = s[n] – s[n-1]</p>
<h4>Filtro pasa bajos</h4>
<p>s[n] = (s[n] + s[n-1] + s[n-2]) / 3</p>
<h4>Eco</h4>
<p>s[n] = s[n] + a * s[n-r]</p>
<p>donde:</p>
<ul>
<li><strong>s[n]</strong> es la n-esima muestra de la señal</li>
<li><strong>a</strong> es un factor de atenuación (entre 0 y 1)</li>
<li><strong>r</strong> es un retardo (mayor a 0)</li>
</ul>
<p>El proceso completo se muestra en el siguiente diagrama:</p>
<p><a href="/assets/2010/08/Image05.gif"><img class="alignnone size-full wp-image-101" title="Image05" src="/assets/2010/08/Image05.gif" alt="" width="513" height="86"></a></p>
<h2>El dispositivo de audio en Windows</h2>
<p>Hasta ahora hemos visto como es el proceso de grabación y reproducción de  audio. Ahora veamos cómo controlar el dispositivo de audio en Window, para poder  realizar esto.</p>
<p>Windows cuenta con una librería especial <strong><em>mmsystem.h</em></strong>, con  funciones especiales para grabar y reproducir audio. Todas estas funciones  comienzan con los nombres <strong><em>waveIn…</em></strong> y <strong><em>waveOut…</em></strong></p>
<p>Un sistema operativo Window puede contar con más de un dispositivo de audio.  Es posible utilizar las funciones <strong><em>waveInGetNumDevs() </em></strong>y  <em><strong>waveOutGetNumDevs() </strong></em>para conocer la cantidad de dispositivos de  entrada y salida audio que hay instalados en el sistema.</p>
<h4>Nota</h4>
<p>En Windows 9x/Me, si nuestro programa se cierra sin cerrar el dispositivo de  audio, Windows lo cerrará automáticamente. En NT no es así, y el dispositivo de  audio no podrá ser utilizado nuevamente hasta que no se reinicie el sistema. Es  por esto que es recomendable desarrollar programas de audio bajo Windows  9X/Me.</p>
<h3>Reproducción de audio</h3>
<p>Para poder reproducir audio, es necesario realizar 3 pasos:</p>
<ol>
<li>Abrir el dispositivo de audio</li>
<li>Prepara un buffer con la señal a reproducir</li>
<li>Iniciar la reproducción del audio</li>
</ol>
<p>Una vez hecho esto, es necesario realizar dos pasos más para cerrar el  dispositivo</p>
<ol>
<li>Desinicializar el buffer de audio</li>
<li>Cerrar el dispositivo de audio</li>
</ol>
<h4>1) Apertura del dispositivo de audio</h4>
<p>Antes de poder reproducir audio, es necesario abrir el dispositivo de salida  de audio. Este dispositivo sólo puede estar abierto una vez, por lo tanto,  mientras nuestro programa o cualquier otro tenga abierto el dispositivo, ningún  otro programa podrá utilizarlo.</p>
<p>La función para abrir el dispositivo de audio es:</p>
<pre>MMRESULT waveOutOpen(
   LPHWAVEOUT phwo,
   UINT_PTR uDeviceID,
   LPWAVEFORMATEX pwfx,
   DWORD_PTR dwCallback,
   DWORD_PTR dwCallbackInstance,
   DWORD fdwOpen);
</pre>
<p>El primer parámetro <strong><em>phwo</em></strong> es un puntero a una variable donde  retornar el&nbsp; <em><strong>handle </strong></em>utilizado para controlar el dispositivo.  El segundo parámetro es el identificador del dispositivo de audio a abrir. Puede  utilizarse <em><strong>WAVE_MAPPER</strong></em>, para utilizar el dispositivo por defecto.  El tercer parámetro es un puntero a una estructura con la descripción de los  parámetros del conversor analógico digital. Por ejemplo:</p>
<pre>WAVEFORMATEX wf;
wf.cbSize = sizeof (wf); // Tamaño de la estructura.
wf.wFormatTag = WAVE_FORMAT_PCM; // Señal standard sin compresión
wf.nChannels = 2; // Cantidad de canales (Stereo)
wf.nSamplesPerSec = 22050; // Frecuencia de muestreo
wf.wBitsPerSample = 16; // Bits por muestra
wf.nBlockAlign = (wf.wBitsPerSample / 8) * wf.nChannels;
wf.nAvgBytesPerSec = wf.nBlockAlign * wf.nSamplesPerSec;</pre>
<p>Los restantes 3 parámetros de la función <strong><em>waveOutOpen()</em></strong> permiten  definir el método en que el sistema operativo debe notificar a la aplicación los  eventos ocurridos, como finalización de la grabación. Entre estos métodos se  encuentran:</p>
<ul>
<li>Envío de mensajes a una ventana</li>
<li>Llamada a una función callback (la llamada a funciones del sistema    operativo desde esta función está restringido)</li>
<li>Disparo de un evento</li>
</ul>
<h4>2) Inicialización del buffer de audio</h4>
<p>La función <strong><em>waveOutPrepareHeader()</em></strong> permite inicializar un buffer  para reproducir audio. A continuación se muestra un ejemplo:</p>
<pre>WAVEHDR Hdr;
memset (&amp;Hdr, 0, sizeof (Hdr));
Hdr.lpData = (LPSTR)malloc (64000);
Hdr.dwBufferLength = 64000;
Hdr.dwLoops = 1;
waveOutPrepareHeader (hWaveOut, &amp;Hdr, sizeof (Hdr));</pre>
<h4>3) Reproducir el buffer</h4>
<p>Para reproducir el buffer de audio inicializado, basta con llamar a  <strong><em>waveOutWrite()</em></strong> con el buffer recién preparado, tal como se muestra  a continuación:</p>
<pre>waveOutWrite (hWaveOut, &amp;Hdr, sizeof (Hdr));</pre>
<h4>4) Desinicializar el buffer</h4>
<p>Una vez reproducido el audio, debe liberarse el buffer:</p>
<pre>free (Hdr.lpData);
waveOutUnprepareHeader (hWaveOut, &amp;Hdr, sizeof (Hdr));</pre>
<h4>5) Finalmente, se debe cerrar el dispositivo de audio</h4>
<pre>waveOutClose (hWaveOut);</pre>
<h3>Nota</h3>
<p>Es posible utilizar más de un buffer de audio, e incluso llamar a  <strong><em>waveOutWrite()</em></strong> con un nuevo buffer de audio, antes de que se  complete la reproducción del anterior. En este caso, el segundo buffer de audio  permanecerá encolado, hasta que se termine de reproducir el anterior.</p>
<p>Esto es especialmente útil cuando se debe reproducir sonido en forma  continua, por un largo período de tiempo, o antes de que se posea la totalidad  del sonido a reproducir. Generalmente se trabaja con dos buffers de audio, lo  cual permite inicialiar y encolar uno mientras se reproduce el otro. El tamaño  de estos buffers se determina en base al retardo aceptable para reproducir el  audio.</p>
<p>Por ejemplo, si trabajamos con una frecuencia de muestreo de 22050 muestras  por segundo, 8 bits/muestra y 1 canal (mono), el audio ocupará 22050 bytes por  segundo. Si además utilizásemos buffers de 44100 bytes, deberemos completar 2  segundos de audio antes de poder reproducir el buffer.</p>
<h3>Grabación de audio</h3>
<p>El proceso de grabado de audio es similar al de reproducción, sólo que ahora  se utilizan las funciones <strong><em>waveIn…</em></strong> en lugar de  <strong><em>waveOut…</em></strong></p>
<p>Al igual que al reproducir audio, es posible trabajar con un esquema de  varios buffers (generalmente dos), para poder grabar audio en forma continua. El  tamaño de estos buffers se determina en base al retardo aceptable al recibir el  audio; Si no nos interesa analizar el audio mientras este se está grabando,  podemos utilizar un buffer tan grande como queramos, pero si esto no es así, el  tamaño del buffer deberá ser tal que se complete en el tiempo esperado.</p>
<p>Por ejemplo, si trabajamos con una frecuencia de muestreo de 22050 muestras  por segundo, 8 bits/muestra y 1 canal (mono), el audio ocupará 22050 bytes por  segundo, y podemos tolerar un retardo de 0,1 segundo, deberemos trabajar con  buffers de 2205 bytes.</p>
<p>Cabe destacar que trabajar con buffers muy pequeños aumenta el uso de  procesador requerido.</p>
											</div>
