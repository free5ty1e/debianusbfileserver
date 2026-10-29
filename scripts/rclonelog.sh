#!/bin/bash

# Rclone Log Viewer Script
# Usage: ./rclone_view_log.sh [N]
# Displays the last N lines of the log, defaulting to 50.

RCLONE_LOG="/var/log/rclone-copy.log"

# Set default number of lines (N) to 50
LINES_TO_SHOW=${1:-50}

echo "--- Last $LINES_TO_SHOW lines of Rclone Log ---"
tail -n "$LINES_TO_SHOW" "$RCLONE_LOG"

