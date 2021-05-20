#!/bin/bash

# ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://sphene:mp3sheet@192.168.100.139/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/sphene.jpg
ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://sphene:mp3sheet@192.168.100.139/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/sphene.bmp

# ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://rupee:mp3sheet@192.168.100.142/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/rupee.jpg
ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://rupee:mp3sheet@192.168.100.142/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/rupee.bmp

# montage -label %f -background '#336699' -geometry +4+4 /ramdisk/sphene.jpg /ramdisk/rupee.jpg /ramdisk/camgrid.jpg
montage -label %f -background '#336699' -geometry +4+4 /ramdisk/sphene.bmp /ramdisk/rupee.bmp /ramdisk/camgrid.bmp

#fbi -T 1 -fitwidth -blend 500 /ramdisk/camgrid.jpg
sudo killall fim
/usr/bin/fim -T 1 --autowidth /ramdisk/camgrid.bmp &
