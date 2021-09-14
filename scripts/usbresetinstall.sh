#!/bin/bash

#https://raspberrypi.stackexchange.com/questions/9264/how-do-i-reset-a-usb-device-using-a-script

wget -c --no-check-certificate https://gist.githubusercontent.com/x2q/5124616/raw/3f6e5f144efab2bc8e9d02b95b8301e1e0eab669/usbreset.c -O usbreset.c
cc usbreset.c -o usbreset
chmod +x usbreset
sudo cp -vf usbreset /usr/local/bin/
