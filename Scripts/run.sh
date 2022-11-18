#!/bin/bash

printf "començant SCRIPT run\n\n"
inici=$EPOCHSECONDS

bash ./a.sh -v
bash ./b.sh
bash ./c_bash.sh ./dataset/maindata.txt
gawk -f c_awk.awk ./dataset/maindata_2.txt
bash ./d.sh

final=$EPOCHSECONDS
timelapse=$(( $final - $inici ))
printf "temps transcorregut = %i segons\n" $timelapse

firefox ./resultats/Report.html
echo "Obre l'arxiu \"./resultats/Report.html\""
