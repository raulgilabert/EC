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

| nombre | tamaño | dirección     |
|--------|--------|---------------|
| .byte  | 1      | -             |
| .half  | 2      | múltiple de 2 |
| .word  | 4      | múltiple de 4 |
| .dword | 8      | múltiple de 8 |

La alineación de espacios de memorias se hace de forma automática excepto con
.space (la utilizada para declarar vectores y otros usos grandes). Para evitar
este problema se usa `.align` seguido de 1, 2 o 3, colocando el inicio de la
siguiente escritura alineado en un espacio de 2^n siendo n el número después
del .align. Importante: `.align 0` no alinea sino que desactiva todos los
posteriores.

## Operadores

### Modo de registro

El operando se encuentra en un registro y está colocado de forma que el primer
registro es el destino y los otros dos los operadores:

```MIPS
add rs, ra, rb        # rs <- ra + rb
addu rs, ra, rb       # rs <- ra + rb (unsigned)
```

### Modo inmediato

El operando se encuentra en el código de la instrucción y al ejecutarse pasa el
número de 16 bits a 32 por extensión de signo si es un entero en Ca2 o por
extensión de zeros si está sin signo.

```MIPS
addiu rt, rs, inm16   # rt <- rs + SignExt(inm16)
ori rt, rs, inm16     # rs <- rs OR SignExt(inm16)
lui rt, inm16         # rt_(31..16) <- Inm16
                      # rt_(15..0) <- 0x0000
```

Ejercicio:

Traducción del codigo en C

```C
int f, g, h, i;

f = (g + h) - (i - 100);
```

```f = $s0, g = $s1, h = $s2, i = $s3```

```MIPS
add $t0, $s1, $s2
addi $t1, $s3, 100
sub $s0, $t0, $t1
```

### Modo de memoria

Solo se admite en instrucciones de tipo load y store

```MIPS
lw rt, off16(rs)     # rt <- Mem_word[rs + SignExt(off16)]
sw rt, off16(rs)     # Mem_word[rs + SignExt(off16)] <- rt
```

### Elementos de memoria de 2 bytes usando operadores halfword

```MIPS
lh rt, off16(rs)     # rt <- SignExt(Mem_half[rs, SignExt(off16)])
sh rt, off16(rs)     # Mem_half[rs + SignExt(off16)] <- rt_15..0
```

### Elementos de memoria de 1 byte usando operadores de byte

```MIPS
lb rt, off16(rs)     # rt <- SignExt(Mem_byte[rs, SignExt(off16)])
sb rt, off16(rs)     # Mem_byte[rs + SignExt(off16)] <- rt_7..0
```

### Elementos de memoria de 2 bytes o 1 byte sin signo

```MIPS
lhu rt, off16(rs)     # rt <- SignExt(Mem_half[rs, SignExt(off16)])
shu rt, off16(rs)     # Mem_half[rs + SignExt(off16)] <- rt_15..0
lbu rt, off16(rs)     # rt <- SignExt(Mem_byte[rs, SignExt(off16)])
sbu rt, off16(rs)     # Mem_byte[rs + SignExt(off16)] <- rt_7..0
```

La dirección efectiva de `lw, sw` debe de ser múltiplo de 4, la de
`lh, lhu, sh y shu` debe de ser múltiplo de 2. En caso de no serlo dará una
excepción.

### Pseudoinstrucciones o macros

Estas pseudoinstrucciones simplifican operaciones frecuentes y facilitan la
escritura y depuración del código.

Estas son `move, li y la`:

```mips
    .data
x:  .word 0
y:  .word 69, 70



move $t1, $t2      = addu $t1, $t2, $zero

li $t1, 100        = addiu $t1, $zero, 100

li $t1, 0x075080AA = lui $at, 0x0750   (load upper immediate)
                     ori $t1, $at, 0x80AA

la $t1, y          = lui $at, 0x1001
                     ori $t1, $at, 0x0004

la $t1, y+4        = lui $at, 0x1001
                     ori $t1, $at, 0x0008

```

`move` guarda el valor en el segundo registro también en el primero. `li` mete
el número en el registro que se le da. Esto permite guardar números de más de
16 bits ya que se puede traducir por más de una instrucción. `la` tiene la
misma utilidad que `li` pero que en lugar de tener el número directamente mete
una dirección de memoria de una etiqueta. Además que a esta etiqueta se le
añada un número permitiendo acceder a direcciones de memoria diferentes a la
que apunta la etiqueta.

## Sistemas de representación binaria

### Caracteres

Hay diferentes tipos de codificación que conectan los símbolos con números en
binario (Unicode, EBCDIC, ASCII, etc.).

#### Código ASCII de 7 bits (1963)

Los códigos del 0 al 31 son de control, lo que quiere decir que no son
imprimibles.

Los importantes para conocer de memoria son los siguientes:

```h
0x20 = ' '
0x30 = '0'
0x41 = 'A'
0x61 = 'a'

```

## Formatos de las instrucciones

Hay tres tipos de formatos distintos de instrucciones

- Registro:
    6 bits de opcode, 15 bits para registro (3 registros), 5 bits para shamt
    (shift amount) y 6 bits para funct (más bits de operación).

- Inmediato:
    6 bits de opcode, 10 bits para registro (2 registros) y 16 bits del número
    inmediato.

- Salto:
    6 bits de operación y 26 bits con la dirección de destino.

## Representación de vectores y punteros

Agrupación de n elementos del mismo tipo identificados por un índice que va de
0 a n - 1. Estos elementos están guardados en posiciones consecutivas de
memoria y en MIPS deben de respetas las reglas de alineación.

### Strings

Vectores con un número variable de caracteres. En Java o Pascal se usa una
tupla que contiene un entero y un vector de caracteres. En C, en cambio, es
únicamente un vector de caracteres con un caracter de control (`\0`) Por tanto
estos dos códigos en C y MIPS son equivalentes:

```C
char cadena[20] = "Una frase";
char cadena[20] = {'U', 'n', 'a', ' ', 'f', 'r', 'a', 's', 'e', '\0'};
```

```MIPS
	.data
cadena: .ascii "Una frase"      # Solo pone la frase sin el \0
        .space 11

cadena: .asciiz "Una frase"     # Pone la frase con el \0
        .space 10
```

## Punteros

Se utilizan para hacer referencia a datos en memoria. No tiene sentido hacer
operaciones aritméticas entre punteros. En caso de que el puntero `p` contenga
la dirección de la variable `v` se dice que `p` apunta a `v`.

En C los punteros tienen que ser declarados con el tipo de la variable a la que
se apunta.

```C
int *p1, *p2;
char *p3;

// De esta manera el primer ejemplo es posible pero el segundo no
p1 = p2;                        // Ta bien
p1 = p3;                        // Ta mal
```

Un puntero se inicializa asignándosele un puntero del mismo tipo o dándole la
dirección de una variable (operador `&` en C)

```C
char a = 'E';
char b = 'K';
char *pglob = &a;

void f() {
    pglob = &b;
}
```

En MIPS no hace falta ningún operador especial ya que en sí la etiqueta de la
variable contiene la dirección de memoria en la que se encuentra.

```MIPS
        .data:
a:      .byte: 'E'
b:      .byte: 'K'
pglob:  .word a

        .text:
f:
        la $t0, b             # Guarda la dirección de b en $t0
        la $t1, pglob         # Guarda la dirección de pglob en $t1
        sw $t0, 0($t1)        # Guarda en la dirección en $t1 (pglob) el
                              # contenido de $t0 (dirección de memoria de b)
```

Los punteros se utilizan principalmente para hacer una desreferencia
(indirección). Consiste en acceder a la memoria y guardar en una variable el
dato guardado en la dirección de memoria del puntero.

```C
char a = 'E';
char *pglob = &a;

void ff() {
    char tmp = *pglob;        // tmp = 'E'
}
```

Su equivalente en MIPS:

```MIPS
        .data:
a:      .byte: 'E'
b:      .byte: 'K'
pglob:  .word a

        .text:
f:
        la $t1, pglob
        lw $t5, 0($t1)
        lb $t0, 0($t5)
```

Con los punteros se puede hacer sumas o restas de enteros, moviéndose la
cantidad de bytes dependiendo del tipo de dato al que apunta el puntero.

Sabiendo esto, en C un vector es un puntero que apunta al primer elemento y que
no es modificable

 De esta manera las operaciones de vectores y de punteros son aplicables a
 cualquiera de los dos tipos:

```C
p = vec;
p[8] = 3;       // Se asigna un 3 a vec[8]
*vec = 5;       // Se asigna un 5 a vec[0]

// Son equivalentes:
*(p + i) = 0;
p[i] = 0;
```


