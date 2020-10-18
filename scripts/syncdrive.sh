#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "syncdrive.sh /media/VolumeOne /media/VolumeOneBak nodryrun"
    echo "(nodryrun is optional and in fact can be most any word)"
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

if [ -z "$3" ] ; then
	echo "Performing dry run first to allow review of changes before proceeding"
	rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --dry-run --one-file-system --human-readable "${SYNCLOC1}/" "${SYNCLOC2}/"
	echo "Continue actually syncing if the above dry run results look correct, otherwise press CTRL-C to cancel and investigate!"
	read -p "Press enter to continue"
fi

echo "Backing up previous rsync logfile ${SYNCLOC1}/rsync.log and deleting the previous rolling backup ${SYNCLOC1}/rsync.log.old"
mv -vf "${SYNCLOC1}/rsync.log" "${SYNCLOC1}/rsync.log.old"

echo "Syncing ${SYNCLOC1}/ with ${SYNCLOC2}/"

echo "DELETIONS WILL NOT BE PROPOGATED, THIS IS ON PURPOSE TO PREVENT DATA CORRUPTION FROM PROPOGATING"
rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --one-file-system --human-readable --log-file="${SYNCLOC1}/rsync.log" "${SYNCLOC1}/" "${SYNCLOC2}/"
