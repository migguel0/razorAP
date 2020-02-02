#!/bin/bash

counter=0
awk '/username/ {print $2}' hostapd-wpe.log > users.txt
> parser.txt

awk '/response/ {print $2}' hostapd-wpe.log > aux.txt
awk '/hashcat/ {print $3}' hostapd-wpe.log > hash.txt

if [ "$1" == "csv" ]
then
	if [ -f "resultados.csv"]; then
		rm resultados.csv
	fi
	echo "username	response	hashcat" >> resultados.csv
fi

while read -a linea
do
	counter=$((counter + 1))
	OUTPUT=$(awk "NR==$counter {print \$1}" aux.txt)
	HASH=$(awk "NR==$counter {print \$1}" hash.txt)
	if [ "$1" == "csv" ]
	then
		echo "$linea	$OUTPUT	$HASH" >> resultados.csv
	else
		echo "username: $linea ; response: $OUTPUT ; hashcat: $HASH" >> parser.txt
	fi
done < users.txt

rm users.txt
rm aux.txt
rm hash.txt
