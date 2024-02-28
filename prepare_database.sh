#!/bin/bash
# Define the source directory
source_directory="./database/"

# Function to remove accents from a string
remove_accents() {
    echo "$1" | iconv -f UTF-8 -t ASCII//TRANSLIT
}

rename_special_characters() {
    #echo "$1" | sed -e 's/ /_/g' -e 's/\`//g' -e 's/\'
# Iterate over each file in the directory
for file in "$source_directory"/*; do
    # Extract the filename without the directory path
    filename=$(basename "$file")

    
    # Remove accents from the filename
    new_filename=$(remove_accents "$filename")
    #remove ` and ' from the filename
    new_filename=$(echo "$new_filename" | sed -e 's/\`//g' -e "s/'//g")
    
    # Rename the file if there's a change in the filename
    if [[ "$filename" != "$new_filename" ]]; then
        mv "$file" "$source_directory/$new_filename"
        echo "Renamed '$filename' to '$new_filename'"
    fi
done
}

#change all teh sapces to underscores
remove_spaces() {
rename --nows ${source_directory}*.md
rename --nows ${source_directory}*.csv
}

# delete all the unwanted files
delete_unwanted_files() {
files_to_delete="Acrobazia_ Atletica_ Furtivit\`a_ Rapidit\`a_di_mano_ Religione_ Destrezza_ Forza_ Intelligenza_ Saggezza_ Carisma_ Addestrare_Animali_ Sopravvivenza_ Persuasione_ Percezione_ Natura_ Medicina_ Intuizione_ Intrattenere_ Inganno_ Indagare_"
echo "Deleting files: $files_to_delete"
for file in $files_to_delete; do
    rm ${source_directory}/${file}*md
done
}

remove_string() {
#rename all the files to get rid of the unwanted strings
for ext in md csv; do
    for file in $(ls $source_directory/*.$ext); do
        new_filename=$(echo "$file" | sed 's/_[^_]*\.'$ext'$/.'$ext'/')
        mv "$file" "$new_filename"
        echo "Renamed '$file' to '$new_filename'"
    done
done
}

convert_images() {
    for ext in webp
    do
        for file in $(ls $source_directory/*.$ext)
        do
            newname=$(echo $file | sed 's/\.webp//')
            sips -s format jpeg $file --out $newname.jpeg
        done
    done
}

rename_extension() {
    for ext in jpg
    do
        for file in $(ls $source_directory/*.$ext)
        do
            newname=$(echo $file | sed 's/\.jpg//')
            mv $file $newname.jpeg
        done
    done
}
rename_special_characters
remove_spaces
delete_unwanted_files
remove_string
convert_images