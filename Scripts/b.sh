#!/bin/bash

#Realitzem substitucions en camps buits:
# 1. linies que comencen amb camp buit substituïm "," per "no_data,"
# 2. patro de doble coma ",," que indica que hi ha un camp buit al mig, el substituim per ",no_data,"
# 3. com que el patro ",," podria estar concatenat amb una altra cometa ie ",,," el pas 2 substituiria la primera part del patró, fent que la 3a cometa es considerés fora; repetim comanda i patró

sed '{
/,/ s/,/no_data,/ 
s/,,/,no_data,/g
s/,,/,no_data,/g
}' ./dataset/rows.csv > temp_maindata1.csv

#Com que el delimitadors de camps es "," i també tenim "," en els string entre cometes del camp adreça, definim una rutina amb awk per a canviar el separador de camps a ";"

awk 'BEGIN {FPAT="(\"[^\"]+\")|([^,]+)"} {print $1 ";" $2 ";" $3 ";" $4 ";" $5 ";" $6 ";" $7 ";" $8 ";" $9 ";" $10 ";" $11 ";" $12 ";" $13 ";" $14 ";" $15 ";" $16 ";" $17}' ./temp_maindata1.csv > temp_maindata2.txt

#Endrecem les columnes per a tenir Ciutat;Provincia;Ciutat;altre_info...
cut -d";" -f2,3,4,8,9,10,15,16 temp_maindata2.txt > temp_maindata3.txt
cut -d";" -f14 temp_maindata2.txt > temp_maindata4.txt
cut -d";" -f12 temp_maindata2.txt > temp_maindata5.txt

#Subtituïm majúscules per minuscules per evitar poblacions duplicades per temes d'exriptura
sed -e 's/\(.*\)/\L\1/' temp_maindata4.txt > temp_maindata6.txt

#Eliminem accentuació per evitar poblacions duplicades per temes d'escriptura
sed -i 'y/àèòéíóúï/aeoeioui/' temp_maindata6.txt

paste -d";" temp_maindata6.txt temp_maindata5.txt temp_maindata3.txt > temp_maindata7.txt

#Substituim " " per "_" per facilitar la manipulació d'strings
sed 's/ /_/g' temp_maindata7.txt > ./dataset/maindata.txt

#Esborrem fitxers temporals generats
for i in temp_maindata{1..7}.*; do
	test -f "$i" && rm -r "$i"
done

#Comptem el nombre d'ubicacions en cada provincia que tinguin com a mínim 1 carregador RAPID (excloent els semiRAPIDS)
BCN_rapid="$(grep "Barcelona;.\+;RAPID" ./dataset/maindata.txt | wc -l)"
TGN_rapid="$(grep "Tarragona;.\+;RAPID" ./dataset/maindata.txt | wc -l)"
GI_rapid="$(grep "Girona;.\+;RAPID" ./dataset/maindata.txt | wc -l)"
LLE_rapid="$(grep "Lleida;.\+;RAPID" ./dataset/maindata.txt | wc -l)"

#Imprimim a pantalla
printf "\nSCRIPT B:\n\n*** RESUM CARREGADORS RAPIDS ***\nBarcelona = \t%i localitzacions\nTarragona = \t%i localitzacions\nGirona = \t%i localitzacions\nLleida = \t%i localitzacions\n********************************\n\n" $BCN_rapid $TGN_rapid $GI_rapid $LLE_rapid

#Imprimim a output_B
printf "PROVINCIA;CARREGADORS_RAPIDS\nBarcelona;%i\nTarragona;%i\nGirona;%i\nLleida;%i" $BCN_rapid $TGN_rapid $GI_rapid $LLE_rapid > ./resultats/output_B.txt
