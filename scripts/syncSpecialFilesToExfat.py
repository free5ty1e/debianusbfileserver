#!/usr/bin/env python3
import os
import sys
import shutil

def generate_exclude_file(filename="rsync_excludes.txt"):
    """Generates the clean rsync excludes file for exFAT compatibility,
    including protecting the _SanitizedSpecials folder from rsync deletions."""
    excludes = [
        "lost+found",
        "_SanitizedSpecials/",
        "*<*",
        "*>*",
        "*|*",
        '*"*',
        "*\\*",
        "*\?*",
        "*:*"
    ]
    try:
        with open(filename, "w", encoding="utf-8") as f:
            f.write("\n".join(excludes) + "\n")
        print(f"Successfully generated exclude file: {os.path.abspath(filename)}")
    except Exception as e:
        print(f"Warning: Failed to generate exclude file '{filename}': {e}", file=sys.stderr)

def sync_sanitized(src_base, dst_base):
    # Explicitly defined illegal characters for exFAT/Windows filesystems
    illegal = {'?', '*', '<', '>', '|', '\\', ':', '"'}
    count = 0
    errors = 0

    if not os.path.exists(src_base):
        print(f"Error: Source path '{src_base}' does not exist.", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(dst_base):
        print(f"Error: Destination path '{dst_base}' does not exist.", file=sys.stderr)
        sys.exit(1)

    # Establish the dedicated subdirectory for sanitized files on the destination
    sanitized_dest_base = os.path.join(dst_base, "_SanitizedSpecials")

    print(f"Scanning source: {src_base}")
    print(f"Syncing sanitized specials to: {sanitized_dest_base}\n")

    for root, dirs, files in os.walk(src_base):
        for name in files + dirs:
            if any(c in illegal for c in name):
                src_path = os.path.join(root, name)

                try:
                    rel_path = os.path.relpath(src_path, src_base)
                    
                    # Sanitize the relative path structure while preserving the directory tree
                    sanitized_rel_path = "".join("_" if c in illegal else c for c in rel_path)
                    
                    # Target path is now nested inside _SanitizedSpecials preserving the tree
                    dst_path = os.path.join(sanitized_dest_base, sanitized_rel_path)

                    dst_dir = os.path.dirname(dst_path)
                    os.makedirs(dst_dir, exist_ok=True)

                    if os.path.isfile(src_path):
                        if not os.path.exists(dst_path) or os.path.getmtime(src_path) > os.path.getmtime(dst_path):
                            print(f"Copying: {rel_path} -> _SanitizedSpecials/{sanitized_rel_path}")
                            shutil.copy2(src_path, dst_path)
                            count += 1
                except Exception as e:
                    print(f"Warning: Failed to process '{src_path}': {e}", file=sys.stderr)
                    errors += 1

    print(f"\nSuccessfully synced {count} special-character files into _SanitizedSpecials (Errors: {errors}).")

if __name__ == "__main__":
    # Automatically generate the exclude file (with _SanitizedSpecials protected) on every script run
    generate_exclude_file()

    if len(sys.argv) < 3:
        print("\nUsage: python3 syncSpecialFilesToExfat_2.py <source_dir> <destination_dir>")
        sys.exit(1)

    sync_sanitized(sys.argv[1], sys.argv[2])
    