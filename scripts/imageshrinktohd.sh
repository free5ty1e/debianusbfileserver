#!/bin/bash

echo "Resizing image $1 to HD as $2.  If needed, sudo apt-get install imagemagick"
convert "$1" -resize 1920x1920\> "$2"
