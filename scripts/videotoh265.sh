#!/bin/bash

DEFAULT_LARGE_SIDE_MAX_PIXELS="1280"
if [ -z "$3" ] ; then
    LARGE_SIDE_MAX_PIXELS="$DEFAULT_LARGE_SIDE_MAX_PIXELS"
    echo "Third parameter (LARGE_SIDE_MAX_PIXELS) omitted, using default of $LARGE_SIDE_MAX_PIXELS"
else
    LARGE_SIDE_MAX_PIXELS="$3"
    echo "Third parameter (LARGE_SIDE_MAX_PIXELS) provided: $LARGE_SIDE_MAX_PIXELS"
fi

#CRF of 28 is default for h.265, +/- 6 should half/double the file size, max is 60ish?
DEFAULT_VIDEO_COMPRESSION_RATE_FACTOR="28"
if [ -z "$4" ] ; then
    VIDEO_COMPRESSION_RATE_FACTOR="$DEFAULT_LARGE_SIDE_MAX_PIXELS"
    echo "Fourth parameter (VIDEO_COMPRESSION_RATE_FACTOR) omitted, using default of $VIDEO_COMPRESSION_RATE_FACTOR"
else
    VIDEO_COMPRESSION_RATE_FACTOR="$4"
    echo "Fourth parameter (VIDEO_COMPRESSION_RATE_FACTOR) provided: $VIDEO_COMPRESSION_RATE_FACTOR"
fi

echo "Processing video $1 for archival transcoding to h.265 and downscaling to 720p with mp3 audio to output file $2"
echo "With a maximum large-side resolution of $LARGE_SIDE_MAX_PIXELS"
echo "(You should provide the first parameter as the filename and second as the target for output,"
echo "and the max large-side resolution as the third parameter or the default of 1280 will be used for a 720p output)"
echo "If a fourth parameter is included (you incluced $4), it will be used as the CRF.  Otherwise, the default of 28 will be used."
echo "If a fifth parameter is included (you included $5), 2-pass encoding will be used.  If the fifth parameter is"
echo "omitted, then 1-pass encoding will be used."
echo 
echo "If needed, sudo apt-get install ffmpeg"

if [ -z "$5" ] ; then
    echo "Fifth parameter omitted, using default of 1-pass encoding"
    ffmpeg -i "$1" -vcodec libx265 -crf "$VIDEO_COMPRESSION_RATE_FACTOR" -preset veryslow -c:a aac -b:a 128k -vf "scale=$LARGE_SIDE_MAX_PIXELS:$LARGE_SIDE_MAX_PIXELS:force_original_aspect_ratio=decrease" "$2"
else
    echo "Fifth parameter provided (is $5), using 2-pass encoding"
    ffmpeg -y -i "$1" -vcodec libx265 -crf "$VIDEO_COMPRESSION_RATE_FACTOR" -preset veryslow -x265-params pass=1 -an -f null /dev/null && \
    ffmpeg -i "$1" -vcodec libx265 -crf "$VIDEO_COMPRESSION_RATE_FACTOR" -preset veryslow -x265-params pass=2 -c:a aac -b:a 128k -vf "scale=$LARGE_SIDE_MAX_PIXELS:$LARGE_SIDE_MAX_PIXELS:force_original_aspect_ratio=decrease" "$2"
fi
