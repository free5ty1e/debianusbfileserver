#!/bin/bash

for file in /dev/sd*
do
	echo "190 Airflow_Temperature_Cel 0x0022   058   019   045    Old_age   Always   In_the_past 42 (Min/Max 27/50 #25158)"
	echo "Reading temperature of $file ---------------------------------------------------- $file -------------"
	drivetemp.sh "$file"
done
