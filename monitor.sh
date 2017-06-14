#!/bin/bash
echo
echo "        ______________________________________________________"
echo "       / ______  ______  ________  _____    ____  M           \"
echo "      / /      |/     / /       / /     \  /   /   O          /"
echo "     / /             / /       / /       \/   /     N  M     /"
echo "    / /   /\  /\    / /   /   / /   /\       /      I   O   /"
echo "   / /   /  \/ /   / /       / /   /  \     /       T   D  /"
echo "  / /___/     /___/ /_______/ /___/    \___/       O   E  /"
echo " /________________________________________________R______/"
echo
sleep 1.5
echo "Created by Marc Pascual i Solé. 14/6/2017. marc.ps.12@gmail.com"
case $ans in
	"monitor"|"mon")
		echo "This will set the Network Card to MONITOR Mode"
		sleep 0.6
		echo -n "Are you sure you want to continue?[Y/n]: "
		read yn
		case $yn in
			"y"|"Y")
				service NetworkManager stop
				ifconfig wlan0 down
				iwconfig wlan0 mode monitor
				ifconfig wlan0 up
				echo "Checking for interfering processes:"
				airmon-ng check wlan0
			;;
			"N"|"n")
				sleep 0.4
				"Exitting..."
				exit
			;;
		esac
	;;

	"managed"|"man")
		echo "This will set the Network Card to MANAGED Mode"
                sleep 0.6
                echo -n "Are you sure you want to continue?[Y/n]: "
                read yn
                case $yn in
                        "y"|"Y")
                                ifconfig wlan0 down
                                iwconfig wlan0 mode managed
                                ifconfig wlan0 up
				echo "Restarting Network Manager daemon..."
				service NetworkManager restart
                        ;; 
                        "N"|"n")
                                sleep 0.4
                                "Exitting..."
                                exit
                        ;;
esac
