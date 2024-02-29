# script to delete the last lines from a file

#get the files path from Lista_Giocatori.tex

file="source_raw/Lista_Giocatori.tex"
files="source_raw/Lista_Giocatori.tex source_raw/Lista_NPC.tex"

for file in $files
do
# loop over the lines of the file
    while read line
    do
        echo $line
        # check if the line contains the word "include"
        if echo $line | grep -q "input"; then
            # get the file name from the line
            #the path is between {}
            file_name=$(echo $line | awk -F '{' '{print $2}' | awk -F '}' '{print $1}').tex

            python3 clean_tex_file.py $file_name

        fi
    done < $file
done
