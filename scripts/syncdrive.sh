#!/bin/bash

echo "Enforcing no-sleep USB policies..."
sudo bash -c "for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 2 > $i; done"
sudo bash -c "for foo in /sys/bus/usb/devices/*/power/level; do echo on > $foo; done"


echo "DELETIONS WILL NOT BE PROPOGATED, THIS IS ON PURPOSE TO PREVENT DATA CORRUPTION FROM PROPOGATING"
echo "If desired just add the --whole-file flag again"
rsync -av --stats --whole-file --progress --log-file=rsyncmedia4tb.log /media/Media4TbAyy/ /media/Media4TbBee/

