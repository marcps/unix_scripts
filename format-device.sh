#!/bin/bash
echo "Created by Marc Pascual email me at mpasole@protonmail.com"
sleep 0.5
echo "This program is supposed to format and/or erase the partition </device/path>1"
sleep 0.5
echo "IMPORTANT! the steps of the formatting/Erasing the disk must be"
sleep 1
echo
echo "         1) Delete ALL partitions of the desired disk"
echo "         2) (OPTIONAL) Delete all data"
echo "         3) Create the partition in position 1"
sleep 5
echo "--------------------------------------------------------"
sleep 1
echo -n "Name of the device to be formatted (include PATH): "
read devName
sleep 1
echo
echo "Unmounting $devName..."
#The device is unmounted:
echo
sudo umount $devName
echo "Done"
echo
echo "--------------------------------------------------------"
#-------- PARTITION ERASE -------------------------
lsblk
echo
sleep 0.5
echo -n "Do you first need to delete any partitions?[Y/n]: "
read bs
case $bs in
	"Y"|"y")
		echo "Changing to fsdisk enviroment..."
		echo
		echo
		sleep 2
		fdisk $devName
		;;
	"N"|"n")
		echo "OK."
		sleep 1.5
		continue
		;;
esac

#-------- DATA ERASE-----------------------------------------
echo
echo
echo "--------------------------------------------------------"
echo -n "Do you want to erase all data from $devName? [Y/n]: "
read b
case $b in
	"Y"|"y")
		echo "Erasing all data of $devName ..."
		sudo dd if=$devName of=$devName bs=4k && sync
		echo "Done"
		sleep 1
		#----------------------- PARTITION CRETION ------------------------------
		echo
		echo
		echo "Now you will have to create a NEW PARTITION in the fdisk enviroment"
		sleep 0.5
		echo "                                            ------------"
		echo "IMPORTANT: you MUST create the partition in| POSITION 1 |"
		echo "                                            ------------"
		sleep 5
		echo "Changing to fsdisk enviroment.."
                echo
                echo
                sleep 2

		sudo fdisk $devName

		echo "New partition tree"
		echo
		lsblk
		sleep 6
		echo "The new disk partition will be now formatted in FAT32 filesystem format"
		echo "with the #mkfs.vfat $devName command:"
		sleep 1

		#It is assumed that the partition will aquire the suffix 1:
                devName1="$devName""1"
		echo "formatting the partition $devName1"
                sudo mkfs.vfat $devName1
		echo
		echo "Formatted"
		sleep 0.5

		echo "Finished!"
		echo "remeber to eject it properly with: #sudo eject $devName"
		echo "Or mount it with: #sudo mount $devName <desired-folder>"
		;;
	"N"|"n")
		#----------------------- PARTITION CRETION ------------------------------
                echo
                echo "NOT deleting any data"
		sleep 1
                echo "Now you will have to create a NEW PARTITION in the fdisk enviroment"
                sleep 0.5
                echo "                                            ------------"
                echo "IMPORTANT: you MUST create the partition in| POSITION 1 |"
                echo "                                            ------------"
                sleep 5
                echo "Changing to fsdisk enviroment.."
                echo
                echo
                sleep 2

                sudo fdisk $devName

                echo "New partition tree"
                echo
                lsblk
                sleep 6
                echo "The new disk partition will be now formatted in FAT32 filesystem format"
                echo "with the #mkfs.vfat $devName command:"
                sleep 1

		#It is assumed that the partition will aquire the suffix 1:
                devName1="$devName""1"
                echo "formatting the partition $devName1"
                sudo mkfs.vfat $devName1
                echo
                echo "Formatted"
                sleep 0.5

                echo "Finished!"
                echo "remeber to eject it properly with: #sudo eject $devName"
                echo "Or mount it with: #sudo mount $devName <desired-folder>"

		;;
esac
