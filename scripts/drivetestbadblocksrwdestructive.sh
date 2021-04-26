#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivetestbadblocksrwdestructive.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"
sudo badblocks -v -sw $WHICHDRIVE > /tmp/bad-blocks.txt 
