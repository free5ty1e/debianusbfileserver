#!/bin/bash

#Timeout is in microseconds, so 5,000,000 = 5 seconds
RTSP_TIMEOUT=5000000
CAPTURE_RESOLUTION="640x480"
CAPTURE_FPS="1/5"
RTSP_STREAM_URL_1="rtsp://sphene:mp3sheet@192.168.100.139/live"
RTSP_STREAM_URL_2="rtsp://rupee:mp3sheet@192.168.100.142/live"

sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_1" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream1.jpg </dev/null &
export CAPTURE_STREAM_PID_1=$!

sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
export CAPTURE_STREAM_PID_2=$!
