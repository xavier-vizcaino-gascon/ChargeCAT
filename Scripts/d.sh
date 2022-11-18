#!/bin/bash

creataula(){

awk -F: 'BEGIN {FS=";"
		print "<table style=\"border-collapse: collapse; border-style: solid; margin-left: auto; margin-right: auto;\" border=\"1\" cellspacing=\"10%\">"
		print "<tbody>"}
               {print "<tr>"
               for (i = 1; i <= NF; i++){
               	print "<td style=\"height: 18px; text-align: center;\">"$i"</td>"
               }
               print "</tr>"}
         END   {print "</tbody>"
         	print "</table>"
         	}' $1
}

touch ./resultats/Report.html
cat > ./resultats/Report.html << EOF_A

<!DOCTYPE html>
<html>
<head>
<title>Programació Scripting_PF</title>
</head>
<h1 style="color: #5e9ca0;"><span style="color: #000000;">Programaci&oacute; en Scripting</span></h1>
<h1 style="color: #5e9ca0;"><span style="color: #333333;">Practica Final</span></h1>
<p><span style="color: #000080;">Nom: Xavier Vizcaino</span></p>
<p><span style="color: #000080;">Usuari: xvizcainog</span></p>
<p>&nbsp;</p>
<h2 style="color: #2e6c80;"><span style="color: #ff6600;">Exercici A:</span></h2>
<p>A continuació es mostra la informació bàsica obtinguda en l'exercici A: URL, número de columnes del dataset i numero de registres d'aquest</p>
<p><strong>Taula resultat</strong></p>
EOF_A

creataula ./resultats/output_A.txt >> ./resultats/Report.html

cat >> ./resultats/Report.html << EOF_B
<p>&nbsp;</p>
<h2 style="color: #2e6c80;"><span style="color: #ff6600;">Exercici B:</span></h2>
<p>A continuació es mostra el nombre d'ubicacions per cada provincia que tinguin com a mínim 1 carregador RAPID</p>
<p><strong>Taula resultat</strong></p>
EOF_B

creataula ./resultats/output_B.txt >> ./resultats/Report.html

cat >> ./resultats/Report.html << EOF_C1
<p>&nbsp;</p>
<h2 style="color: #2e6c80;"><span style="color: #ff6600;">Exercici C_bash:</span></h2>
<p>A continuació es mostra el nombre de places d'aparcament designades a la càrrega de vehícles per cada municipi de catalunya</p>
<p><strong>Taula resultat</strong></p>
EOF_C1

creataula ./resultats/output_C1.txt >> ./resultats/Report.html

cat >> ./resultats/Report.html << EOF_C2
<p>&nbsp;</p>
<h2 style="color: #2e6c80;"><span style="color: #ff6600;">Exercici C_awk:</span></h2>
<p>A continuació es mostra la potència mitjana, mínima i màxima dels caregadors agrupats per provinicies</p>
<p><strong>Taula resultat</strong></p>
EOF_C2

creataula ./resultats/output_C2.txt >> ./resultats/Report.html

cat >> ./resultats/Report.html <<< "</html>"
