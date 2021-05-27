#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi
CAMGRIDFILEA="/ramdisk/camgrid_a.$CAPTURE_FORMAT"
CAMGRIDFILEB="/ramdisk/camgrid_b.$CAPTURE_FORMAT"
echo "Camgrid filenames are $CAMGRIDFILEA and $CAMGRIDFILEB"

camgridstopframecaptures.sh
camgridstartframecaptures.sh
sleep 10
camgridgenerateframe.sh "$CAMGRIDFILEA"
camgridsetdesktopbackground.sh "$CAMGRIDFILEA"
screensaverdisable.sh
while [ 1 ]
# for i in {0..10}
do
	# echo "Generating frame $i of 10..."
	# camgridframe.sh
	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
	camgridgenerateframe.sh "$CAMGRIDFILEB"
	camgridsetdesktopbackground.sh "$CAMGRIDFILEB"
	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
	camgridgenerateframe.sh "$CAMGRIDFILEA"
	camgridsetdesktopbackground.sh "$CAMGRIDFILEA"
	screensaverdisable.sh
	# camgriddisplayframe.sh
   # sudo killall fim
done





##NEW LOOP:

# inotifywait --quiet --event close_write,moved_to,create --monitor /ramdisk |
# while read -r directory events filename; do
  
# 	for i in "${!RTSP_STREAM_TITLES[@]}"; do 
# 		STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
# 		if [ "$filename" == "$STREAM_TITLE.jpg" ]; then
    		

# 			#TODO: Need script that can tell which camgrid_a or _b was last generated, and generate the other one each cycle here and set it as the desktop background:



#   		fi

# 	done

# done
