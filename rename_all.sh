#!/bin/bash

# Define the directory where you want to start renaming files
start_directory="./src/"

# Use find command to search for files with the specified pattern
# Rename each file by removing the leading space from their names
find "$start_directory" \( -type f -o -type d \) -name '* *' | while IFS= read -r target; do
    # Get the directory and filename separately
    dir=$(dirname "$target")
    filename=$(basename "$target")

    # Extract file extension if it exists
    ext=""
    if [[ $filename == *.* ]]; then
        ext=".${filename##*.}"
        filename="${filename%.*}"
    fi
    
    # Remove leading space and rename the file or directory
    new_target="${dir}/${filename// /.}${ext}"
    mv "$target" "$new_target"
done
