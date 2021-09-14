#!/bin/bash

lsusb

echo "First parameter should be the USB device (listed above) to reset, such as: "
echo "usbresetdevice.sh /dev/bus/usb/002/003"

if [ -z "$*" ] ; then
	echo "No parameters passed, cancelling!"
    exit 0
fi

sudo usbreset "$1"
