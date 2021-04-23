#!/bin/bash

#If parameter 1 passed, set as BASEFOLDER.  Otherwise, use default
if [[ $1 ]] ; then
    echo "Parameter 1 passed for BASEFOLDER: $1"
    BASEFOLDER="$1"
else
    BASEFOLDER="/media/MassiveSto8TbAyy"
fi 
echo "BASEFOLDER is $BASEFOLDER"

processmediafolderforarchive.sh "$BASEFOLDER/SyncthingChrisAndroid/AndroidCamera" "$BASEFOLDER/SyncthingProcessed/ChrisMedia/AndroidCamera"
processmediafolderforarchive.sh "$BASEFOLDER/SyncthingChrisAndroid/PicturesFromApps" "$BASEFOLDER/SyncthingProcessed/ChrisMedia/PicturesFromApps"
processmediafolderforarchive.sh "$BASEFOLDER/Syncthing/CodiDoxBackupSync" "$BASEFOLDER/SyncthingProcessed/CodiMedia"
processmediafolderforarchive.sh "$BASEFOLDER/Syncthing/GooglePixel4aPhotos" "$BASEFOLDER/SyncthingProcessed/GooglePixel4aMedia"
    