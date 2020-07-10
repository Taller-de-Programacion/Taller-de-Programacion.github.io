---
layout: post
title: Catálogo de Librerías XML
author: Pablo Roca
date: 22/10/2010
---

Una característica importante a tomar en cuenta sobre la biblioteca a utilizar es el formato de parser que utiliza. Las dos variantes para parseo de XML son:

* **DOM**: hidrata todo el XML en una estructura de objetos en memoria. Permite comprobar que el XML, en su totalidad, esté bien formado y sea válido contra un esquema particular. Suele requerir mucha memoria y tiempo de procesamiento por lo que se recomienda no utilizar para archivos grandes. Por otro lado es muy fácil de usar.


* **SAX**: hidrata secciones del XML disparando eventos para cada sección encontrada; es responsabilidad del programador escuchar los eventos y actuar en consecuencia. Al no recorrer todo el XML realiza las validaciones sólo con las secciones parseadas y no con el archivo en su totalidad, a medida que parsea detecta nuevos errores y los informa. Es recomendado para archivos grandes pero implica mayor tiempo de programación ya que el recorrido del XML suele ser puramente secuencial.

Como característica extra, es deseable que la biblioteca haga uso del formato [XPath](http://www.w3.org/TR/xpath/) para consulta y modificación de los valores del XML.

A título de resumen sobre las posibles bibliotecas a utilizar en el desarrollo del TP final se incluye una lista de los nombres, descripción y enlaces para cada una:

* **libxml++**: es un wrapper de **libxml2** la conocida biblioteca para C de Gnome. Tanto la versión C como la C++ son ámpliamente utilizadas y se las puede obtener como paquetes en la mayoría de las distribuciones Linux. Posee soporte XPath, DOM y SAX. [Más información…](http://libxmlplusplus.sourceforge.net/)

* **tinyXML**: pequeña biblioteca con soporte DOM y SAX. Es una biblioteca autocontenida por lo que se suelen incluir los archivos fuentes en el código del sistema que la utiliza. Posee una buena documentación y es sencilla pero acotada en ciertos aspectos. [Más información…](http://www.grinninglizard.com/tinyxml/)

* **tinyXPath**: similar a *tinyXML* en cuanto a su simpleza. Posee solamente soporte para XPath. [Más información…](http://tinyxpath.sourceforge.net/)

* **xerces**: muy utilizada en sus formatos C++ y Java. Posee soporte XPath, DOM y SAX además de una gran cantidad de funcionalidades extra no siempre encontrados en otras bibliotecas. Como contrapartida para su empleo suele requerir grandes instaladores. [Más información…](http://xerces.apache.org/xerces-c/)
