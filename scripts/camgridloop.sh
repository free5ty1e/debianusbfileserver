#!/bin/bash

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi
screensaverdisable.sh
camgridstopframecaptures.sh
camgridstartframecaptures.sh
while [ 1 ]
# for i in {0..10}
do
	# echo "Generating frame $i of 10..."
	# camgridframe.sh
	camgridgenerateframe.sh
	camgriddisplayframe.sh
   	sleep 5
   # sudo killall fim
done