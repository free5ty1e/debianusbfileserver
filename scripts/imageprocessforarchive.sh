#!/bin/bash

echo "Processing image $1 for archival for storage in location $2 under an appropriate year folder - if jpeg, optimizing and shrinking.  If not jpeg, just moving."
echo "(You should provide the first parameter as the image filename)"

yearfromfiletimestamp.sh "$1"
TARGET_FOLDER="$2/$YEAR_FROM_FILENAME"
echo "Year extracted from filename via script: $YEAR_FROM_FILENAME, creating location $TARGET_FOLDER if it does not already exist..."
mkdir -pv "$TARGET_FOLDER"

case $(file -b "$1") in
  'JPEG '*)
    echo "JPEG file $1 detected, proceeding with processing (optimize then shrink for best file size)..."
    imageoptimizejpeg.sh "$1" "optimized_$1"
    imageshrinktohd.sh "optimized_$1" "$TARGET_FOLDER/$1"
    rm "optimized_$1"
    #rm "$1"
    ;;
  *)
    echo "$1 is not a JPEG file, skipping the processing..."
    mv "$1" "$2"
    ;;
esac
