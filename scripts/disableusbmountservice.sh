#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

echo "Disabling usbmount service"
sed -i -E 's/(ENABLED=).*/\10/' /etc/usbmount/usbmount.conf
