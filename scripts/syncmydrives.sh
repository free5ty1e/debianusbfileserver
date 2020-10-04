#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

echo "Syncing data drive"
syncdrive.sh /media/MassiveSto8TbAyy /media/MassiveSto8TbBee nodryrun

echo "Syncing new games to playable games drive"
syncdrive.sh /media/PrimeGamesBee/retropie-mount-bak /home/pi/RetroPie nodryrun

echo "Syncing saved games from playable games drive to new games drive"
syncdrive.sh /home/pi/RetroPie /media/PrimeGamesBee/retropie-mount-bak nodryrun

syncmyplexdrive.sh
