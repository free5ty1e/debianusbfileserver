#!/bin/bash

#fbi -T 1 -fitwidth -blend 500 /ramdisk/camgrid.jpg

#Below kinda works without xwindow installed, over sdl, but only a couple times in a row...
# /usr/bin/fim --vt =1 --device =/dev/fb0 --quiet --autowidth /ramdisk/camgrid.jpg &

# /usr/bin/fim --autowindow /ramdisk/camgrid.jpg

# sudo killall xloadimage
killall xloadimage || true
# xloadimage -display :0 -fullscreen /ramdisk/camgrid.jpg &
# xloadimage -display :0 -fullscreen /ramdisk/sphene.jpg /ramdisk/rupee.jpg &

# montage -label %f -background '#336699' -geometry +4+4 /ramdisk/sphene.jpg /ramdisk/rupee.jpg jpg:- | display -display :0 -foreground "#000000" -backdrop -window root jpg:-
#display -display :0 -foreground "#000000" -backdrop -window root jpg:-

# montage -label %f -background '#336699' -geometry +4+4 /ramdisk/sphene.jpg /ramdisk/rupee.jpg jpg:- | display -display :0 -backdrop -window root jpg:- &

#Updating wallpaper
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 4
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /ramdisk/camgrid.jpg
