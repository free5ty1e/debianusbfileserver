#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

echo "Attempting to fix journal of $1... (you should pass /dev/sdX# device to this script if you did not...)"
umount "$1"
tune2fs -O ^has_journal "$1"
e2fsck -f "$1"
tune2fs -j "$1"
mountusbbylabel.sh
