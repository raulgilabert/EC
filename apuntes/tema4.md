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

Las matrices se almacenan en memoria por filas una detrás de otra y se declaran
de la siguiente manera en C:

```C
int mat[NF][NC];
int mit[2][3] = {{-1, 2, 0}, {1, -12, 4}};
```

Y su traducción a MIPS es la siguiente:

```MIPS
        .data
...
        .align 2
mat:    .space NF*NC*4
mit:    .word -1, 2- 0, 1, -12, 4 # Opción menos visual
---
mit:    .word -1, 2, 0
        .word 1, -12, 4           # Opción mucho más visual
```

## Acceso aleatorio a un elemento

Para acceder a un elemento de fila `i` y columna `j` hay que calcular su
posición de memoria de la siguiente manera: `@mat[i][j] = mat + (i*NC + j)*T`
Siendo `T` el tamaño del tipo de dato y `NC` el número de columnas.

Por tanto un acceso a la posición `k = @mat[i][j]` en MIPS sería de la
siguiente manera: (`i=$t0, j=$t1, k=$t2`)

```MIPS
la $t3, mat
li $t4, MC
mult $t4, $t0
mflo $t4
# Calculado i*NC
addu $t4, $t4, $t1 # + j
sll $t4, $t4, 2    # *4 porque es unna matriz de words
addu $t4, $t3, $t4 # Se suma todo lo anterior a la dirección de mat
lw $t2, 0($t4)     # Se guarda el elemento en @mat[i][j] en la variable k
```

Esta clase de operaciones se simplifica mucho más si alguno de los índices de
la matriz es una constante y no una variable.

## Optimizaciones

### Acceso secuencial

Esta optimización sirve para el recorrido de elementos de un vector o una
matriz en la que los elementos se encuentran en una distancia constante llamada
**stride**. Teniendo esto se puede eliminar el cálculo usando `i`, la
multiplicación de esta por una constante y la suma a la dirección de la base
del vector/matriz y únicamente ir sumando a la dirección anterior el *stride*.

### Eliminar la variable de iteración

El bucle puede ser controlado usando el puntero necesario para el acceso a los
datos y comprobando que sea menor a la dirección de memoria del final de la
estructura de datos.

### Evaluar la condición en el final del bucle

Se cambia el `while` por un `do-while`. Para evitar que se tenga que ejecutar
siempre 1 iteración se ejecuta antes de entrar al bucle la condición en un if.
