#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

echo "You should have added this computer's SSH public key to your fileserver for authentication.  Attempting..."

mkdir -vp /media/PrimeDataPool
# mount -t cifs -o user=pi,username=pi,uid=$(id -u),gid=$(id -g),forceuid,forcegid //192.168.100.105/PrimeDataPool /media/PrimeDataPool
mount -t cifs -o user=pi,username=pi,uid=$(id -u),gid=$(id -g) //192.168.100.105/PrimeDataPool /media/PrimeDataPool
