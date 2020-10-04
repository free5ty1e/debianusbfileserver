#!/bin/bash

echo "Customize a copy of this script to sync your own fileserver drive names"

syncmygamesdrive.sh

echo "Syncing data drive"
syncdrive.sh /media/MassiveSto8TbAyy /media/MassiveSto8TbBee nodryrun

syncmyplexdrive.sh
