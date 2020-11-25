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

echo "If automounting USB HDDs at startup via usbmount, should probably wait via sleep in /etc/rc.local before executing this."

echo "Autolinking all already-mounted USB drives by volume name / label..."
for dev in $(ls -1 /dev/disk/by-label/* | grep -v EFI) ; do
	label=$(basename $dev)
	mountpoint=$(mount | grep $(readlink --canonicalize "$dev") | awk -v N=$3 '{print $3; exit;}')
	echo "Autolinking $dev at $mountpoint to /media/$label"
	rm -v "/media/$label"
	test -e "/media/$label" || ln -sf "$mountpoint" "/media/$label"
done
