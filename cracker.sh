#!/bin/bash

johnTool="john"
asleapTool="asleap"

cat hostapd-wpe.log | sed 's/::::/ /g' > logaux.log


awk '/hashcat/ {print $4}' logaux.log > soloHash.txt

echo -e "\e[33mSeleccione la herramienta para la fase de cracking: [john] [response]\e[39m"
read tool


if [ $tool = $johnTool ]; then
	echo -e "\e[33mHas seleccionado John the Reaper\e[32m"
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
	#Mostrar lineas con el HASH y que decida el usuario el numero de linea que quiere crackear
	awk '/hashcat/ {print $3}' hostapd-wpe.log | sed '=' | sed 's/::::/ /g'

	echo -e "\e[33mIndique el numero de HASH que quiere crackear\e[39m"
	read lineNumber
	awk "NR==$lineNumber {print \$1}" soloHash.txt
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
elif [ $tool = $asleapTool ]; then
	echo -e "\e[33mHas seleccionado asleap\e[39m"
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
	#Mostrar lineas con el RESPONSE y que decida el usuario el numero de linea que quiere crackear
	awk '/username/ {print $2}' logaux.log > users.txt
	awk '/response/ {print $2}' logaux.log > response.txt
	>parser.txt
	while read -a linea
	do
		counter=$((counter + 1))
		OUTPUT=$(awk "NR==$counter {print \$1}" aux.txt)
		echo "$linea response: $OUTPUT " >> parser.txt
	done < users.txt

	#Borrar archivo de log auxiliar
	rm logaux.log
	awk '/response/' parser.txt | sed '='

	echo -e "\e[33mIndique el numero de HASH que quiere crackear\e[39m"
	read lineNumber
	awk "NR==$lineNumber {print \$3}" parser.txt
	#------------------------------------------------------------------------------------------
	#------------------------------------------------------------------------------------------
fi
