# Centros de acopio más cercanos
Es un Shiny App que dado una dirección despliega en un mapa los centros de acopio más cercanos a ésta, además de la información completa de dichos centros. 


Se construyó a partir de una base de datos de los centros de acopio en Nayarit (refugios_nayarit.xlx) capturados a partir del Huracán Patricia, sin embargo puede extenderse a todo el país teniendo la información completa y las coordenadas geográficas de los refugios.


Se realizaron los siguientes pasos:


1. Limpiar base de datos (refugios_nayarit.xlx) 

2. Guardar base de datos con los datos limpios (refugios_nayarit_clean.csv) 

3. Correr Shinny App 



En el siguiente link puede acceder a la Shiny App: 

https://anavarrete.shinyapps.io/refugios_cercanos/


## Paquetes que requiere:

- require(shiny)

- require(geosphere)

- require(ggmap)

- require(XLConnect)

Esta app fue realizada en R version 3.3.1


