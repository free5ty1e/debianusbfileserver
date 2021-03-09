#!/bin/bash

echo "Extracting year from filename $1 timestamp... (Provide filename as parameter #1)"
YEAR_FROM_FILENAME=$(echo "$1" | grep -o -m1 '[0-9]\{4\}' | awk 'NR==1')
echo "Year extracted: $YEAR_FROM_FILENAME"
