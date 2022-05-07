#!/bin/bash

message="Initiating a drive speed test for $1 (you did provide a drive device name such as /dev/sda, didn't you?) ..."
echo "$message"
cowsay -f eyes "$message"

echo "rsync cp: rsync --verbose --stats --whole-file --progress --human-readable \"$1\" \"$2\""

rsync --verbose --stats --whole-file --progress --human-readable "$1" "$2"
