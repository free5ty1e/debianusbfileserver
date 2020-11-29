#!/bin/bash

INCLUDEFILE="${HOME}/rsyncinclude.file"
echo "Include file is located at ${INCLUDEFILE}"
PARAMETER_DRY_RUN="dryrun"
echo "PARAMETER_DRY_RUN is ${PARAMETER_DRY_RUN}"

usage_notes() {
	echo "USAGE: "
    echo "syncRetroPieSaves.sh /media/VolumeOne /media/VolumeOneBak nodryrun"
    echo "(nodryrun is optional and in fact can be most any word.  It must be 'dryrun' if you want to pass parameter 4 to exclude something)"
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

echo "Constructing include file..."
rm -v "${INCLUDEFILE}"
cat > "${INCLUDEFILE}" << EOF
*.srm
*.state*
*.dat
*.nv
*.hi
*.hs
*.cfg
*.fs
*.eep
EOF

#If parameter 3 passed, if "dryrun" then do the dry run
if [[ $3 ]] ; then
	if [ $3 == $PARAMETER_DRY_RUN ]; then
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


#echo "Enforcing no-sleep USB policies..."
#sudo bash -c "for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 2 > $i; done"
#sudo bash -c "for foo in /sys/bus/usb/devices/*/power/level; do echo on > $foo; done"

echo "Include file contents:"
cat "${INCLUDEFILE}"

if [ "$DRY_RUN" = true ] ; then
	echo "Performing dry run first to allow review of changes before proceeding"
	rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --dry-run --one-file-system --human-readable --exclude="*" --include-from="${INCLUDEFILE}" "${SYNCLOC1}/" "${SYNCLOC2}/"
	echo "Continue actually syncing if the above dry run results look correct, otherwise press CTRL-C to cancel and investigate!"
	read -p "Press enter to continue"
fi

echo "Backing up previous rsync logfile ${SYNCLOC1}/rsync.log and deleting the previous rolling backup ${SYNCLOC1}/rsync.log.old"
mv -vf "${SYNCLOC1}/rsync.log" "${SYNCLOC1}/rsync.log.old"

echo "Syncing ${SYNCLOC1}/ with ${SYNCLOC2}/"

echo "DELETIONS WILL NOT BE PROPOGATED, THIS IS ON PURPOSE TO PREVENT DATA CORRUPTION FROM PROPOGATING"
rsync --archive --verbose --stats --whole-file --progress --executability --fuzzy --one-file-system --human-readable --exclude="*" --include-from="${INCLUDEFILE}" --log-file="${SYNCLOC1}/rsync.log" "${SYNCLOC1}/" "${SYNCLOC2}/"

rm -v "${INCLUDEFILE}"
