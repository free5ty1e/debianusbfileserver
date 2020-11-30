#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

echo "Syncing saved games from playable games drive to new games drive"
syncdrive.sh /media/PrimeGamesAyy/retropie-mount /media/PrimeGamesBee/retropie-mount-bak nodryrun
