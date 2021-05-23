#!/bin/bash

SECONDS_BETWEEN_DISPLAY_FRAMES=5

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi
camgridstopframecaptures.sh
camgridstartframecaptures.sh
sleep 10
camgridgenerateframe.sh /ramdisk/camgrid_a.jpg
camgridsetdesktopbackground.sh /ramdisk/camgrid_a.jpg
screensaverdisable.sh
while [ 1 ]
# for i in {0..10}
do
	# echo "Generating frame $i of 10..."
	# camgridframe.sh
	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
	camgridgenerateframe.sh /ramdisk/camgrid_b.jpg
	camgridsetdesktopbackground.sh /ramdisk/camgrid_b.jpg
	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
	camgridgenerateframe.sh /ramdisk/camgrid_a.jpg
	camgridsetdesktopbackground.sh /ramdisk/camgrid_a.jpg	
	screensaverdisable.sh
	# camgriddisplayframe.sh
   # sudo killall fim
done
