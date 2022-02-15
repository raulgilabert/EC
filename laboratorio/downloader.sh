#!/bin/bash

for i in {0..5}
do
    mkdir "sesion $i"

    cd "sesion $i"

    wget --user privatEC --password Secure2010 https://docencia.ac.upc.edu/FIB/grau/EC/privat/Quadern-de-laboratori-sessio$i.pdf

    wget --user privatEC --password Secure2010 https://docencia.ac.upc.edu/FIB/grau/EC/privat/Plantilles-sessio$i.zip

    unzip Plantilles-sessio$i.zip -d plantillas

    cd ..
done
