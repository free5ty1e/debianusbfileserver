#!/bin/bash
echo "rsync cp: rsync --verbose --stats --whole-file --progress --human-readable \"$1\" \"$2\""
rsync --verbose --stats --whole-file --progress --human-readable "$1" "$2"
