#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

# echo "Syncing media, games, cphotos..."
# syncdrive.sh /media/PiMassive14TbAyy /media/PiMassive14TbBee nodryrun Syncthing SyncthingChrisAndroid plexdata retropie-mount
syncmydatadrive.sh

read -p "Next, syncing games to backup folder.  Press enter to continue"
# syncdrive.sh /media/PiMassive14TbAyy/retropie-mount /media/PiMassive14TbBee/retropie-mount-bak nodryrun
syncmygamesdrive.sh

read -p "Next, will sync plex database - this is very lengthy and usually unnecessary.  Press enter to continue, CTRL-C to cancel."
# syncdrive.sh /media/PiMassive14TbAyy/plexdata /media/PiMassive14TbBee/plexdata nodryrun
syncmyplexdatabase.sh
