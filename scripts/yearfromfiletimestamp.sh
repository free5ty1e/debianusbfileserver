#!/bin/bash

regex='[0-9]{8}'
if [[ $1 =~ $regex ]]; then
    echo "File $1 has a timestamp in the filename, extracting year from timestamp"
    TIMESTAMP_YEAR=$(echo "$1" | grep -o -m1 '[0-9]\{4\}' | awk 'NR==1')
else
    echo "File $1 does not have a timestamp in the filename, extracting year from creation date"
    TIMESTAMP_YEAR=$(stat -c %.4y "$1")
fi
echo "$TIMESTAMP_YEAR"
