#!/bin/bash

if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

echo "Attempting to fix journal of %1... (you should pass /dev/sdX# device to this script if you did not...)"
tune2sf -O ^has_journal "%1"
e2fsck -f "%1"
tune2sf -j "%1"

# installGoAndAnsize.sh
