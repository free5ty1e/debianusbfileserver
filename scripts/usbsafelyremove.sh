#!/bin/bash
set -e

# Ensure a device argument is provided
if [ -z "$1" ]; then
    echo "Error: No device specified." >&2
    echo "Usage: $0 /dev/sdX" >&2
    exit 1
fi

DEVICE_PATH="$1"
DEVICE_NAME=$(basename "$DEVICE_PATH")

echo "Safely removing device $DEVICE_PATH..."

# Find all mounted partitions belonging to this device block
MOUNTED_PARTITIONS=$(awk -v dev="$DEVICE_NAME" '$1 ~ "^/dev/"dev"[0-9]+$" {print $2}' /proc/mounts)

if [ -n "$MOUNTED_PARTITIONS" ]; then
    echo "Found active mounts for $DEVICE_PATH. Unmounting..."
    while IFS= read -r mount_point; do
        if [ -n "$mount_point" ]; then
            echo "Unmounting: $mount_point"
            sudo umount "$mount_point"
        fi
    done <<< "$MOUNTED_PARTITIONS"
else
    echo "No active mounts found for $DEVICE_PATH."
fi

# Sync filesystem buffers before powering down
sync

# Power off the device cleanly via udisksctl, fallback to sysfs power/control if udisks objects fail
if ! sudo udisksctl power-off -b "$DEVICE_PATH"; then
    echo "udisksctl failed, attempting kernel sysfs power-off..."
    if [ -d "/sys/block/$DEVICE_NAME/device" ]; then
        echo "1" | sudo tee /sys/block/$DEVICE_NAME/device/delete > /dev/null
    fi
fi

echo "$DEVICE_PATH has been powered off successfully."
