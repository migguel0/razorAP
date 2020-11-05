#!/bin/bash

pwd=$(pwd)

apt-get update
apt-get install hostapd-wpe -y


if [ ! -d "$pwd/hostapdWPEinstall" ]
then
	mkdir hostapdWPEinstall
fi

if [ -d "$pwd/hostapdWPEinstall/apd_launchpad/" ]; then
	rm -r $pwd/hostapdWPEinstall/apd_launchpad/
fi

touch hostapd-wpe.log
cp $pwd/installer/hostapd-wpe.eap_user $pwd
cp $pwd/installer/razorAP.sh $pwd
cp $pwd/installer/analyzer.sh $pwd
cp $pwd/installer/init.sh $pwd
cp $pwd/installer/termsScript.sh $pwd

chmod +x razorAP.sh
chmod +x analyzer.sh
chmod +x init.sh
chmod +x termsScript.sh
chmod +x cracker.sh

cd hostapdWPEinstall
git clone https://github.com/WJDigby/apd_launchpad.git
cp $pwd/hostapdWPEinstall/apd_launchpad/apd_launchpad.py /etc/hostapd-wpe/certs/

rm -r $pwd/installer/
rm $pwd/install.sh
