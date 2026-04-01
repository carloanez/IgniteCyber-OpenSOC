#!/bin/bash

# --- Config ---
dataset_path="../datasets"
extract_root="/tmp/extracted"
tracker_file="/tmp/extracted/extraction_tracker.txt"

# 1. Setup
mkdir -p "$extract_root"
touch "$tracker_file"

echo "Starting flat extraction to $extract_root..."

# 2. Find all zip files recursively in the dataset path
find "$dataset_path" -name "*.zip" | while read -r zip_path; do
    zip_name=$(basename "$zip_path")

    # 3. Check tracker
    if grep -qF "$zip_name" "$tracker_file"; then
        echo "Skipping: $zip_name (Already extracted)"
        continue
    fi

    echo "Extracting: $zip_name..."

    # -j: junk paths (tosses everything into one flat folder)
    # -n: never overwrite existing files
    # -q: quiet
    unzip -q -j -n "$zip_path" -d "$extract_root" 2>/dev/null

    # 4. Update tracker if successful
    if [ $? -eq 0 ]; then
        echo "$zip_name" >> "$tracker_file"
        echo "Successfully extracted $zip_name"
    else
        echo "Failed to extract $zip_name"
    fi
done

echo "Flat extraction complete. Files are in $extract_root"
