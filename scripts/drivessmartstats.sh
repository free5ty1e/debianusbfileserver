#!/bin/bash

for file in /dev/sd*1
do
	echo "Reading SMART status of $file ---------------------------------------------------- $file -------------"
	drivesmartstats.sh "$file"
done
