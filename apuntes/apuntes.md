# EC

## Profesor

Joan Manuel Parcerisa - Despacho C6-116 - imanel@ac.upc.edu

## Evaluación

- 0-20% Parcial
- 60-80% Final
- 17% Examen lab
- 3% Evaluación lab


## Instrucciones y tipos de datos básicos

### RISC vs. CISC

RISC: Operaciones de tamaño fijas y simples
CISC: Operaciones de tamaño variable y complejas

### Procesador MIPS (ISA MIPS32)

- 32 registros de 32 bits
- Palabras de 32 bits
- Instrucciones y direcciones de 32 bits
- Memoria de 2³² bytes accesibles

Para almacenar números de más de un byte en memoria se da por asumido en EC que
se está usando little-endian

#### Declaración de variables

En ensamblador MIPS no hay declaración de variables, se usan etiquetas que
llevan a espacios de memoria.

Las variables declaradas fuera de una función son "globals", las declaradas
dentro son "locals".

Las declaraciones de espacio

| nombre | tamaño | dirección \
| .byte  | 1      | - \
| .half  | 2      | múltiple de 2 \
| .word  | 4      | múltiple de 4 \
| .dword | 8      | múltiple de 8 

La alineación de espacios de memorias se hace de forma automática excepto con
.space (la utilizada para declarar vectores y otros usos grandes). Para evitar
este problema se usa .align seguido de 1, 2 o 3, colocando el inicio de la
siguiente escritura alineado en un espacio de 2^n siendo n el número después
del .align.

```mips

```


## Operadores

### Modo de registro:

El operando se encuentra en un registro y está colocado de forma que el primer
registro es el destino y los otros dos los operadores:

```mips

addu rs, ra, rb       # rs <- ra + rb
```

### Modo inmediato:

El operando se encuentra en el código de la instrucción y al ejecutarse pasa el
número de 16 bits a 32 por extensión de signo si es un entero en Ca2 o por
extensión de zeros si está sin signo.

```mips
addiu rt, rs, inm16   # rt <- rs + SignExt(inm16)
ori rt, rs, inm16     # rs <- rs OR SignExt(inm16)
lui rt, inm16 	      # rt_(31..16) <- Inm16
		      # rt_(15..0) <- 0x0000
```


Ejercicio:

Traducción del codigo en C

```C
int f, g, h, i;

f = (g + h) - (i - 100);
```

```f = $t3, g = $t0, h = $t1, i = $t2```

```mips
addu $t4, $t0, $t1
addiu $t5, $t2, 100
subu $t3, $t4, $t5
```

### Modo de memoria

Solo se admite en instrucciones de tipo load y store

```mips
lw rt, off16(rs)     # rt <- Mem_word[rs + SignExt(off16)]
sw rt, off16(rs)     # Mem_word[rs + SignExt(off16)] <- rt
```

### Elementos de memoria de 2 bytes usando operadores halfword

```mips
lh rt, off16(rs)     # rt <- SignExt(Mem_half[rs, SignExt(off16)])
sh rt, off16(rs)     # Mem_half[rs + SignExt(off16)] <- rt_15..0
```














