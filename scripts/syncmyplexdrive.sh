#!/bin/bash

echo "Customize a copy of this script to sync your own plex fileserver drive names"


echo "Syncing Plex media drive and archived Plex database"
rm -rf /media/Media8TbBeee/plexdata
pushd /media/Media8TbAyye
7z plexdata
mv plexdata.7z plexmediaserver_plexdata_bak.7z
popd
syncdrive.sh /media/Media8TbAyye /media/Media8TbBeee nodryrun 'plexdata'
