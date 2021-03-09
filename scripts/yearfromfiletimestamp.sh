#!/bin/bash
echo "$1" | grep -o -m1 '[0-9]\{4\}' | awk 'NR==1'
