#!/usr/bin/env python3
import os
import sys
import shutil

def sync_sanitized(src_base, dst_base):
    # Explicitly defined illegal characters for exFAT/Windows filesystems

    print("Add the following exclude entries to your rsync command to avoid special character issues copying to exFAT:")
    print("--exclude='*<*'")
    print("--exclude='*>*'")
    print("--exclude='*|*'")
    print("--exclude='*\"*'")
    print("--exclude='*\\*'")

    illegal = {'?', '*', '<', '>', '|', '\\', ':', '"'}
    count = 0
    errors = 0

    if not os.path.exists(src_base):
        print(f"Error: Source path '{src_base}' does not exist.", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(dst_base):
        print(f"Error: Destination path '{dst_base}' does not exist.", file=sys.stderr)
        sys.exit(1)

    print(f"Scanning source: {src_base}")
    print(f"Syncing to target: {dst_base}\n")

    for root, dirs, files in os.walk(src_base):
        for name in files + dirs:
            if any(c in illegal for c in name):
                src_path = os.path.join(root, name)

                try:
                    rel_path = os.path.relpath(src_path, src_base)
                    sanitized_rel_path = "".join("_" if c in illegal else c for c in rel_path)
                    dst_path = os.path.join(dst_base, sanitized_rel_path)

                    dst_dir = os.path.dirname(dst_path)
                    os.makedirs(dst_dir, exist_ok=True)

                    if os.path.isfile(src_path):
                        if not os.path.exists(dst_path) or os.path.getmtime(src_path) > os.path.getmtime(dst_path):
                            print(f"Copying: {rel_path} -> {sanitized_rel_path}")
                            shutil.copy2(src_path, dst_path)
                            count += 1
                except Exception as e:
                    print(f"Warning: Failed to process '{src_path}': {e}", file=sys.stderr)
                    errors += 1

    print(f"\nSuccessfully synced {count} special-character files locally (Errors: {errors}).")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 syncSpecialFilesToExfat.py <source_dir> <destination_dir>")
        sys.exit(1)

    sync_sanitized(sys.argv[1], sys.argv[2])
