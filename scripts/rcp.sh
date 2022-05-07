#!/bin/bash
echo "rsync cp: rsync --verbose --stats --whole-file --progress --human-readable $1 $2 $3 $4 $5 $6 $7 $8 $9"
rsync --verbose --stats --whole-file --progress --human-readable $1 $2 $3 $4 $5 $6 $7 $8 $9
