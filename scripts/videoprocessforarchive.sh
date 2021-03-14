#!/bin/bash

echo "Processing video $1 for archival, for storage in location $2 under an appropriate year folder"
echo "(You should provide the first parameter as the filename)"

YEAR_FROM_FILENAME=$(yearfromfiletimestamp.sh "$1")
TARGET_FOLDER="$2/$YEAR_FROM_FILENAME"
echo "Year extracted from filename via script: $YEAR_FROM_FILENAME, creating location $TARGET_FOLDER if it does not already exist..."
mkdir -pv "$TARGET_FOLDER"

if videotoh265.sh "$1" "$TARGET_FOLDER/$1" 1920 34 ; then 
	if test -f "$TARGET_FOLDER/$1"; then
	    echo "Transcode appears to have succeeded and target file $TARGET_FOLDER/$1 exists.  Removing source file."
	    #rm "$1"
	fi
fi
