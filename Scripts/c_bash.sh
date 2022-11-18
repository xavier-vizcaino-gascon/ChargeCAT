#!/bin/bash

#Comprovem que en el directori actual no hi hagi un arxiu temp.txt, si hi és l'esborrem
test -f ./temp_1.txt && rm ./temp_1.txt

#Busquem les linies en que tenim operació suma en el camp places i realitzem la suma
while IFS= read -r linia; do
	camp="$(cut -d";" -f9 <<< "$linia")"
	if [[ $camp =~ [0-9]+\+[0-9]+ ]];then
		case ${#camp} in
		3)
			suma="$( awk -F'+' '{suma=$1+$2;print suma}' <<< $camp )"
			printf "%i\n" $suma >> temp_1.txt;;
		5)
			suma="$( awk -F'+' '{suma=$1+$2+$3;print suma}' <<< $camp )"
			printf "%i\n" $suma >> temp_1.txt;;
		esac
	else
			printf "%s\n" $camp >> temp_1.txt		
	fi
done < $1

#Substituim el camp #9 = places, pel camp places amb la suma realitzada en el loop anterior a través d'una estructura de cut i paste
cut -d";" -f1,2,3,4,5,6,7,8 $1 > temp_2.txt
cut -d";" -f10 $1 > temp_3.txt
paste -d";" temp_2.txt temp_1.txt temp_3.txt > ./dataset/maindata_2.txt

# Filtrem l'arxiu maindata_2.txt, per quedarnos només amb aquelles linies que tenen un numero de places definides, es a dir que el camp #9 es un número i per tant no es una lletra, deixant fora els camps amb "no_data"
grep -E ".+;.*[^(oòó)].*;.+;.+;.+;.+;.+;.+;[^[:alpha:]]" ./dataset/maindata_2.txt > temp_4.txt

# Extreiem el llistat de municipis que tenen numero de places definides (integer)
cut -d";" -f1 temp_4.txt | sort -d | uniq > ./resultats/municipis.txt


printf "\nSCRIPT C_bash:\n\n"
printf "********* RESUM PLACES DE CARREGA *********\n"
printf "MUNICIPI;PLACES\n" > ./resultats/output_C1.txt
while IFS= read -r poble;do
	grep "^$poble" temp_4.txt > temp_5.txt
	sumatori=0
	while IFS= read -r linia; do
		municipi="$(cut -d";" -f1 <<< "$linia")"
		places="$(cut -d";" -f9 <<< "$linia")"	
		if [[ $poble == $municipi && $places != "no_data" ]]; then
			((sumatori+=$places))
			
		fi
	done < temp_5.txt
	if [[ ${#poble} -lt 8 ]]; then
		printf "%s\t\t\t\t\t%i\n" $poble $sumatori
	elif [[ ${#poble} -ge 8  && ${#poble} -lt 16 ]]; then
		printf "%s\t\t\t\t%i\n" $poble $sumatori		
	elif [[ ${#poble} -ge 16  && ${#poble} -lt 24 ]]; then
		printf "%s\t\t\t%i\n" $poble $sumatori		
	elif [[ ${#poble} -ge 24  && ${#poble} -lt 32 ]]; then
		printf "%s\t\t%i\n" $poble $sumatori
	else
		printf "%s\t%i\n" $poble $sumatori
	fi
	printf "%s;%i\n" $poble $sumatori >> ./resultats/output_C1.txt
done < ./resultats/municipis.txt

#Esborrem fitxers temporals generats
for i in temp_{1..5}.*; do
	test -f "$i" && rm -r "$i"
done

printf "*******************************************\n\n"
