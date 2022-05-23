# Aritmética de enteros y coma flotante

## Overflow de sumas y restas de enteros

Como ya se ha visto antes, el rango de representación de entero en Ca2 con una
cantidad n de bits es R = [-2^(n-1), 2^(n-1)-1]. De esta manera, se produce
overflow cuando el número que se intenta representar no está en este rango de
operaciones, causando que al calcular el número salga otro diferente dentro del
rango.

En el caso de la suma se produce overflow cuando se suman números del mismo
signo y sale como resultado uno que no lo es. En la resta se produce cuando el
resultado es del mismo signo que el número "de abajo" pero distinto que el "de
arriba".

### Detección del overflow en Ca2

Debido a que pueden haber sumas de naturales y enteros, las sumas de enteros
deben de lanzar una excepción al encontrarse overflow pero las de naturales no.
Por esto es que existen instrucciones como `add` y `addu`, siendo la primera
para enteros y devolviendo una excepción en caso de overflow y la segunda
siendo para naturales y funcionando bien aunque haya overflow. Aun así, esto
depende del lenguaje que se esté utilizando: lenguajes como Fortran o Ada sí
que requieren estas excepciones al fallar por overflow, en cambio, lenguajes
como C estipulan que los overflows tienen que ser ignorados, de forma que en
estos casos solo se usan las instrucciones del tipo `addu`.

Al ser la suma de números en Ca2 compatible a nivel de hardware con la suma de
naturales, se permite usar el mismo hardware para esta función pero, al tener
que detectar el overflow en las operaciones de Ca2.

En caso de requerir saber si se ha producido overflow en la operación y usar un
lenguaje que no lanza errores por usar solo instrucciones tipo `addu` se puede
comprobar a partir de una sencilla secuencia de instrucciones:

Suponemos que los enteros `a`, `b` y `s` están guardados en `$t0`, `$t1` y
`$t2` respectivamente.

```MIPS
xor $t3, $t0, $t1    # a xor b
nor $t3, $t3, $zero
xor $t3, $t3, $t4    # a xor s
and $t3, $t3, $t4
srl $t3, $t3, 31     # traslada el bit 31 a la posición 0 ya que solo este es
                     # necesario
```

## Multiplicación entera de 32 bits con resultado de 64


