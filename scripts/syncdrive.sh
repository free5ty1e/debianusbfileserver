#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "syncdrive.sh /media/VolumeOne /media/VolumeOneBak"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

if [ -z "$2" ] ; then
	usage_notes
    exit 0
fi

SYNCLOC1="$1"
SYNCLOC2="$2"

#echo "Enforcing no-sleep USB policies..."
#sudo bash -c "for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 2 > $i; done"
#sudo bash -c "for foo in /sys/bus/usb/devices/*/power/level; do echo on > $foo; done"

echo "Performing dry run first to allow review of changes before proceeding"

rsync --archive --verbose --stats --whole-file --progress --times --dry-run --human-readable "${SYNCLOC1}/" "${SYNCLOC2}/"

echo "Continue actually syncing if the above dry run results look correct, otherwise press CTRL-C to cancel and investigate!"

read -p "Press enter to continue"

echo "Syncing ${SYNCLOC1}/ with ${SYNCLOC2}/"

echo "DELETIONS WILL NOT BE PROPOGATED, THIS IS ON PURPOSE TO PREVENT DATA CORRUPTION FROM PROPOGATING"
rsync --archive --verbose --stats --whole-file --progress --times --human-readable --log-file="${SYNCLOC1}/rsync.log" "${SYNCLOC1}/" "${SYNCLOC2}/"
