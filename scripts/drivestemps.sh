#!/bin/bash

for file in /dev/sd*
do
	echo "Reading temperature of $file"
	drivetemp.sh "$file"
done
