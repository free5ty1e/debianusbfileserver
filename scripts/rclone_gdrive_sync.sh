#!/bin/bash

# Rclone One-Way Google Drive Backup Script (Cloud to Local)
# This script is designed to be run by the systemd service or manually by the pi user.
# --ignore-errors ensures the script exits successfully (status 0) even if files fail to copy.

RCLONE_CONFIG="/home/pi/.config/rclone/rclone.conf"
RCLONE_LOG="/var/log/rclone-copy.log"
SOURCE_REMOTE="gdrive:"
DEST_PATH="/media/PiGamesNDataBee/bak/GoogleDriveChrisPaianoGmailAutoBak"

# Execute the copy command
/usr/bin/rclone copy "$SOURCE_REMOTE" "$DEST_PATH" \
    --log-file="$RCLONE_LOG" \
    --config="$RCLONE_CONFIG" \
    --transfers 4 --checkers 8 --retries 10 \
    --exclude "Google Photos/**" \
    --drive-acknowledge-abuse \
    --drive-skip-shortcuts \
    --ignore-errors


