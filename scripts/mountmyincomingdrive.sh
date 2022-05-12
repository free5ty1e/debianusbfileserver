#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

mkdir -vp /media/incoming
mount -t cifs -o user=pi,username=pi,password=raspberry,uid=$(id -u),gid=$(id -g),forceuid,forcegid //192.168.100.137/incoming /media/incoming
