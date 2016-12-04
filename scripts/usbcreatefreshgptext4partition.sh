#!/bin/bash

usage_notes() {
    echo "You must first provide a drive to destroy and process for this script."
    echo "You must then also provide a volume label to continue, for example: "
    echo "usbcreatefreshgptext4partition.sh /dev/sdb labelForNewVolume"
}


if [[ ! $(whoami) =~ "root" ]]; then
	echo ""
	echo "**********************************"
	echo "*** This should be run as root ***"
	echo "**********************************"
	echo ""
	exit
fi

ls -Gl /dev/sd*
df -h

if [ -z "$*" ] ; then
	usage_notes
    exit 0
fi

if [ -z "$2" ] ; then
	usage_notes
    exit 0
fi

WHICHDRIVE="$1"
VOLUMELABEL="$2"

read -p "Press any key to continue -- DO NOT RUN THIS IF YOU CARE ABOUT THE DATA ON DRIVE $WHICHDRIVE CUZ IM BOUT TO DESTROY IT ALL!!! :O -- CTRL-C to cancel... " -n1 -s

cowsay -f eyes "Completely destroying and creating full-size ext4 gpt partition on $WHICHDRIVE and label it $VOLUMELABEL..."

echo "Unmounting USB drive, which can be mounted twice in some cases..."
umount "$WHICHDRIVE"
umount "$WHICHDRIVE"

echo "Installing gdisk to handle GUID partition table initialization..."
apt-get -y install gdisk rsync smartmontools

echo "Zapping existing MBR and GPT partition tables on USB drive..."
sgdisk -Z "$WHICHDRIVE"

echo "Creating new largest possible primary partition on USB drive..."
sgdisk --largest-new=1 "$WHICHDRIVE"

usbRootPartGuid=$(sudo sgdisk -i=1 "$WHICHDRIVE" | grep "Partition unique GUID:" | awk '{print $4}')
echo "USB rootfs partition 1 GUID retrieved: $usbRootPartGuid"
VOLUMEDEVICE="${WHICHDRIVE}1"
echo "USB partition 1 device name retrieved: $VOLUMEDEVICE"

echo "Running partprobe on this device to ensure the kernel has the updated partition table in memory before continuing..."
partprobe "$WHICHDRIVE"



# echo Here is where we need to set the /boot/cmdline.txt to point to root=PARTUUID=partitionguidhere along with rootdelay=5 at the end...
# echo "Replacing GUID placeholder in new /boot/cmdline.txt with GUID $usbRootPartGuid..."
# sed "s/\${partitionguid}/$usbRootPartGuid/" /home/pi/primestationone/reference/boot/cmdlineForGuidUsb.txt > /home/pi/cmdline.txt
# cp /boot/cmdline.txt /boot/cmdline.txt.bak
# rm /boot/cmdline.txt
# cp /home/pi/cmdline.txt /boot/cmdline.txt
# rm /home/pi/cmdline.txt

echo "Ensuring USB drive is unmounted again..."
umount "$VOLUMEDEVICE"
umount "$VOLUMEDEVICE"

echo "Now continuing with ext4 filesystem setup and formatting..."
# mke2fs -t ext4 "$VOLUMEDEVICE"
mkfs.ext4 -m 0 -L "$VOLUMELABEL" "$VOLUMEDEVICE"

echo "Checking new filesystem...press enter to auto fix any issues that you are prompted for..."
# e2fsck -f "$VOLUMEDEVICE"
fsck.ext4 -fpv "$VOLUMEDEVICE"

#echo "Labelling new filesystem volume $VOLUMEDEVICE with label $VOLUMELABEL..."
# e2label "$VOLUMEDEVICE" "$VOLUMELABEL"
#echo Now going to auto expand your USB filesystem to fill the drive.  If you want to manually manage your partitions, or do not want to resize at this time, hit CTRL-C to cancel.
#echo This is the last step before a reboot, so just reboot to finish if you skip this next step.
#usbSda1ExpandFilesystem.sh

df -h

read -p "Must reboot for kernel to pick up new partition table!!  Press any key to continue rebooting... " -n1 -s
restart
