#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivetestbadblocksrwnondestructive.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"
sudo badblocks -v -sn $WHICHDRIVE > /tmp/bad-blocks.txt 
