#!/bin/bash
set -e

echo "Safely removing device $1"
sync
sudo udisksctl power-off -b "$1"
echo "$1 has been powered off successfully"
