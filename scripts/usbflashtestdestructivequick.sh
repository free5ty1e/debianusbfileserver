#!/bin/bash

usage_notes() {
	echo "USAGE: (Warning -- will destroy data on flash drive to test it)"
    echo "usbflashtestdestructivequick.sh /dev/sda"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

USBFLASHDEVICE="$1"

sudo f3probe --destructive --time-ops $1
