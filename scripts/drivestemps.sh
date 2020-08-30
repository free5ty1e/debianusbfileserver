#!/bin/bash

for file in /dev/sd*1
do
	echo "Reading temperature of $file ---------------------------------------------------- $file -------------"
	drivetemp.sh "$file"
done
