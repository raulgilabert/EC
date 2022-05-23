# Memoria virtual

Sistema mixto hardware-software.

La compilación asigna unas direcciones que pueden ser iguales en diversos
programas en ejecución al mismo tiempo. De forma que se tienen que reubicar
todos los espacios de memoria, además de permitir la protección de los datos o
evitar problemas de falta de memoria.

Se crearon los overlays, diviendo el programa en módulos y cargando en memoria
únicamente aquellos necesarios en el momento.

la memoria virtual arregla los problemas de los overlays, con la traducción de
direcciones.

## Espacios de direccionamiento

### Direccionamiento lógico

Direcciones que asigna el compilador a cada programa y que la CPU envía a la
memoria en cada acceso, teniendo cada programa su propio espacio.

### Direccionamiento físico

Son las direcciones reales que recibe la memoria principal. Cada porción de
programa se ubica en posiciones libres de esta memoria, teniendo un hardware
MMU que se dedica a traducir las direcciones lógicas en direcciones físicas.6

