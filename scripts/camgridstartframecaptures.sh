#!/bin/bash

#Timeout is in microseconds, so 5,000,000 = 5 seconds
RTSP_TIMEOUT=5000000
CAPTURE_RESOLUTION="640x480"

sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "rtsp://sphene:mp3sheet@192.168.100.139/live" -vf fps=fps=1/5 -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/sphene.jpg </dev/null &
export CAPTURE_SPHENE_PID=$!

sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "rtsp://rupee:mp3sheet@192.168.100.142/live" -vf fps=fps=1/5 -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rupee.jpg </dev/null &
export CAPTURE_RUPEE_PID=$!
