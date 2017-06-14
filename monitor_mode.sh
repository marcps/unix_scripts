#!/bin/bash
#Copyright Marc Pascual i Solé, created on 17/07/2017 
#This program changes the status mode of the desired wireless interface to MONITOR
#IMPORTANT: in order to keep the variables defined by this program, it needs to be executed with the SOURCE cmd

################################################################################################
scriptName="monitor_mode.sh" #if the name of the file is changed, this needs to be changed!


echo "Created on 17/07/2017 by Marc Pascual i Solé. Mail me at marc.ps.12@gmail.com or mpasole@protonmail.com"
sleep 2
echo "Last modification: " $(stat monitor_mode.sh | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 3

echo "This program needs to be run under the source command"
sleep 1
#################################################################################################

#Checks if the user is running the script with the SOURCE command
echo -n "have you executed this program with the \"source\" command? [Y/n]: "
read boolAnswer


case $boolAnswer in
	"Y"|"y"|"yes"|"si"|"ja"|"Hlja"|"hlja")

		#Reads the user's input:
		echo -n "Type in the name of your interface: "
		read interface

		sudo service NetworkManager stop
		echo "Service Net-manager has been stopped"

		ifconfig $interface down
		echo "$interface interface is now down"
		sleep 0.8

		iwconfig $interface mode monitor
		#Takes the information from the iwconfig command!
		echo "$interface interface is now in:" $(iwconfig wlp2s0 | grep Mode | gawk '{ FS = " "} {print $4}' && echo)
		sleep 0.8

		myMAC="00:11:22:33:44:55"
		macchanger $interface --mac=$myMAC | grep "Tandem War Elephant"
		echo "$interface new MAC Address: " $myMAC
		sleep 0.8

		ifconfig $interface up
		echo "$interface interface is now up"
		sleep 3


		#CHECKING FOR INTERFERING PROCESSES:
		echo "checking for interfering processes:"
		sleep 1.5
		airmon-ng check $inteface
		#----------------------------------------------------------------------------------
		#1) Kill dhClient
                if [ "$(airmon-ng check wlp2s0 | grep dhclient | gawk '{ FS}  NR==1{print $2}')" == "dhclient" ]; then
                        echo "killing $(airmon-ng check wlp2s0 | grep dhclient | gawk '{ FS}  NR==1{print $2}')...."
                        kill "$(airmon-ng check wlp2s0 | grep dhclient | gawk '{ FS}  NR==1{print $1}')"
			sleep 10
		fi
		#2) Kill Network Manager:
		if [ "$(airmon-ng check wlp2s0 | grep NetworkManager | gawk '{ FS = " " } {print $2}')" == "NetworkManager" ]; then
			echo "killing Network Manager..."
			kill "$(airmon-ng check wlp2s0 | grep NetworkManager | gawk '{ FS = " " } {print $1}')"
			sleep 10
		fi
		if [ "$(airmon-ng check wlp2s0 | grep wpa_supplicant | gawk '{FS} {print $2}')" == "wpa_supplicant" ]; then
			echo "killing $(airmon-ng check wlp2s0 | grep wpa_supplicant | gawk '{FS} {print $2}')...."
			kill "$(airmon-ng check wlp2s0 | grep wpa_supplicant | gawk '{ FS } {print $1}')"
			echo "Please Wait..."
			sleep 10
		fi
		if [ "$(airmon-ng check wlp2s0 | grep avahi-daemon | awk '{FS} NR==1{print $2}')" == "avahi-daemon" ]; then
			echo "killing Avahi Daemons..."
			kill "$(airmon-ng check wlp2s0 | grep avahi-daemon | awk '{FS} NR==1{print $1}')"
			kill "$(airmon-ng check wlp2s0 | grep avahi-daemon | awk '{FS} NR==2{print $1}')"
			sleep 2
		fi


		#--------------------------------------------------------------------------------------
		sleep 2
		echo "checking for interfering processes again"
		sleep 1
		airmon-ng check $interface
		sleep 2

		echo "success. Exiting....."
		;;

	"N"|"n"|"no"|"No"|"NO"|"nein")
		echo "this program should be using the Source  command"
		sleep 0.8
		echo -n "do you want to run it with SOURCE? [Y/n]: "
		read nBool
		echo
		case $nBool in
			"Y"|"y"|"yes"|"si"|"ja"|"Hlja"|"hlja")
				echo "starting $scriptName with Source...."
				source $scriptName
			;;

			"N"|"n"|"no"|"No"|"NO"|"nein")
				echo "Exitting...."
				sleep 1
				break
			;;
		esac
		;;
	*)
		echo "Does not compute..."
		sleep 3
		echo
		echo
		echo "please try again!"
		./"$scriptName"
		;;
esac
