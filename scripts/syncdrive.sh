#!/bin/bash

EXCLUDEFILE="${HOME}/rsyncexclude.file"
echo "Exclude file is ${EXCLUDEFILE}"
PARAMATER_DRY_RUN="dryrun"
echo "PARAMATER_DRY_RUN is ${PARAMATER_DRY_RUN}"

usage_notes() {
	echo "USAGE: "
    echo "syncdrive.sh /media/VolumeOne /media/VolumeOneBak nodryrun excluded.fileOrFolder"
    echo "(nodryrun is optional and in fact can be most any word.  It must be 'dryrun' if you want to pass parameter 4 to exclude something)"
    echo "(excluded.fileOrFolder is an optional file or folder to exclude)"
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

echo "Constructing exclude file..."
rm -v "${EXCLUDEFILE}"
cat > "${EXCLUDEFILE}" << EOF
rsync.log
rsync.log.old
._*
.DS_Store
EOF

#If parameter 3 passed, if "dryrun" then do the dry run
if [[ $3 ]] ; then
	if [ $3 == $PARAMATER_DRY_RUN ]; then
		DRY_RUN=true
		echo "dryrun param detected, DRY_RUN is ${DRY_RUN}"
	else
		DRY_RUN=false
		echo "non-dryrun param detected, DRY_RUN is ${DRY_RUN}"
	fi
else
	DRY_RUN=true
	echo "no dryrun param detected, DRY_RUN is ${DRY_RUN}"
fi 


#If exclude parameter 4 passed, append to exclude file:
if [[ $4 ]] ; then
	echo "Appending $4 to exclude file ${EXCLUDEFILE}"
	echo "$4" >> "${EXCLUDEFILE}"
fi

#echo "Enforcing no-sleep USB policies..."
#sudo bash -c "for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 2 > $i; done"
#sudo bash -c "for foo in /sys/bus/usb/devices/*/power/level; do echo on > $foo; done"


if [ "$DRY_RUN" = true ] ; then
	echo "Performing dry run first to allow review of changes before proceeding"
	rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --dry-run --one-file-system --human-readable --exclude-from="${EXCLUDEFILE}" "${SYNCLOC1}/" "${SYNCLOC2}/"
	echo "Continue actually syncing if the above dry run results look correct, otherwise press CTRL-C to cancel and investigate!"
	read -p "Press enter to continue"
fi

echo "Backing up previous rsync logfile ${SYNCLOC1}/rsync.log and deleting the previous rolling backup ${SYNCLOC1}/rsync.log.old"
mv -vf "${SYNCLOC1}/rsync.log" "${SYNCLOC1}/rsync.log.old"

echo "Syncing ${SYNCLOC1}/ with ${SYNCLOC2}/"

echo "DELETIONS WILL NOT BE PROPOGATED, THIS IS ON PURPOSE TO PREVENT DATA CORRUPTION FROM PROPOGATING"
rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --one-file-system --human-readable --exclude-from="${EXCLUDEFILE}" --log-file="${SYNCLOC1}/rsync.log" "${SYNCLOC1}/" "${SYNCLOC2}/"

echo "Exclude file contents were:"
cat "${EXCLUDEFILE}"

rm -v "${EXCLUDEFILE}"
