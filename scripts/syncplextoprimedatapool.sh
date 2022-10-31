#!/bin/bash

echo "Customize a copy of this script to sync your own plex fileserver drive names"

echo "Syncing Plex media drive, excluding Plex database"

syncdrive.sh /media/Media8TbAyye /media/PrimeDataPool/FileSrvMedia nodryrun plexdata
