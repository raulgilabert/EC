# Tema 4 - Matrices

## Multiplicación de enteros en MIPS

La multiplicación de 2 enteros de n y m bits da un número de máximo n+m bits.

Esta instrucción se lleva acabo de la siguiente manera:

```MIPS
mult rs, rt             # Multiplica los dos registros y guarda el resultado en
                        # $hi y $lo

mflo rd                 # rd <- $hi
mfhi rd                 # rd <- lo
```

---

Una matriz es una agrupación multidimensional de elementos del mismo tipo.
Estos elementos se identifican por un índice por cada dimensión. El primer
elemento de cada una tiene índice 0.

Las matrices se almacenan en memoria por filas una detrás de otra.

## Acceso aleatorio a un elemento

Para acceder a un elemento de fila `i` y columna `j` hay que calcular su
posición de memoria de la siguiente manera: `@mat[i][j] = mat + (i*NC + j)*T`
Siendo `T` el tamaño del tipo de dato y `NC` el número de columnas.






