#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

mkdir -vp /media/primegames
mount -t cifs -o user=pi //192.168.100.110/sharedusb/PrimeGamesBee /media/primegames
