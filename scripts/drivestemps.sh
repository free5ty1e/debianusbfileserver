#!/bin/bash

for file in /dev/sd*
do
	drivetemp.sh "$file"
done
