#!/bin/bash

echo "Automounting all USB drives by volume name / label..."
for dev in $(ls -1 /dev/disk/by-label/* | grep -v EFI) ; do
  label=$(basename $dev)
  mkdir -p /media/$label
  $(mount | grep -q /media/$label) || mount $dev /media/$label
done
