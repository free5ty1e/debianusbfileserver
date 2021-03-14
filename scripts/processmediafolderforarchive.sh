#!/bin/bash



#TODO: If we are in a subfolder tree, we want to reproduce that subfolder tree within the target year folder  (such as Reddit, Instagram, Facebook, etc)





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
            imageprocessforarchive.sh "$file" "$2"
        ;;
        'MP4'|'MKV'|'MOV'|'WEBP'|'AVI')
            videoprocessforarchive.sh "$file" "$2"
        ;;
        'GIF')
            echo "GIF detected, may be animated, not processing just copying over to $2"
            mv "$file" "$2"
        *)
            echo "Unknown file type with ext $extcaps, skipping!"
        ;;
    esac

done
