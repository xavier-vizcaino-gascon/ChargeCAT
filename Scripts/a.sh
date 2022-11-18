#!/bin/bash

#Creem estructura de directoris per a guardar la informació generada de manera ordenada
! test -d dataset && mkdir dataset
! test -d resultats && mkdir resultats

#Adreça dataset
adreca=https://analisi.transparenciacatalunya.cat/api/views/tb2m-m33b/rows.csv

#Comprovem que en el directori dataset no hi hagi un arxiu rows.csv, si hi és, renombrem l'actual avanç de descarregar
test -f ./dataset/rows.csv && mv ./dataset/rows.csv ./dataset/old_rows.csv

#Descarreguem l'arxiu sense arguments en pantalla
wget $adreca -q
test -f ./rows.csv && mv ./rows.csv ./dataset/rows.csv

#Estudiem tipus d'arxiu
tipus=($(file -b ./dataset/rows.csv))
numcol=$(( ($(head -1 ./dataset/rows.csv | sed 's/[^,]//g' | wc -L)) + 1))
numreg=($(wc -l ./dataset/rows.csv))

#Imprimim per pantalla
printf "PRACTICA FINAL\nAlumne = Xavier Vizcaino\n\nSCRIPT A:\n\n*** DATASET ***\nURL = %s\nNOMBRE COLUMNES = %i\nNOMBRE REGISTRES = %i\n" $adreca $numcol $numreg
#Impripim a output_A
printf "URL;%s\nNOMBRE COLUMNES;%i\nNOMBRE REGISTRES;%i" $adreca $numcol $numreg > ./resultats/output_A.txt

while getopts "vfc:" option; do
	case $option in
		v)	#Per obtenir el format de l'arxiu dataset així com el tipus de dades de cada columna via RegEx; agafant com a referència la primera fila que no té cap camp buit
			printf "FORMAT = %s %s\nESPECIFICACIO COLUMNES:\n" ${tipus[@]}
			sed -e 's/,[[:space:]]/ num /g' ./dataset/rows.csv | grep -v ".,,\+" | head -2 | tail -1 > ./temp_dataset.csv
			for i in $(seq 1 $numcol); do		
				col=($(cut -d"," -f$i ./temp_dataset.csv))
				col="${col[@]}"
				printf "  Columna %i = " $i
				if [[ $col =~ [[:alpha:]] ]]; then
					printf "text\n"	
				elif [[ $col =~ ^[[:digit:]]+\.[[:digit:]]+$ ]]; then
					printf "decimal\n"
				elif [[ $col =~ [[:digit:]]+ ]]; then
					printf "enter\n"
				else
					printf "format desconegut\n"
				fi
			done
			test -f ./temp_dataset.csv && rm ./temp_dataset.csv;;
		f)	#Per obtenir el format de l'arxiu dataset així com el tipus de dades de cada columna via csvstat
			printf "FORMAT = %s %s\n" ${tipus[@]}
			printf "ESPECIFICACIO COLUMNES:\n"
			csvstat --type ./dataset/rows.csv;;			
		c)	#Per canviar el nom del dataset
			FN=${OPTARG}
			test -f ./dataset/rows.csv && mv ./dataset/rows.csv ./dataset/$FN
			echo "Canviem el nom del dataset a --> $FN"
			exit;;
		*)	#Informació adicional
			printf "Les opcions vàlides son: [-v] o [-f] o [-c]\n";;
	esac
done
printf "***************\n\n"
