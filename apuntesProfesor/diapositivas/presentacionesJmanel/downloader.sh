#!/bin/bash

for i in {0..8}
do
    curl "https://personals.ac.upc.edu/jmanel/ec/Transpas-Tema$i-jmanel.pdf" > "Tema $i.pdf"
done
