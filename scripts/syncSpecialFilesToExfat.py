#!/usr/bin/env python3
import os
import sys
import shutil

def sync_sanitized(src_base, dst_base):
    illegal = set("?*<>|\\\":")
    count = 0

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

                # Calculate relative path from the source root
                rel_path = os.path.relpath(src_path, src_base)

                # Build sanitized destination path (replacing illegal chars with underscores)
                sanitized_rel_path = "".join("_" if c in illegal else c for c in rel_path)
                dst_path = os.path.join(dst_base, sanitized_rel_path)

                # Ensure target directory exists
                dst_dir = os.path.dirname(dst_path)
                os.makedirs(dst_dir, exist_ok=True)

                # Copy files if it's a file and update is needed
                if os.path.isfile(src_path):
                    if not os.path.exists(dst_path) or os.path.getmtime(src_path) > os.path.getmtime(dst_path):
                        print(f"Copying: {rel_path} -> {sanitized_rel_path}")
                        shutil.copy2(src_path, dst_path)
                        count += 1

    print(f"\nSuccessfully synced {count} special-character files locally.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 syncSpecialFilesToExfat.py <source_dir> <destination_dir>")
        sys.exit(1)

    sync_sanitized(sys.argv[1], sys.argv[2])
