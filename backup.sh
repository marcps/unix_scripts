#!/bin/bash

echo "BACKUP PROGRAM made by Marc Pascual i Solé"
sleep 2
echo -n "Enter the filesystem you wish to make a backup of: "
read fileSys
sleep 0.5

echo -n "Enter the file name of the backup (ending with *.tar.gz): "
read tarName
sleep 0.5

echo "This program will create a backup of all the current file system"
echo -n "Are you sure you want to continue?[Y/n]: "
read b
case $b in

	"y"|"Y")
		echo "Creating the backup now..."
		sleep 1
		echo
		sleep 1
		cd $fileSys
		#The following command will make a backup except for the new backup file:
		sudo tar -cvpzf $tarName --exclude=./$tarName --one-file-system $fileSys
		echo "Backup complete!"
		echo
		;;
	"n"|"N")
		echo "Anything has been done"
		echo "Exitting..."
		echo
		;;
esac

#To restore the filesystem from a backup run:
#sudo tar -xvpzf /path/to/backup.tar.gz -C /restore/location --numeric-owner
