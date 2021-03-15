#!/bin/bash

echo "Processing image $1 for archival storage in location $2 under an appropriate year folder - if jpeg, optimizing and shrinking.  If not jpeg, just moving."
echo "(You should provide the first parameter as the image filename)"

TEMP_OPTIMIZED_FILENAME="optimized_temp.jpg"
YEAR_FROM_FILENAME=$(yearfromfiletimestamp.sh "$1")
TARGET_FOLDER="$2/$YEAR_FROM_FILENAME"
echo "Year extracted from filename via script: $YEAR_FROM_FILENAME, creating location $TARGET_FOLDER if it does not already exist..."
mkdir -pv "$TARGET_FOLDER"

case $(file -b "$1") in
  'JPEG '*)
    echo "JPEG file $1 detected, proceeding with processing (optimize then shrink for best file size)..."
    imageoptimizejpeg.sh "$1" "$TEMP_OPTIMIZED_FILENAME"
    if imageshrinktohd.sh "$TEMP_OPTIMIZED_FILENAME" "$TARGET_FOLDER/$(basename $1)" ; then 
		if test -f "$TARGET_FOLDER/$(basename $1)"; then
		    echo "Image processing appears to have succeeded and target file $TARGET_FOLDER/$(basename $1) exists.  Removing source file."
		    rm "$1"
		    rm "$TEMP_OPTIMIZED_FILENAME"
		fi
	fi
    ;;
  *)
    echo "$1 is not a JPEG file, skipping the processing and going straight to shrinking..."
    if imageshrinktohd.sh "$1" "$TARGET_FOLDER/$(basename $1)" ; then 
		if test -f "$TARGET_FOLDER/$(basename $1)"; then
		    echo "Image processing appears to have succeeded and target file $TARGET_FOLDER/$(basename $1) exists.  Removing source file."
		    rm "$1"
		fi
	fi
    ;;
esac
