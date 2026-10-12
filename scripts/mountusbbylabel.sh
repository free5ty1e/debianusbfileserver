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

echo "Automounting all USB drives by volume name / label..."
for dev in $(ls -1 /dev/disk/by-label/* | grep -v EFI) ; do
	label=$(basename "$dev")
	mkdir -p "/media/$label"
	
	# Check if it is already mounted
	if ! mount | grep -q "/media/$label"; then
		# Determine the filesystem type
		fstype=$(blkid -s TYPE -o value "$dev")
		
		# Apply umask=000 if the filesystem is exFAT
		if [[ "$fstype" == "exfat" ]]; then
			mount -o umask=000 "$dev" "/media/$label"
		else
			mount "$dev" "/media/$label"
		fi
	fi
done
