#!/bin/bash

echo "Processing video $1 for archival transcoding to h.265 and downscaling to 720p with mp3 audio to output file $2"
echo "(You should provide the first parameter as the filename and second as the target for output)"

#1-pass, 720p, veryslow, mp3 audio defaults
#ffmpeg -i "$1" -vcodec libx265 -crf 28 -preset veryslow -acodec libmp3lame -vf 'scale=1280:1280:force_original_aspect_ratio=decrease' "$2"

#1-pass, 720p, veryslow, audio default
ffmpeg -i "$1" -vcodec libx265 -crf 28 -preset veryslow -vf 'scale=1280:1280:force_original_aspect_ratio=decrease' "$2"

