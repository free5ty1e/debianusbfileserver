#!/bin/bash

echo "Processing video $1 for archival, for storage in location $2 under an appropriate year folder"
echo "(You should provide the first parameter as the filename)"

TEMP_OUTPUT_FILENAME="h265_$(basename $1)"
YEAR_FROM_FILENAME=$(yearfromfiletimestamp.sh "$1")
TARGET_FOLDER="$2/$YEAR_FROM_FILENAME"
echo "Year extracted from filename via script: $YEAR_FROM_FILENAME, creating location $TARGET_FOLDER if it does not already exist..."
mkdir -pv "$TARGET_FOLDER"

if videotoh265.sh "$1" "$TEMP_OUTPUT_FILENAME" 1920 34 ; then 
	mv "$TEMP_OUTPUT_FILENAME" "$TARGET_FOLDER/$(basename $1)"
	if test -f "$TARGET_FOLDER/$(basename $1)"; then
	    echo "Transcode appears to have succeeded and target file $TARGET_FOLDER/$(basename $1) exists.  Removing source file and temp file."
	    rm "$1"
	fi
fi
