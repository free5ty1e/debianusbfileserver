#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivetemp.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"

sudo smartctl -A $WHICHDRIVE | grep -i Temperature
sudo smartctl -d sat -A $WHICHDRIVE | grep -i Temperature
