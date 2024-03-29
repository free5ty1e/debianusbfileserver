#!/bin/bash
### BEGIN INIT INFO
# Provides: omxplayer
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Displays camera feeds for monitoring
# Description:
### END INIT INFO

#From https://community.spiceworks.com/how_to/123787-raspberry-pi-powered-surveillance-camera-monitoring-display

# Camera Feeds & Positions
top_left="screen -dmS top_left sh -c 'omxplayer --win \"0 21 640 501\" rtsp://sphene:mp3sheet@192.168.100.139/live -b --live '";
top_right="screen -dmS top_right sh -c 'omxplayer --win \"640 21 1280 501\" rtsp://rupee:mp3sheet@192.168.100.142/live --live'";
#bottom_left="screen -dmS bottom_left sh -c 'omxplayer --win \"0 522 640 1002\" rtsp:// <...cam3_url...>  --live'";
#bottom_right="screen -dmS bottom_right sh -c 'omxplayer --win \"640 522 1280 1002\" rtsp:// <...cam4_url...>  --live'";

# Camera Feed Names
# (variable names from above, separated by a space)
camera_feeds=(top_left top_right)
# bottom_left bottom_right)

#---- There should be no need to edit anything below this line ----

# Start displaying camera feeds
case "$1" in
start)
for i in "${camera_feeds[@]}"
    do
        eval eval '$'$i
done
echo "Camera Display Started"
;;

# Stop displaying camera feeds
stop)
    sudo killall omxplayer.bin
    echo "Camera Display Ended"
;;

# Restart any camera feeds that have died
repair)
for i in "${camera_feeds[@]}"
do
    if !(screen -list | grep -q $i)
    then
        eval eval '$'$i
        echo "$i is now running"
    fi
done
;;

*)
echo "Usage: /etc/init.d/displaycameras {start|stop|repair}"
exit 1

;;
esac

