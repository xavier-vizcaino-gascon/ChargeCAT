BEGIN {
	FS=";"
	for (i=1;i<5;i++){
		Min[i]=1000
	}
	Prov[1]="Barcelona"
	Prov[2]="Tarragona"
	Prov[3]="Girona"
	Prov[4]="Lleida"
}
#Loop principal
{
	if (NR!=1 && ($2==Prov[1]) && ($6 != "no_data") && ($9 != "no_data")) {
		i=1
		Pow[i]+=$6*$9
		Par[i]+=$9
		Loc[i]++
		(Max[i] < $6) ? Max[i]=$6 : Max[i]=Max[i]
		(Min[i] > $6) ? Min[i]=$6 : Min[i]=Min[i]
	}
	if (NR!=1 && ($2==Prov[2]) && ($6 != "no_data" ) && ($9 != "no_data")) {
		i=2
		Pow[i]+=$6*$9
		Par[i]+=$9
		Loc[i]++
		(Max[i] < $6) ? Max[i]=$6 : Max[i]=Max[i]
		(Min[i] > $6) ? Min[i]=$6 : Min[i]=Min[i]
	}	
	if (NR!=1 && ($2==Prov[3]) && ($6 != "no_data") && ($9 != "no_data")) {
		i=3
		Pow[i]+=$6*$9
		Par[i]+=$9
		Loc[i]++
		(Max[i] < $6) ? Max[i]=$6 : Max[i]=Max[i]
		(Min[i] > $6) ? Min[i]=$6 : Min[i]=Min[i]
	}	
	if (NR!=1 && ($2==Prov[4]) && ($6 != "no_data") && ($9 != "no_data")) {
		i=4
		Pow[i]+=$6*$9
		Par[i]+=$9
		Loc[i]++
		(Max[i] < $6) ? Max[i]=$6 : Max[i]=Max[i]
		(Min[i] > $6) ? Min[i]=$6 : Min[i]=Min[i]
	}

}
END {
#Imprimim per pantalla
	printf ("\nSCRIPT C_awk:\n\n*** RESUM POTENCIES DE CÀRREGA ***\nPROVINCIA\tPOTENCIA MITJANA\tMIN\tMAX\tPLACES\nBarcelona\t\t%.2fkW\t\t%ikW\t%ikW\t%i\nTarragona\t\t%.2fkW\t\t%ikW\t%ikW\t%i\nGirona\t\t\t%.2fkW\t\t%ikW\t%ikW\t%i\nLleida\t\t\t%.2fkW\t\t%ikW\t%ikW\t%i\n**********************************\n\n",(Pow[1]/Par[1]),Min[1],Max[1],Par[1],(Pow[2]/Par[2]),Min[2],Max[2],Par[2],(Pow[3]/Par[3]),Min[3],Max[3],Par[3],(Pow[4]/Par[4]),Min[4],Max[4],Par[4])
	printf "PROVINCIA;POT_AVG;MIN;MAX;PLACES\n" > "./resultats/output_C2.txt"
	for (i=1;i<5;i++){
		printf ("%s;%.2f;%i;%i;%i\n",Prov[i],Pow[i]/Par[i],Min[i],Max[i],Par[i]) >> "./resultats/output_C2.txt"
	}
}







