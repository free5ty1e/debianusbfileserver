#!/bin/bash

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((upSeconds%60))
mins=$((upSeconds/60%60))
hours=$((upSeconds/3600%24))
days=$((upSeconds/86400))
UPTIME=$(printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs")

echo "$(date +"%A, %e %B %Y, %X")"
echo "$(uname -srmo)"
echo
echo "Uptime.............: ${UPTIME}"
echo "Memory.............: $(grep MemFree /proc/meminfo | awk {'print $2'})kB (Free) / $(grep MemTotal /proc/meminfo | awk {'print $2'})kB (Total)"
echo "Running Processes..: $(ps ax | wc -l | tr -d " ")"
