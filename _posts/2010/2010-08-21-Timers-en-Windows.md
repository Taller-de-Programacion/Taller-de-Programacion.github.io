---
layout: post
title: Timers en Windows
author: admin
date: 21/08/2010
tags: [C timer windows]
snippets: none

---
<div class="entry-content">
						<table border="1">
<tbody>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Tema</strong></td>
<td>Timer</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Versión</strong></td>
<td width="10%">1.00</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Resumen</strong></td>
<td colspan="3">El siguiente documento explica la forma de implementar       procesamientos dependientes del paso del tiempo. Se aborda la forma de la       creación de temporizadores, su uso y su liberación.</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Sistema Operativo</strong></td>
<td colspan="3">WINDOWS 9x, Me, NT, 2000, XP</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Autor</strong></td>
<td>Andrés A. Veiga</td>
<td width="10%" bgcolor="#c0c0c0"><strong>Fecha</strong></td>
<td width="10%">18/8/2001</td>
</tr>
<tr>
<td width="15%" bgcolor="#c0c0c0"><strong>Búsqueda</strong></td>
<td colspan="3">Timer – SetTimer – WM_TIMER – Perioricidad</td>
</tr>
</tbody>
</table>
<p>Existen dos formas de implementar temporizadores:</p>
<h2>1) Implementación mediante mensajes:</h2>
<p>El sistema operativo WINDOWS está orientado a eventos. Por tal motivo, la forma más directa para realizar procesamiento dependiente del paso del:</p>
<h3>Creación del temporizador:</h3>
<p>La misma se crea mediante el uso de la función <strong>SetTimer</strong>. La misma recibe 4 parámetros:</p>
<p>1. <strong>Hwnd</strong>: Es el Handle de la ventana que recibirá los mensajes de notificación.</p>
<p>2. <strong>IdTimer</strong>: Es un identificador de Timer. Este parámetro permite diferenciar la procedencia de los mensajes en el caso de ventanas que inician más de un temporizador. Debe ser un número &gt;0.</p>
<p>3. <strong>UTimeout</strong>: Es el período (en milisegundos) que deseamos que trancurra entre cada mensaje de notificación.</p>
<p>4. <strong>Tmprc</strong>: Debe ser NULL</p>
<h3>Notificación del paso del tiempo</h3>
<p>Cada <strong>Utimeout</strong> milisegundos WINDOWS despachará un mensaje <strong>WM_TIMER</strong> a nuestra aplicación. Dicho mensaje tendrá como wParam el <strong>IdTimer</strong> del timer de donde proviene la nitificación y como lParam tendrá NULL.</p>
<h3>Liberación del temporizador</h3>
<p>Esta operación es realizada mediante la función <strong>KillTimer</strong>, la cual recibe los siguientes parámetros:</p>
<p>1. <strong>Hwnd</strong>: Es el Handle de la ventana que recibirá los mensajes de notificación.</p>
<p>2. <strong>IdTimer</strong>: Es el identificador de Timer usado en su creación. Este parámetro permite especificar el timer a eliminar en el caso de ventanas que inician más de un temporizador.</p>
<h2>2) Implementación mediante funciones Callback:</h2>
<p>Hay oportunidades en que un timer no está asociado a ninguna ventana, motivo por el cual no se pueden procesar mensajes. En estos casos se puede optar por la siguiente implementación:</p>
<h3>Creación del temporizador:</h3>
<p>La misma se logra usando la función <strong>SetTimer</strong> con los siguientes parámetros:</p>
<p>1. <strong>Hwnd</strong>: Debe ser NULL.</p>
<p>2. <strong>IdTimer</strong>: Debe ser 0.</p>
<p>3. <strong>UTimeout</strong>: Es el período (en milisegundos) que deseamos que trancurra entre cada mensaje de notificación.</p>
<p>4. <strong>Tmprc</strong>: Debe ser el puntero a una función del tipo: VOID CALLBACK TimerProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime)</p>
<p>En esta modalidad es importante almacenar el valor devuelto por la función <strong>SetTimer</strong>.</p>
<h3>Notificación del paso del tiempo</h3>
<p>Cada <strong>Utimeout</strong> milisegundos WINDOWS invocará nuestra función para que podamos realizar el procesamiento necesario. La invocación se hace de la siguiente forma:</p>
<p>TimerProc(NULL, WM_TIMER, <strong>IdTimer</strong>, HoraEnFormatoUTC);</p>
<h3>Liberación del temporizador</h3>
<p>Esta operación es realizada mediante la función <strong>KillTimer</strong>, la cual recibe los siguientes parámetros:</p>
<p>3. <strong>Hwnd</strong>: Debe ser NULL.</p>
<p>4. <strong>IdTimer</strong>: Número devuelto por la la función <strong>SetTimer</strong>.</p>
											</div>
