# Memoria cache

## Conceptos básicos

### Localidad de un programa

Para resolver el problema de la baja velocidad de lectura/escritrura con la
memoria respecto a la velocidad de procesamiento de las instrucciones Se
utiliza la cache. Con varias simulaciones de los accesos a memoria se pueden
ver que se cumplen dos importantes propiedades llamadas **"de localidad"**:

- Localidad temporal: Al acceder a una dirección de memoria es probable que se
  vuelva a acceder en un futuro cercano. Esta propiedad se debe a la existencia
  de bucles en los programas que hace que se acceda repetidamente a las mismas
  instrucciones y datos.

- Localidad espacial: Al acceder a una dirección de memoria es probable que se
  acceda a direcciones cercanas en un futuro próximo. Respecto a las
  instrucciones, debido al secuenciamento implícito, el procesador siempre va a
  la instrucción siguiente exceptuando saltos. Respecto a los datos, la
  localidad espacial se debe a los recorridos de vectores y matrices
  almacenados en posiciones contiguas de memoria.

La memoria cache es una memoria auxiliar pequeña y rápida que funciona como
intermediaria del procesador y la memoria principal y que es mucho más rápido
que esta pero más pequeña por problemas de coste.

De esta manera, la memoria cache e sun subconjunto del contenido de la memoria
principal cuyo objetivo es retener los datos que tengan más posibilidades de
ser accedidos en el futuro, aprovechando la localidad para acceder más
rápidamente y mejorar el rendimiento del programa.

De esta manera se explota los dos tipos de localidad:

- La localidad temoral se aprovecha cada vez que la CPU accede a un mismo dato
  de la memoria principal ya que se guarda simultaneamente una copia en la
  memoria cache, de forma que si más adelante se vuelve a requerirr en lugar de
  acceder a la memoria principal se accede al dato guardado en la memoria
  cache, aumentando la velocidad de procesamiento del dato.

- La localidad espacial se aprovecha cada vez que la CPU accede a un nuevo dato
  de la memoria principal, ya que no solo se copoia el dato en sí, sino que
  copia todo el *bloque* al que pertenece. Si se accede posteriormente a un
  dato cercano al dato leído anteriormente (siempre que esté en el mismo
  bloque) se accederá a la memoria cache.

### Terminología

- *Acierto*, *fallada* y *reemplazamiento*: Cuando al CPU tiene que accedera un
  dato de la memoria, en primer lugar comprueba si este dato está en alguno de
  los bloques guardados en la cache. Si el dato no está diremos que se ha
  producido una *fallada*. En este caso, será necesario acceder a la memoria
  principal y copiar en la caché no solo el dato sino también el bloque de
  memoria al que pertenece. Como la cache tiene un tamaño limitado, en caso de
  estar esta llena, habrá que llevar a cabo un *reemplazamiento*. En caso
  contrario, es decir, que ya se encuentre el dato en la cache, se produce un
  *acierto* y el acceso se realiza de forma mucho más corta.

- *Tasa de acierto* y *tasa de fallada*: La *tasa de aciertos* es el cociente
  entre el número de aciertos de la cache y la cantidad total de referencias a
  memoria. La *tasa de fallada* es lo mismo pero con las falladas.

- *Tiempo de acceso*, *tiempo en caso de acierto* y *tiempo de penalización*:
  El *tiempo de acceso* es el tiempo que pasa entre que la CPU solicita
  acceder a un dato del subsistema de memoria y que se finaliza la
  transferencia. En caso de acierto, este tiempo es t_h (*tiempo de acierto*),
  que es una característica de la cache que es básicamente el tiempo que tarda
  en pasar un dato de la cache a la CPU. En caso de fallada, es t_h más un
  *tiempo de penalización* t_p que es tiempo que tarda en copiar el bloque de
  la memoria a la cache.

## Diseño básico de una cache

Como la cache no guarda datos sueltos sino *bloques* enteros de tamaño fijo
**TAMBLOQUE**, siendo este una potencia de 2. EL espacio de direccionamiento de
la memoria se subdivide en bloques de **TAMBLOQUE** bytes, de manera que la
dirección inicial de cada bloque es un múltiplo de este. Se les puede asignar
un identificador único a cada bloque con numerar cada uno desde 0.

Cuando la CPU solicite un dato se copiará en la memoria cache todo el bloque al
que este pertenezca, de forma que se puede deducir el bloque completo a partir
de la dirección de este dato dividiendo la dirección entre **TAMBLOQUE**,
siendo los bits descontados el *offset* de A en el bloque.

### Cache de correspondencia directa

Una cache de correspondencia directa es aquella en la que los bloques son
colocados en base a un criterio específico, de forma que el bloque 0 de la
memoria principal corresponde al 0 de la cache, el 1 al 1 y así hasta llegar a
n, siendo n la cantidad de bloques de la cache, de forma que este se dirije
también a 0.

#### Reemplazamientos

Cuando se tiene que copiar un bloque en una línea de la caché pero esta línea
ya contiene un bloque con etiqueta distinta se tiene que reemplazar el antiguo
por el nuevo.

### Componentes de una cache

#### Bit de validación

Bit inicializado a 0 que informa si un bloque ya está en la línea o no.

#### Etiqueta

Etiqueta del bloque guardado en esa línea de la cache.

#### Datos

Espacio de **TAMBLOQUE** en el que van los datos almacenados en lamemoria
principal.

## Gestión de escritura

En el momento de modificar un dato de la memoria se comprueba si este está en
la MC (acierto de MC) o no (fallada de MC). Cualquiera de estos casos se pueden
resolver mediantes técnicas que se encuentran en la *política de escritura*.

### Acierto de escritura

Cuando se produce un acierto en los datos y se modifica se dan dos casos:
modificar únicamente en cache o modificar tanto en cache como en memoria
principal.

#### Escritura inmediata

Si se produce un acierto en cache se escriben simultáneamente los datos tanto
en cache como en memoria principal, de forma que si se tiene que hacer un
reemplazo en la cache se puede hacer con la certeza de que el dato en la
memoria principal es igual.

#### Escritura retardada

Al producirse un acierto de cache se escribe el dato únicamente en cache. De
esta forma el programa se ejecuta más rápidamente pero se necesita usar un bit
extra **Dirty bit** que vale 1 en caso de que el bloque haya sido modificado o
0 si no. En caso de haber sido modificado al tener que hacer un reemplazo en
esa posición de cache se tendrá que escribir el dato en memoria.

### Fallada de escritura

Cuando se produce una fallada de lectura en cache siempre se tiene que copiar
el bloque en la cache. En el caso de escritura hay dos enfoques posibles

#### Escritura con asignación

Si se produce una fallada se copia el bloque en la cache y se modifica.

#### Escritura sin asignación

En este otro caso se escribe el dato en la memoria principal, dejando de lado
la cache.

---

Todos estos casos se pueden combinar, formando la política de escritura. Se
suele trabajar con dos combinaciones diferentes:

- Escritura inmediata sin asignación
- Escritura retardada con asignación

### Gestión de las escrituras y rendimiento

#### Escritura inmediata

Mantener la misma versión simplifica el trabajo pero trae problemas de
rendimiento al tener que esperar a que se escriba en la memoria principal cada
vez que se hace una escritura. Por eso se suele usar un buffer de escritura que
se dedica a guardar los datos que tienen que llevarse a la memoria principal.
De esta manera con escribir el dato en la cache y el buffer ya s epiede
continuar con la ejecución.

Esto permite, en caso de fallada, que no haga falta cargar el dato al haberse
escrito también en la memoria principal, de forma que al requerirse en lectura
se carga el dato de la memoria principal y no lo lee directamente de la cache.

#### Escritura retardada

Al mantener diferentes versiones entre memoria principal y memoria cache no
permite escribir sin tener que comprobar si hay acierto o no, ya que en este
caso es totalmente necesario que el bloque esté en cache antes de escribir.
Para resolver esto se suele usar un buffer también, en el que se escribe el
dato de manera provisional.

En caso de fallada de cache, al requerir un reemplazo de bloque y contener
datos modificados, se tendrá que copiar el bloque entero en la memoria
principal, por lo que se suele usar un buffer también para almacenar el bloque
pendiente de escribir en la memoria principaly permitir continuar la ejecución
mientras se acaba de escribir el dato.

## Diseño de la memoria para soportar caches

Ya que el *tiempo de penalización* depende en gran medida de varios factores
como el tiempo de lectura/escritura para un bloque de la memoria o el tiempo de
transferencia en el bus de datos.

Un sistema con cache tiene dos interconexiones principales:

- Procesador con cache
- Cache con memoria principal

Estas interconexiones se realizan a partir de buses de datos. Normalmente el
tamaño de estos buses concidirá con el que la memoria puede leer o escribir
cada vez.

## Medidas de rendimiento

### Modelo de tiempo

De cara a especificar una configuración estándar para los ejercicios de
rendimiento hay que describir un modelo de tiempo que permitirá determinar los
ciclos de reloj que tarda una referencia de memoria en cualquier situación.

A nivel general hay que considerar que el tiempo de acceso a un dato de la
memoria cache es el tiempo que tarda en determinar si es un acierto o una
fallada y dar el dato en caso de acierto (t_h) más el tiempo de penalización
para resolver la referencia en acceder al siguiente nivel de la jerarquía de
memoria.

Hay que tomar en cuenta que el acceso a las etiquetas para comprobar si la
referencia es un acierto y la entrega en caso de aciertose realizan
secuencialmente durante t_h. En la primera mitad se accede a las etiquetas y en
la seguna se hace la lectura/escritura en la cache.

Para aquellas configuraciones con escritura inmediata se considera la
existencia de un buffer de escritura con tamaño ilimitado donde de almacenan
las escrituras pendientes de llevar a la memoria principal. También se
considera que ninguna referencia a memoria entra en conflicto con aquellas
escrituras pendientes en el buffer. Hay que tomar en cuenta ue el contenido del
buffer se lleva en paralelo a la ejecución de las instrucciones que van
posteriormente en el acceso a memoria.

## Mejoras: asociatividad y multinivel

### Asociatividad total o por conjuntos

Los bloques de la memoria principal dentro de la cache s eubicaban mediante
correspondecia directa. Esta técnica ofrece un buen rendimiento pero no tiene
en cuenta el nivel de ocupación del resto de la cache,, de forma que se podría
tener la cache vacía excepto una línea que se va modificando continuamente.

#### Cache completamente asociativa

Consiste en ubicar los bloques de la memoria principal en cualquier bloque
libre de la memoria cache. Esto aprovecha el espacio reduciendo la tasa de
falladas pero hace que localizar un bloque sea mucho más costoso y lento. El
número de un bloque ya no dará información sobre la ubicación del bloque dentro
de la cache, cosa que provoca tener que mirar en todas las entradas una a una.

#### Cache asociativa por conjuntos

La cache asociativa por conjuntos tienen un núero determinado de entradas, como
las caches de correspondencia directa pero que en lugar de ser línea son
conjuntos. El número de bloque de la memoria principal determinará a qué
conjunto tiene que ir en la cache. Aun así en cada conjunto no tiene por qué ir
solo un bloque, sino que pueden caber varios. Cualquiera de los bloques que
permita el conjunto se le llamará vía. Dentro de un conjunto la ubicación de un
bloque no dependerá de la dirección, sino que se cogerá la primera vía que esté
libre. De esta manera se determina el conjunto de forma directa pero la vía de
forma asociativa.

---

#### Reemplazamiento LRU

Es un algoritmo que se basa en reemplazar el bloque más antiguo por el nuevo.

### Cache multinivel

Actualmente muchos procesadores incluyen un segundo nivel de cache. Dada una
referencia a memoria se intentará resolver en la cache de primer nivel. En caso
de fallada se hará en la de segundo nivel. En caso de volver a tener fallada se
irá ya a la memoria principal.

Esto tiene la ventaja de poder orientar cada cache a un objetivo distinto,
siendo la de primer nivel una con bajo nivel de asociatividad, pocas palabra y
poca capacidad, teniendo un enfoque en la velocidad de acceso. En cambio, la
cache de segundo nivel tiene alta asociatividad, bloques grandes y mucha
capacidad para disminuir la cantidad de accesos a la memoria principal.
