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

echo -e "\e[32mSelect the interface to be used\e[39m" 'Ex: wlan0'
read interface

echo -e "\e[32mInsert AP SSID\e[39m"
read SSID

echo -e "\e[32mWrite the name of the certificate to be created\e[39m"
read cert

echo -e "\e[32mWrite the CommonName\e[39m" 'Ex: COPORATE.DEMOBANK.COM'
read commonName

echo -e "\e[32mIt will be deployed in the 2.4GHz band? \e[39m" '[yes] [no]'
read band

YES="yes"

if [ $band = $YES ]; then
        echo -e "\e[32mSelect a channel between 1 and 13 \e[39m"
        read channel
	if [ $channel -lt 1 ] || [ $channel -gt 13 ]; then
		exit 1
	fi
else
        echo -e "\e[32mSelect a channel between the ranges 34-64 and 100-140 \e[39m"
        read channel
	if [ $channel -lt 34 ] || [ $channel -gt 140 ]; then
		exit 1
	elif [ $channel -gt 64 ] && [ $channel -lt 100 ]; then
		exit 1
	fi
fi


echo -e "\e[33mCreating certificates and configuration files... \e[39m"
python $pwd/hostapdWPEinstall/apd_launchpad/apd_launchpad.py -t $cert -s $SSID -i $interface -cn $commonName

if [ $? = 0 ]; then
	echo -e "\e[33mEverything correctly generated \e[39m"
	echo -e "\e[33mDeploying AP \e[39m"
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
	
else
	echo 'Error running script apd_launchpad.py'
	echo
fi
