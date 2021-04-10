#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

echo "Enabling usbmount service"
sed -i -E 's/(ENABLED=).*/\11/' /etc/usbmount/usbmount.conf
