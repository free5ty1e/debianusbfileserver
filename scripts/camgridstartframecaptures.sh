#!/bin/bash
. $HOME/.camgrid/camgrid.conf

for i in "${!RTSP_STREAM_URLS[@]}"; do 
	STREAM_URL=${RTSP_STREAM_URLS[$i]}
	STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
	echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $CAPTURE_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.jpg..."
	sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$STREAM_URL" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.jpg" </dev/null &
	export CAPTURE_STREAM_PID=$!
done

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!

