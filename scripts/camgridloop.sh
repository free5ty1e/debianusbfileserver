#!/bin/bash

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi
camgridstopframecaptures.sh
camgridstartframecaptures.sh
sleep 10
camgridgenerateframe.sh
camgridsetdesktopbackground.sh
screensaverdisable.sh
while [ 1 ]
# for i in {0..10}
do
	# echo "Generating frame $i of 10..."
	# camgridframe.sh
	sleep 5
	camgridgenerateframe.sh
	screensaverdisable.sh
	# camgriddisplayframe.sh
   # sudo killall fim
done
