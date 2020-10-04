#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

echo "Syncing new games to playable games drive"
syncdrive.sh /media/PrimeGamesBee/retropie-mount-bak /media/usb0/retropie-mount nodryrun

echo "Syncing saved games from playable games drive to new games drive"
syncdrive.sh /media/usb0/retropie-mount /media/PrimeGamesBee/retropie-mount-bak nodryrun
