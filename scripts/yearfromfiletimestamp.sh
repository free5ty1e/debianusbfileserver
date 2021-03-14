#!/bin/bash
TIMESTAMP_YEAR=$(echo "$1" | grep -o -m1 '[0-9]\{4\}' | awk 'NR==1')
if [ -z "$TIMESTAMP_YEAR" ] ; then
    TIMESTAMP_YEAR=$(stat -c %.4y "$1")
fi
echo "$TIMESTAMP_YEAR"
