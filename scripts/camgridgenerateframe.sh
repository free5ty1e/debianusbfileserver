#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "Generating camgrid frame to filename given as first parameter : $1"

# ffmpeg -y -loglevel fatal -stimeout $RTSP_TIMEOUT -rtsp_transport tcp -i "rtsp://sphene:mp3sheet@192.168.100.139/live" -frames:v 2 -r 1 -s $CAPTURE_RESOLUTION /ramdisk/sphene.jpg
# ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://sphene:mp3sheet@192.168.100.139/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/sphene.bmp

# ffmpeg -y -loglevel fatal -stimeout $RTSP_TIMEOUT -rtsp_transport tcp -i "rtsp://rupee:mp3sheet@192.168.100.142/live" -frames:v 2 -r 1 -s $CAPTURE_RESOLUTION /ramdisk/rupee.jpg
# ffmpeg -y -loglevel fatal -rtsp_transport tcp -i "rtsp://rupee:mp3sheet@192.168.100.142/live" -frames:v 2 -r 1 -s 640x480 /ramdisk/rupee.bmp

sudo montage -label %f -background "$CAMGRID_BACKGROUND" -geometry "$CAMGRID_GEOMETRY" /ramdisk/rtspstream1.jpg /ramdisk/rtspstream2.jpg "$1"
# montage -label %f -background '#336699' -geometry +4+4 /ramdisk/sphene.bmp /ramdisk/rupee.bmp /ramdisk/camgrid.bmp
