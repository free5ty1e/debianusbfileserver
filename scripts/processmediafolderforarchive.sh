#!/bin/bash

if [ -z "$1" ] ; then
    echo "First parameter (source media folder) not present, unable to continue."
    echo "Please provide source media folder as parameter 1 and target folder as parameter 2 and try again"
    exit 1
fi

if [ -z "$2" ] ; then
    echo "Second parameter (target media folder) not present, unable to continue."
    echo "Please provide source media folder as parameter 1 and target folder as parameter 2 and try again"
    exit 1
fi

echo "Processing media folder $1 for archival storage in location $2 under appropriate year folders, processing known media types"

shopt -s globstar
for file in "$1"/**/*; do
    filename=$(basename "$file")
    fname="${filename%.*}"
    ext="${filename##*.}"
    extcaps=${ext^^}
    echo "Processing $file with filename $filename, fname $fname, and ext $extcaps"

    case $extcaps in
        'JPG'|'JPEG'|'PNG')
            imageprocessforarchive.sh "$1" "$2"
        ;;
        'MP4'|'MKV'|'MOV'|'WEBP')
            videoprocessforarchive.sh "$1" "$2"
        ;;
        *)
            echo "Unknown file type with ext $extcaps, skipping!"
        ;;
    esac

done
