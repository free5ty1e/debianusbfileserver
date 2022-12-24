#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

# echo "Syncing data drive"
# syncdrive.sh /media/MassiveSto8TbAyy /media/MassiveSto8TbBee nodryrun Syncthing SyncthingChrisAndroid
echo "Syncing media, games, cphotos..."
syncdrive.sh /media/PiMassive14TbAyy /media/PiMassive14TbBee nodryrun Syncthing SyncthingChrisAndroid plexdata retropie-mount
