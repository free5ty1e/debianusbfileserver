#!/bin/bash

BASEFOLDER="/media/MassiveSto8TbAyy"
processmediafolderforarchive.sh "$BASEFOLDER/SyncthingChrisAndroid/AndroidCamera" "$BASEFOLDER/SyncthingProcessed/ChrisMedia/AndroidCamera"
processmediafolderforarchive.sh "$BASEFOLDER/SyncthingChrisAndroid/PicturesFromApps" "$BASEFOLDER/SyncthingProcessed/ChrisMedia/PicturesFromApps"
processmediafolderforarchive.sh "$BASEFOLDER/Syncthing/CodiDox" "$BASEFOLDER/SyncthingProcessed/CodiMedia"
processmediafolderforarchive.sh "$BASEFOLDER/Syncthing/GooglePixel4aPhotos" "$BASEFOLDER/SyncthingProcessed/GooglePixel4aMedia"
