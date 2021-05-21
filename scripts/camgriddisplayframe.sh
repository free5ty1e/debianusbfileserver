#!/bin/bash

#fbi -T 1 -fitwidth -blend 500 /ramdisk/camgrid.jpg

#Below kinda works without xwindow installed, over sdl, but only a couple times in a row...
# /usr/bin/fim --vt =1 --device =/dev/fb0 --quiet --autowidth /ramdisk/camgrid.jpg &

# /usr/bin/fim --autowindow /ramdisk/camgrid.jpg

xloadimage display 0.0 fullscreen foreground /ramdisk/camgrid.jpg &
