#!/bin/bash

#Copyright Marc Pascual i Solé, created on 17/07/2017
#This program changes the status mode of the desired wireless interface to either MONITOR or MANAGED mode
#IMPORTANT: in order to keep the variables defined by this program, it needs to be executed with the SOURCE cmd
#################################################################################
echo "        ______________________________________________________"
echo "       / _____  _______  ________  _____    ____  ___  ___    \\"
echo "      / /     |/      / /       / /     \\  /   / /  / /  /    /"
echo "     / /             / /       / /       \\/   / /   \\/  /    /"
echo "    / /   /\\  /\\    / /   /   / /   /\\       /  \\      /    /"
echo "   / /   /  \\/ /   / /       / /   /  \\     /    \\    /    /"
echo "  / /___/     /___/ /_______/ /___/    \\___/     /___/    /"
echo " /_______________________________________________________/"
echo
sleep 1.5
echo "Created by Marc Pascual i Solé. 14/6/2017. marc.ps.12@gmail.com"
sleep 0.5
echo "Last modification: " $(stat $HOME/Documents/unix_scripts/monitor.sh | grep Modify | gawk '{ FS = " " } {print $2}')
echo
echo
echo "_____________________________________________________________"
sleep 0.6
echo
echo "			Welcome to MONY"
echo
echo "_____________________________________________________________"
sleep 1.2
echo -n "[*] Choose your option [monitor/managed]: "
read ans
echo
case $ans in
	"monitor"|"mon"|"Monitor")
		echo "The Network Card will be set to MONITOR Mode"
		sleep 0.6
		echo -n "[*] Are you sure you want to continue?[Y/n]: "
		read yn
		echo
		sleep 0.8
	#Asks the user to continue
		case $yn in
			"Y"|"y"|"yes"|"si"|"ja"|"Hlja"|"hlja")

			#Reads the user's input:
                		echo -n "[*] INTERFACE name: "
                		read int
				echo
				sleep 1
				echo "[+] Stopping Network Manager"
				service NetworkManager stop
				sleep 1
			#Changes the Network Card Mode and changes MACAddr
				echo "[+] Changing card to Monitor Mode"
				ifconfig $int down
			#Change Randomly the MAC Address:
				echo
				echo "[+] Changing MAC Address..."

				echo "		----------"
                		macchanger $int -r
				echo "		----------"

                		sleep 1

				iwconfig $int mode monitor
				echo "[+] $int interface is now in: " $(iwconfig wlp2s0 | grep Mode | gawk '{ FS = " "} {print $4}' && echo)
				ifconfig $int up
				echo "[+] Checking for interfering processes...."
				echo
		#CHECKING FOR INTERFERING PROCESSES:
                		sleep 1.5
				echo "		----------"&&echo
                		airmon-ng check $int
				sleep 2
                #------------------------------------------------------------------------------------------------------------------------
                #1) Kill dhClient
                		if [["$(airmon-ng check $int | grep dhclient | gawk '{ FS}  NR==1{print $2}')" == "dhclient" ]] ; then

                        		echo "[+] Killing $(airmon-ng check $int | grep dhclient | gawk '{ FS}  NR==1{print $2}')..."
                        		sleep 1
					kill "$(airmon-ng check $int | grep dhclient | gawk '{ FS}  NR==1{print $1}')"
					echo "Please Wait..."
					echo
                        		sleep 5

                		fi
		#2) Killing wpa_supplicants
                		if [ ["$(airmon-ng check $int | grep wpa_supplicant | gawk '{FS} {print $2}')" == "wpa_supplicant"]] ; then

                        		echo "[+] Killing" $(airmon-ng check $int | grep wpa_supplicant | gawk '{FS} {print $2}') "...."
					sleep 1
                        		sudo kill "$(airmon-ng check $int | grep wpa_supplicant | gawk '{ FS } {print $1}')"
                        		echo "Please Wait..."
                        		sleep 5

                		fi
		#3) Killing (if Possible, any avahi-daemons
                		if [] "$(airmon-ng check $int | grep avahi-daemon | awk '{FS} NR==1{print $2}')" == "avahi-daemon" ]] ; then

                        		echo "[+] Killing Avahi-Daemons..."
					sleep 0.4
                        		sudo kill "$(airmon-ng check wlp2s0 | grep avahi-daemon | awk '{FS} NR==1{print $1}')"
                        		sudo kill "$(airmon-ng check wlp2s0 | grep avahi-daemon | awk '{FS} NR==2{print $1}')"
                        		sleep 5

                		fi
		#------------------------------------------------------------------------------------
				sleep 2
				echo
                		echo "[+] Checking for interfering processes again"
                		sleep 1
				echo
				echo "		----------"
                		airmon-ng check $int
				echo "		----------"
				echo
                		sleep 2

                		echo "[+] Success. Exiting....."
			;;

			"N"|"n"|"no"|"No")
				sleep 0.4
				echo "[+] Nothing has been done"
				echo "Exitting..."
				exit 1
			;;
		esac
	;;

	"managed"|"man"|"Managed")

		echo "This will set the Network Card to MANAGED Mode"
                sleep 0.6
                echo -n "[*] Are you sure you want to continue?[Y/n]: "
                read yn
		echo
                case $yn in
                        "y"|"Y")
				echo -n "[*] Interface Name: "
				read  int
				echo
				sleep 0.6

				echo "[+] Bringning $int DOWN"
                                ifconfig wlan0 down
                                iwconfig wlan0 mode managed
				sleep 2
			#Shows the mode to std output
				echo "[+] $int interface is now in:" $(iwconfig wlp2s0 | grep Mode | gawk '{ FS = " "} {print $4}' && echo)
			#Changes the MACAddr back to its original one
				echo
				macchanger $int -p
				echo
				sleep 2
				echo "[+] Bringing $int UP again"
                                ifconfig wlan0 up
				sleep 4
				echo "[+] Restarting Network Manager daemon..."
				service NetworkManager restart
				echo "[+] Please Wait..."
				sleep 20
				echo
				echo "[+] Ping TEST"
				echo
				ping -c 2 duckduckgo.com
				echo
				echo "All Done. Exitting..."
			;;

                        "N"|"n"|"no"|"No")

				sleep 1
                                exit
			;;
		esac
	;;

	*)
		exit
	;;
esac
