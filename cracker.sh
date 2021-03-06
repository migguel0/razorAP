#!/bin/bash

echo -e "\e[33m --------------------------------------- \e[32m"
echo -e "\e[33m --------------------------------------- \e[32m"
echo -e "\e[33m --------- CRACKER HELPER -------------- \e[32m"
echo -e "\e[33m --------------------------------------- \e[32m"
echo -e "\e[33m --------------------------------------- \e[32m"
echo
echo
echo

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------
#REVISAR JOHN
function johnCracking(){
    	echo -e "\e[33mJohn the Reaper selected\e[32m"

	echo -e "\e[33mEnter the absolute path of the dictionary to be used\e[39m"
	read diccionario
	#Parsing log file
	cat hostapd-wpe.log | sed 's/::::/ /g' > logaux.log
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
	#Mostrar lineas con el HASH y que decida el usuario el numero de linea que quiere crackear
	awk '/jtr/ {print $3}' hostapd-wpe.log > /var/tmp/soloHash.txt
	sed '=' /var/tmp/soloHash.txt

	echo -e "\e[33mIndicate the number of HASH shown to crack\e[39m"
	read lineNumber
	awk "NR==$lineNumber {print \$1}" /var/tmp/soloHash.txt
	awk "NR==$lineNumber {print \$1}" /var/tmp/soloHash.txt > /var/tmp/hashSelected.hash
	john --show $diccionario /var/tmp/hashSelected.hash
	rm /var/tmp/hashSelected.hash
}


function asleapCracking(){
	counter=0
	echo -e "\e[33masleap selected\e[39m"

	echo -e "\e[33mEnter the absolute path of the dictionary to be used\e[39m"
	read diccionario
	#Parsing log file
	cat hostapd-wpe.log | sed 's/::::/ /g' > logaux.log
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
	#Mostrar lineas con el RESPONSE y que decida el usuario el numero de linea que quiere crackear
	awk '/username/ {print $2}' logaux.log > /var/tmp/users.txt
	awk '/response/ {print $2}' logaux.log > /var/tmp/response.txt
	awk '/challenge/ {print $2}' logaux.log > /var/tmp/challenge.txt
	>parser.txt
	while read -a linea
	do
		counter=$((counter + 1))
		OUTPUT=$(awk "NR==$counter {print \$1}" /var/tmp/response.txt)
		CHALLENGE=$(awk "NR==$counter {print \$1}" /var/tmp/challenge.txt)
		echo "$linea challenge: $CHALLENGE response: $OUTPUT " >> parser.txt
	done < /var/tmp/users.txt
	
	awk '/response/' parser.txt | sed '='

	echo -e "\e[33mIndicate the number of HASH shown to crack\e[39m"
	read lineNumber
	#awk "NR==$lineNumber {print \$3}" parser.txt
	challenge=$(awk "NR==$lineNumber {print \$3}" parser.txt)
	response=$(awk "NR==$lineNumber {print \$5}" parser.txt)
	rm /var/tmp/users.txt
	rm /var/tmp/response.txt
	rm /var/tmp/challenge.txt
	rm parser.txt

	asleap -C $challenge -R $response -W $diccionario
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
}

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------

johnTool="john"
asleapTool="asleap"
no="no"

#cat hostapd-wpe.log | sed 's/::::/ /g' > logaux.log




#Bucle infinito hasta que diga NO
while :
do
	#john no funciona bien, se elimina por ahora de las opciones
	echo -e "\e[33mSelect the tool for the cracking phase: [asleap]\e[39m"
	read tool

	if [ $tool = $johnTool ]; then
		johnCracking
	elif [ $tool = $asleapTool ]; then
		asleapCracking
	fi
	
	echo -e "\e[33mDo you want to crack another hash or use another tool? [yes] [no]\e[39m"
	read anotherLoop
	clear
	if [ $anotherLoop = $no ]; then
		#Borrar archivo de log auxiliar
		rm logaux.log
		break
	fi
done



