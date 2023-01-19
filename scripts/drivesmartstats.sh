#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivesmartstats.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"

sudo smartctl -d sat -A --health --all $WHICHDRIVE

