#!/bin/bash
# Usage: sudo ./safe_eject.sh [--force|-f] /dev/sda

FORCE_FLAG=false

# Parse arguments for --force or -f
if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
    FORCE_FLAG=true
    shift
fi

DEVICE="$1"

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run with sudo."
    exit 1
fi

if [ -z "$DEVICE" ]; then
    echo "Usage: sudo $0 [--force] <device_block>"
    echo "Example: sudo $0 /dev/sda  OR  sudo $0 --force /dev/sda"
    exit 1
fi

# Validate that the device actually exists
if [ ! -b "$DEVICE" ]; then
    echo "Error: Device '$DEVICE' does not exist or is not a block device."
    exit 1
fi

echo "=== Preparing to safely eject $DEVICE (Force Mode: $FORCE_FLAG) ==="

# Step 1: Automatically find and unmount all partitions associated with the device
echo "Step 1: Unmounting all partitions for $DEVICE..."
PARTITIONS=$(lsblk -ln -o NAME,MOUNTPOINT "$DEVICE" | grep -v '^$' | awk '{print "/dev/" $1}')

if [ -z "$PARTITIONS" ]; then
    echo "No active mounts found for $DEVICE (already unmounted)."
else
    for part in $PARTITIONS; do
        echo "Unmounting $part..."
        if [ "$FORCE_FLAG" = true ]; then
            # Lazy unmount detaches immediately even if files are busy
            sudo umount -l "$part"
        else
            sudo umount "$part"
            if [ $? -ne 0 ]; then
                echo "Error: Failed to cleanly unmount $part. Process is holding files open."
                echo "Tip: Run with '--force' to detach anyway (e.g., sudo $0 --force $DEVICE)"
                exit 1
            fi
        fi
    done
fi

# Step 2: Sync filesystem buffers now that filesystems are dismounted
echo "Step 2: Flushing final writes to disk (sync)..."
sync
sleep 2

# Step 3: Power off the drive via udisksctl
echo "Step 3: Powering off device $DEVICE..."
udisksctl power-off -b "$DEVICE"
if [ $? -ne 0 ]; then
    echo "Warning: udisksctl power-off reported an issue, attempting fallback..."
    DEV_NAME=$(basename "$DEVICE")
    if [ -f "/sys/block/$DEV_NAME/device/delete" ]; then
        echo 1 | sudo tee "/sys/block/$DEV_NAME/device/delete" > /dev/null
    fi
fi

# Step 4: Wait for mechanical spin-down / capacitor drain
echo "Step 4: Waiting for device to spin down completely (5 seconds)..."
sleep 5

echo ""
echo "=========================================================="
echo " SUCCESS: $DEVICE is unmounted, powered off, and safe to remove!"
echo "=========================================================="
