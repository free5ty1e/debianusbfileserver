#!/bin/bash

usage_notes() {
	echo "USAGE: "
    echo "drivetestshortcaptive.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"

sudo smartctl --test=short --captive --device=sat $WHICHDRIVE
