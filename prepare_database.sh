#!/bin/bash
# Define the source directory
source_directory="./source/"

# Function to remove accents from a string
remove_accents() {
    echo "$1" | iconv -f UTF-8 -t ASCII//TRANSLIT
}

# Iterate over each file in the directory
for file in "$source_directory"/*; do
    # Extract the filename without the directory path
    filename=$(basename "$file")
    
    # Remove accents from the filename
    new_filename=$(remove_accents "$filename")
    
    # Rename the file if there's a change in the filename
    if [[ "$filename" != "$new_filename" ]]; then
        mv "$file" "$source_directory/$new_filename"
        echo "Renamed '$filename' to '$new_filename'"
    fi
done

#change all teh sapces to underscores
rename --nows ${source_directory}*.md
rename --nows ${source_directory}*.csv

# delete all the unwanted files
files_to_delete="Acrobazia_ Atletica_ Furtivit\`a_ Rapidit\`a_di_mano_ Religione_ Destrezza_ Forza_ Intelligenza_ Saggezza_ Carisma_"
echo "Deleting files: $files_to_delete"
for file in $files_to_delete; do
    rm ${source_directory}/${file}*md
done

#rename all the files to get rid of the unwanted strings
for file in "$source_directory"/*.md; do
    # Extract the part of the filename between the last "_" and ".md"
    new_filename=$(echo "$file" | sed 's/_[^_]*\.md$/.md/')
    
    # Append the file to a new filename
    #to remove overwriting of files
    cat "$file" >> "$new_filename"
    #mv "$file" "$new_filename"
    rm "$file"
    
    # Print the old and new filenames
    echo "Renamed '$file' to '$new_filename'"
done