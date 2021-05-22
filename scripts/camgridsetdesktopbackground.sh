#!/bin/bash

xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 4
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /ramdisk/camgrid.jpg
