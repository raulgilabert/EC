# EC Tema 3: Traducción de programas

## Desplazamiento de bits

### Lógico

Shift Left Logical `sll` y Shift Right Logical `srl`. Ambos mueven los bits una
cantidad de posiciones asignada usando el espacio de `shamt` y llena con 0 las
posiciones disponibles.

```MIPS
li $t0, 0x88888888
sll $t1, $t0, 2           # $t1 = 0x22222220
srl $t1, $t0, 1           # $t1 = 0x44444444
```

### Aritmético

Shift Right Arithmetic `sra`. Mueve los bits una cantidad de posiciones
asignada usando el espacio de `shamt` y llena con el bit de signo las
posiciones disponibles.

```MIPS
li $t0, 0x88888888
sra $t1, $t0, 1           # $t1 = 0xC4444444
```

### Variable

Mueven el número dependiendo de lo que inidiquen los 5 bits de menor peso del
registro en la tercera posición.

```MIPS
sllv rd, rt, rs
srlv rd, rt, rs
```
---

Todos estos tipos de desplazamiento son escritos en C usando los operadores 
`<<` y '>>'. Los desplazamientos a la derecha si se producen con un entero con
signo se usará el desplazamiento aritmético, en cambio si es un entero sin
signo (`unsigned`) se usará el lógico.

### Múltiplicación y división por potencias de 2

Estas operaciones al ser con potencias de 2 se lleva a cabo usando
desplazamientos.

---

Los desplazamientos se suelen utilizar para calcular el offset de un vector al
ser estos siempre potencias de 2 (1, 2, 4 o 8).

Junto con los desplazamientos en MIPS se encuentra el operador `div` que se
utiliza para la división genérica. Siempre que se pueda utilizar un 
desplazamientos para dividir se debe hacer. Además de esto el operador `/` de C
y la instrucción `div` devuelven un residuo del mismo signo que el dividendo.


## Operación lógica bit a bit

Los inmediatos de las operaciones `andi, ori y xori` se extienden de 16 a 32
bits usando 0 siempre.

Equivalentes entre C y MIPS:

| MIPS | C |
|-|-|
| and | & |
| or | \| |
| xor | ^ |
| nor | ~ |
| andi | & |
| ori | \| |
| xori | ^ |

### Utilidad de `and` y `andi`

Se pueden usar para seleccionar bits determinador de un registro y poner los
demás en 0:

```MIPS
andi $t1, $t0, 0xFFFF      # Guarda en $t1 los 16 bits de mayor peso de $t0
```

Calcular el residuo de dividir por potencias de 2

```MIPS
andi $t1, $t0, 7           # $t1 = $t0 mod 8
```

### Utilidad de `or` y `ori`

Sirven para poner bits en 1

```MIPS
ori $t1, $t0, 0xFFFF       # Pone los 16 bits de mayor peso en 1
```

### Utilidad de `xor` y `xori`

Cambiar el valor de bits

```MIPS
li $t2, 0x55555555
xor $t1, $t0, $t2          # Cambiar los bits pares de $t0
```
