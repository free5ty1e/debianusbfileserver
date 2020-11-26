#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

# echo "Enforcing no-sleep USB policies..."
# bash -c "for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 2 > $i; done"
# bash -c "for foo in /sys/bus/usb/devices/*/power/level; do echo on > $foo; done"

echo "Enabling usbmount service"
sed -i -E 's/(ENABLED=).*/\11/' /etc/usbmount/usbmount.conf

echo "Automounting all USB drives by volume name / label..."
for dev in $(ls /dev/sd?) ; do
	echo "Connecting $dev"
	touch $dev
	sleep 7
done

echo "Waiting a bit longer for mount tasks to complete..."
sleep 10

echo "Disabling usbmount service"
sed -i -E 's/(ENABLED=).*/\10/' /etc/usbmount/usbmount.conf

