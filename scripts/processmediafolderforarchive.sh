#!/bin/bash

function processMediaFile {

    #PARAMETER 1: (Required) FILE
    if [[ -z "$1" ]]; then
        echo "function parameter 1: FILE is required, passed blank"
        return
    else
        FILE="$1"
    fi
    echo "FILE = ${FILE}"

    #PARAMETER 2: (Required) DESTINATION_FOLDER
    if [[ -z "$2" ]]; then
        echo "function parameter 2: DESTINATION_FOLDER is required, passed blank"
        return
    else
        DESTINATION_FOLDER="$2"
    fi
    echo "DESTINATION_FOLDER = ${DESTINATION_FOLDER}"

    filename=$(basename "$file")
    fname="${filename%.*}"
    ext="${filename##*.}"
    extcaps=${ext^^}
    echo "Processing $file with filename $filename, fname $fname, and ext $extcaps"

    case $extcaps in
        'JPG'|'JPEG'|'PNG')
            imageprocessforarchive.sh "$file" "$DESTINATION_FOLDER"
        ;;
        'MP4'|'MKV'|'MOV'|'WEBP'|'AVI')
            videoprocessforarchive.sh "$file" "$DESTINATION_FOLDER"
        ;;
        'GIF'|'JSON')
            echo "Recognized file type as copy only - not processing just copying over to $DESTINATION_FOLDER"
            mv "$file" "$DESTINATION_FOLDER"
        ;;
        *)
            echo "Unknown file type with ext $extcaps, skipping!"
        ;;
    esac
}


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

if [ ! -d "$1" ] 
then
    echo "Directory $1 DOES NOT exist." 
    exit 9999 # die with error code 9999
fi

if [ ! -d "$2" ] 
then
    echo "Directory $2 DOES NOT exist." 
    exit 9999 # die with error code 9999
fi

echo "First processing the files directly in $1"
for file in "$1"/*; do
    processMediaFile "$file" "$2"
done

echo "Next processing the files in each subfolder recursively flattening each down to just each subfolder with its own year folders"
ORIGINAL_FOLDER="$(pwd)"
pushd "$1"
find . -mindepth 1 -maxdepth 2 -type d | while read folder; do
    pushd "$folder"
    FOLDER_BASENAME="${PWD##*/}"
    echo "Processing subfolder $folder with FOLDER_BASENAME $FOLDER_BASENAME"
    find . -type f | while read file; do
        processMediaFile "$file" "$2/$FOLDER_BASENAME"
    done
    popd
done;
popd
