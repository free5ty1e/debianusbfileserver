#!/bin/bash

sudo apt install -y --no-install-recommends xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage fbi fim imagemagick ffmpeg vlc omxplayer

echo "Next you should configure the Pi to auto login into desktop so xwindow is active and ready for the camgrid..."
read -rsp $'Press any key to continue...\n' -n1 key

sudo raspi-config
