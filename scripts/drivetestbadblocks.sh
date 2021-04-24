#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivetestbadblocks.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"
sudo badblocks -v $WHICHDRIVE > /tmp/bad-blocks.txt 
