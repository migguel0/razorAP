#!/bin/bash

touch hostapd-wpe.log

echo -e "\e[32m ------------------------------------------ \e[39m"
echo -e "\e[32m ------------------------------------------ \e[39m"
echo -e "\e[32m ------- RAZOR AP CONFIGURATION ----------- \e[39m"
echo -e "\e[32m ------------------------------------------ \e[39m"
echo -e "\e[32m ------------------------------------------ \e[39m"
echo
echo
echo

pwd=$(pwd)

	#echo "Error: Primer parametro del script NOMBRE_CERTIFICADO, segundo parametro SSID y tercer parametro interfaz a usar y cuarto parametro CommonName."
	#echo "Ejemplo: ./runHostAPD.sh DEMOBANK CORPORATE-WIFI wlan0 COPORATE.DEMOBANK.COM"

echo -e "\e[32mSeleccione la interfaz a usar\e[39m" 'Ex: wlan0'
read interface

echo -e "\e[32mEscriba el SSID del AP\e[39m"
read SSID

echo -e "\e[32mEscriba el nombre del certificado a incluir en el AP\e[39m"
read cert

echo -e "\e[32mEscriba el CommonName\e[39m" 'Ex: COPORATE.DEMOBANK.COM'
read commonName

echo -e "\e[32m¿Se va a desplegar en banda de 2.4GHz? \e[39m" '[si] [no]'
read band

YES="si"

if [ $band = $YES ]; then
        echo -e "\e[32mSeleccione un canal entre 1 y 13 \e[39m"
        read channel
	if [ $channel -lt 1 ] || [ $channel -gt 13 ]; then
		exit 1
	fi
else
        echo -e "\e[32mSeleccione un canal entre los rango 34-64 y 100-140 \e[39m"
        read channel
	if [ $channel -lt 34 ] || [ $channel -gt 140 ]; then
		exit 1
	elif [ $channel -gt 64 ] && [ $channel -lt 100 ]; then
		exit 1
	fi
fi


echo -e "\e[33mElaborando certificados y archivos de configuracion... \e[39m"
python $pwd/hostapdWPEinstall/apd_launchpad/apd_launchpad.py -t $cert -s $SSID -i $interface -cn $commonName

if [ $? = 0 ]; then
	echo -e "\e[33mTodo generado correctamente \e[39m"
	echo -e "\e[33mLevantando hosatpd-wpe \e[39m"
	echo -e "\e[33mSe va a ejecutar: hostapd-wpe $pwd/$cert/$cert.conf -s \e[39m"
	echo

	echo "" >> $pwd/$cert/$cert.conf
	echo "#wpe_logfile=$pwd/hostapd-wpe.log" >> $pwd/$cert/$cert.conf
	#configuracion extra para 5GHz
	if [$band != $YES]; then
		echo "hw_mode=a" >> $pwd/$cert/$cert.conf
		echo "channel=$channel" >> $pwd/$cert/$cert.conf
		echo "driver=nl80211" >> $pwd/$cert/$cert.conf
		echo "ieee80211n=1" >> $pwd/$cert/$cert.conf
		echo "ieee80211ac=1" >> $pwd/$cert/$cert.conf
		sed 's/ieee8021x=1/#ieee8021x=1/' $pwd/$cert/$cert.conf
	fi

	nmcli radio wifi off
	rfkill unblock wlan
	#cat $pwd/$cert/$cert.conf
	hostapd-wpe $pwd/$cert/$cert.conf 2>&1 | tee -a $pwd/hostapd-wpe.log
	#if [ $? = 0 ]; then
	#	echo -e '\e[36mSistema levantado correctamente\e[39m'
	#	echo
	#else
	#	echo -e '\e[31mError ejecutando: hostapd-wpe $pwd/$cert/$cert.conf -s , intentarlo manualmente.\e[39m'
	#	echo
	#fi
else
	echo 'Error ejecutando script apd_launchpad.py'
	echo
fi
