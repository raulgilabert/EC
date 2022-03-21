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

### Múltiplicación y división por potencias de 2

Estas operaciones al ser con potencias de 2 se lleva a cabo usando
desplazamientos.

---

Todos estos tipos de desplazamiento son escritos en C usando los operadores
`<<` y '>>'. Los desplazamientos a la derecha si se producen con un entero con
signo se usará el desplazamiento aritmético, en cambio si es un entero sin
signo (`unsigned`) se usará el lógico.

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

## Comparaciones y operaciones booleanas

### Comparaciones entre naturales y enteros

MIPS únicamente implementa la comparación < con las siguientes instrucciones:

| MIPS | Operación | Significado |
|-|-|-|
| `slt rd, rs, rt` | `rd = rs < rt` | `rs` < `rt` con enteros |
| `sltu rd, rs, rt` | `rd = rs < rt` | `rs` < `rt` con naturales |
| `slti rd, rs, imm16` | `rd = rs < SignExt(imm16)` | `rs` < un entero |
| `sltiu rd, rs, imm16` | `rd = rs < SignExt(imm16)` | `rs` < un natural |

Guardando en el registro 0 si es falso o 1 si es cierto.

Únicamente existen estas comparaciones, todas las demás se tienen que hacer a
partir de estas.

## Saltos

En caso de una condición cambia la ejecución a otra posición de memoria.

| MIPS | Traducción |
| - | - |
| `beq rs, rt, etiqueta` | `if (rs == rt), PC = PC_up + SignExt(imm16*4)` |
| `bne rs, rt, etiqueta` | `if (rs != rt), PC = PC_up + SignExt(imm16*4)` |
| `b etiqueta` | `beq $0, $0, etiqueta` |

### Macros de saltos

Estas macros hacen saltos usando comparaciones de enteros de menor o mayor en
lugar de usar la igualdad.

### Saltos absolutos

Permiten hacer saltos sin necesitar hacer ningún tipo de comparación.

| MIPS | significado |
| - | - |
| j num |

## Sentencias condicionales e iterativas

### `if-then else`

Primero evalua la condición del `if` de C. En caso de ser falsa salta a la
etiqueta dedicada al código del `else`. En caso de ser cierta al acabar de
ejecutar el bloque salta a después del bloque de `else`.

Código en C:

```C
if (a >= b)
    d = a;
else
    d = b;
```

Código en MIPS:

```MIPS
        blt $t0, $t1, sino
        move $t3, $t0
        b finsi
sino:
        move $t3, $t1
finsi:
```

#### Evaluación lazy de "&&" y "||"

A diferencia de usar los operadores `&` y `|` que ejecutan tanto la parte
izquierda como la parte derecha, usar  `&&` y `||` permite que, en caso de que
ejecutando solo la parte de la izquierda del operador ya se tiene el resultado
asegurado (falso si es `&&` o verdadero si es `||`) ya no se ejecuta.

Código en C de ejemplo:

```C
if (a >= b && a < c)
    d = a;
else
    d = b;
```

Código traducido en MIPS

```MIPS
        blt $t0, $t1, sino
        bge $t0, $t2, sino
        move $t3, $t0
        b finsi
sino:
        move $t3, $t1
finsi:
```

### `switch`

Se puede traducir como una cadena de `if-then-else`. En caso de tener muchos
casos se puede utilizar una tabla de saltos (vector de direcciones de memoria).

### `while`

Ejecuta cierto número de iteraciones mientras se cumpla una condición. Primero
evalua la condición. En caso de ser falsa salta a fuera del while. En caso
contrario continua y al final del bloque salta al inicio de la evaluación del
while.




### `for`

Es un equivalente a un while con una elecución previa y una a ejecutar al final
de la iteración.

  /* Pre: el parametre implicit no conte cap estudiant amb el DNI d'est;
### `do-while`

Es similar a un while pero se itera mínimo una vez.

## Subrutinas

Son piezas de código reutilizables que se pueden llamar desde diferentes
puntos. Es necesario seguir un protocolo para ver cómo se usan los registros,
se hacen las llamadas y las devoluciones de datos, el paso de parámetros y el
uso de la memoria.

Una subrutina se ejecuta de la siguiente manera:

1. Se ponen los parámetros en un lugar accesible para la subrutina.
2. Se transfiere el control a la subrutina.
3. Se reserva el espacio de memoria para las variables locales.
4. Se ejecuta la tarea de la subrutina.
5. Se pone el resultado de la subrutina en un lugar accesible para el programa
principal.
6. Se devuelve el control al programa principal.
7. Se lee el resultado de la subrutina.

### Paso de parámetros y resultados

Los parámetros se pasan en los registros desde `$a0` hasta `$a3` en este orden.
Los que son de coma flotante se pasan en `$f12` y `$f14`. En caso de necesitar
más parámetros estos se pasan por memoria. El resultado se pasa por el registro
`$v0` o en caso de ser de coma flotante se pasa por `$f0`.

Ejemplo en C:

```C
int suma2 (int a, int b) {
    return a + b
}

int main() {
    int x, y, z;
    // en $t0, $t1, $t2
    z = suma2(x, y);
}
```

Traducción en MIPS:

```MIPS
main:
        move $a0, $t0
        move $a1, $t1
        jal suma2
        move $t2, $v0

suma2:
        addu $v0, $a0, $a1
        jr $ra
```

En cambio, al pasar parámetros que sean vectores o matrices se pasa el puntero
a la dirección base del vector/matriz.




### Variables locales

Se crean cuando se invoca la función y solo existen mientras esta se ejecuta.
Tienen un valor indeterminado si no se inicializan explícitamente, solo son
visibles dentro de la función, algunas se guardan en registros y otras en
memoria, dentro de la pila del programa.

#### Pila del programa

Es una región de memoria que crece o mengua dinámicamente siguiendo una
estructura de pila. Crece desde direcciones altas hacia direcciones más bajas.
El registro `$sp` (stack pointer) siempre apunta a la cima de la pila.
Inicialmente este registro tiene el valor `$sp = 0x7FFFFFFC`. Este siempre ha
de ser múltiplo de 4.

Cada subrutina mantiene en la pila su bloque de activación, lugar donde guarda
variables locales y otros datos privados. Al inicio de esta reserva el bloque
de activación decrementando `$sp`. Al final libera el bloque incrementando
`$sp`.

#### Reglas para variables locales

- Variables estructuradas (vectores, matrices y structs) \
Se guarda en la pila.
- Variables escalares \
Se guardan en los registros `$t0-$t9`, `$s0-$s7` y `$v0-$v1`. En caso de no
haber suficientes registros también se guarda en la pila.

##### Reglas para el bloque de activación

- Las variables locales se guardan en el mismo orden en el que están declaradas
empezando desde la cima del bloque.
- Hay que respetar las normas de alineación.
- El tamaño y la dirección inicial del bloque deben ser múltiplos de 4.

#### Subrutinas multinivel

Son subrutinas que llaman a otras subrutinas.

Para restaurar los valores de los registros después de llamar a una subrutina
hay distintos métodos:

- Guardar en memoria los valores de los registros. Es muy poco eficiente.
- El ABI de MIPS da la solución de dividir los registros entre temporales
 (`$t, $v, $a, $f0-$f19`) y seguros (`$s, $sp, $ra y $f20-$f31`).

Este método se divide en dos pasos:
    1. Determinar qué registros seguros se usarán: \
        Identifica qué datos almacenados en registros se generarán antes de una
        llamada a una subrutina y se usarán después de esta.
    2. Salvar y restaurar los registros seguros
        - Al inicio de la subrutina salva el valor anterior de los registros
        seguros en el bloque de activación usando un método store.
        - Al final de la subrutina restaura los valores originales de los
        registros usando un método load.

## Estructura de la memoria en MIPS

- 0x00000000-0x00400000 reservado
- 0x00040000-0x10000000 .text
- 0x10000000-0x10010000 .sdata
- 0x10010000-0x80000000 .data, heap y pila
- 0x80000000-0xffffffff reservado para el sistema operativo

### Sección `.data`

Tiene un tamaño fijo para cada programa, sirve para guardar variables globales
en C y ocupa siempre el mismo espacio durante toda la ejecución del programa.


### Sección pila

Se usa para guardar variables locales, crece dinámicamente hacia direcciones
menores y reserva o liberal al inicio y final de las subrutinas.

### Sección `.heap`

Guarda variables que se crean y destruyen explícitamente, crece hacia
direcciones mayores. La reserva y liberación es tarea del SO usando las
funciones de C `malloc()` y `free()`.


