#!/bin/bash/

echo "This script will flush all the non-permanent iptable rules"
echo -n "Do you want to continue?[Y/n]: "
read b
echo
case $b in
	"Y"|"y")
		sudo iptables -F
		echo "all rules flushed!"
		echo "default rules"
		iptables -L
		echo
		;;

	"N"|"n")
		echo "Go fuck yourself"
		;;
esac
