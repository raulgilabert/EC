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

#### Escritura retrasada

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
- 
