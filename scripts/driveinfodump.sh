#!/bin/bash

message="Initiating a drive info dump to assist in debugging mount issues..."
echo "$message"
cowsay -f eyes "$message"

echo "


----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

Listing all attached USB devices (lsusb)..."
lsusb

echo "
----------------------------------------------------------------------

Displaying blkid list..."
blkid

echo "
----------------------------------------------------------------------

Displaying the lsusb device tree..."
lsusb --tree


echo "
----------------------------------------------------------------------

List all storage devices assigned a filesystem id (ls)..."
ls -Gl /dev/sd*

echo "
----------------------------------------------------------------------

(as root), Locate and print block device attributes for all storage devices that were successfully assigned a device id (blkid)..."
sudo blkid /dev/sd*

echo "
----------------------------------------------------------------------

(as root), List all partition information (fdisk)..."
sudo fdisk -l

echo "
----------------------------------------------------------------------

Displaying the filesystem mounts and stats for them in human-readable format (df)..."
df -h 


echo "
----------------------------------------------------------------------

(as root), Locate and print all block device attributes, even storage devices that werent able to be assigned a device id (blkid)..."
sudo blkid -c /dev/null


echo "
----------------------------------------------------------------------




----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

"
