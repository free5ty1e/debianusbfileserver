#!/bin/bash

echo Applying package manager fixes...
sudo apt-get clean
sudo dpkg --configure -a
sudo apt-get -yf install

echo "Obtaining required packages / dependencies..."
sudo apt-get install -y git dialog ntfs-3g cowsay pv bc expect openssl parted gdisk rsync e2fsprogs
#joystick ntfs-3g cowsay imagemagick angband pv bc libssl-dev glib-networking expect openssl gdisk rsync

# installGoAndAnsize.sh
#libbluetooth3 bluez bluez-utils bluez-compat bluez-hcidump bluetooth wicd-curses
