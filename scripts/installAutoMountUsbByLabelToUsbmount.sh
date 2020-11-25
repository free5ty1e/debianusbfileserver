#!/bin/bash

echo "Enhancing usbmount to also symlink drives by label in /media/"
# sudo mkdir -vp /etc/usbmount/mount.d
# sudo mkdir -vp /etc/usbmount/umount.d
sudo cp -vr etc/* /etc/
sudo chmod +x /etc/usbmount/mount.d/*
sudo chmod +x /etc/usbmount/umount.d/*
