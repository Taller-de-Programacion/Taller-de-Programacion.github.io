---
layout: post
title: Catálogo de Librerías XML
author: Pablo Roca
date: 22/10/2010
snippets: none

---
<div class="entry-content">
						<p>Una característica importante a tomar en cuenta sobre la librería a utilizar es el formato de parser que utiliza. Las dos variantes para parseo de XML son:</p>
<ul>
<li>DOM: hidrata todo el XML en una estructura de objetos en memoria. Permite comprobar que el XML, en su totalidad, esté bien formado y sea válido contra un esquema particular. Suele requerir mucha memoria y tiempo de procesamiento por lo que se recomienda no utilizar para archivos grandes. Por otro lado es muy fácil de usar.</li>
<li>SAX: hidrata secciones del XML disparando eventos para cada sección encontrada; es responsabilidad del programador escuchar los eventos y actuar en consecuencia. Al no recorrer todo el XML realiza las validaciones sólo con las secciones parseadas y no con el archivo en su totalidad, a medida que parsea detecta nuevos errores y los informa. Es recomendado para archivos grandes pero implica mayor tiempo de programación ya que el recorrido del XML suele ser puramente secuencial.</li>
</ul>
<p>Como característica extra, es deseable que la librería haga uso del formato <a href="http://www.w3.org/TR/xpath/" target="_blank">XPath</a> para consulta y modificación de los valores del XML.</p>
<p>A título de resumen sobre las posibles librerías a utilizar en el desarrollo del TP final se incluye una lista de los nombres, descripción y enlaces para cada una:</p>
<p><strong>libxml++:</strong> es un wrapper <strong>libxml2 </strong>la conocida librería para C de Gnome. Tanto la versión C como la C++ son ámpliamente utilizadas y se las puede obtener como paquetes en la mayoría de las distribuciones Linux. Posee soporte XPath, DOM y SAX. <a href="http://libxmlplusplus.sourceforge.net/" target="_blank">Más información…</a></p>
<p><strong>tinyXML:</strong> pequeña librería con soporte DOM y SAX. Es una librería autocontenida por lo que se suelen incluir los archivos fuentes en el código del sistema que la utiliza. Posee una buena documentación y es sencilla pero acotada en ciertos aspectos. <a href="http://www.grinninglizard.com/tinyxml/" target="_blank">Más información…</a></p>
<p><strong>tinyXPath:</strong> similar a <strong>tinyXML</strong> en cuanto a su simpleza. Posee solamente soporte para XPath. <a href="http://tinyxpath.sourceforge.net/" target="_blank">Más información…</a></p>
<p><strong>xerces:</strong> muy utilizada en sus formatos C++ y Java. Posee soporte XPath, DOM y SAX además de una gran cantidad de funcionalidades extra no siempre encontrados en otras librerías. Como contrapartida para su empleo suele requerir grandes instaladores. <a href="http://xerces.apache.org/xerces-c/" target="_blank">Más información…</a></p>
											</div>
