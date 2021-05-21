#!/bin/bash

screensaverdisable.sh
# while [ 1 ]
for i in {0..10}
do
	echo "Generating frame $i of 10..."
	camgridframe.sh
   	sleep 1
   # sudo killall fim
done
