#!/bin/bash

message="Initiating a drive info dump to assist in debugging mount issues..."
echo "$message"
cowsay -f eyes "$message"

echo "----------------------------------------------------------------------\n\nListing all attached USB devices (lsusb)..."
lsusb

echo "\n\n(as root), Locate and print all block device attributes, even storage devices that werent able to be assigned a device id (blkid)..."
sudo blkid -c /dev/null

echo "\n\nList all storage devices assigned a filesystem id (ls)..."
ls -Gl /dev/sd*

echo "\n\n(as root), Locate and print block device attributes for all storage devices that were successfully assigned a device id (blkid)..."
sudo blkid /dev/sd*

echo "\n\nDisplaying the filesystem mounts and stats for them in human-readable format (df)..."
df -h 

echo "----------------------------------------------------------------------\n\n"
