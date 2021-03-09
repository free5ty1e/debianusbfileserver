#!/bin/bash

echo "Processing image $1 for archival as $2 - if jpeg, optimizing and shrinking.  If not jpeg, just moving."

case $(file -b "$1") in
  'JPEG '*)
    echo "JPEG file $1 detected, proceeding with processing (optimize then shrink for best file size)..."
    imageoptimizejpeg.sh "$1" "optimized_$1"
    imageshrinktohd.sh "optimized_$1" "$2"
    rm "optimized_$1"
    ;;
  *)
    echo "$1 is not a JPEG file, skipping the processing..."
    mv "$1" "$2"
    ;;
esac
