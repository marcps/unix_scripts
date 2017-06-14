#!/bin/bash
#Marc Pascual i Solé 17/07/2017
ifconfig wlp2s0 down
#Restores the default mac
macchanger wlp2s0 -p

iwconfig wlp2s0 mode managed
ifconfig wlp2s0 up
#Shows some output:
iwconfig wlp2s0 | grep Mode

echo -n "Restart Network Manager?[Y/n]: "
read nBool

case $nBool in
	"y"|"Y"|"yes"|"si")
		echo "restarting Network Manager Service"
		service NetworkManager restart
		sleep 15
		echo "checking internet connection:"
		ping google.com -c 5
		;;
	"n"|"N"|"no")
		break
		;;
esac
