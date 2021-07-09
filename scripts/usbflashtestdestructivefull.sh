#!/bin/bash

usage_notes() {
	echo "USAGE: (Warning -- will destroy data on flash drive to test it)"
    echo "usbflashtestdestructivefull.sh /media/usb0"
}

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

USBFLASHMOUNTFOLDER="$1"

echo "Writing dummy files to fill USB flash..."
f3write "$1"

echo "Attempting to read back dummy files from USB flash..."
f3read "$1"

usbflashtestdestructivequick.sh
