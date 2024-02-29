# script to delete the last lines from a file

#get the files path from Lista_Giocatori.tex
basedir_raw="source_raw"
basedir="source"

file="source_raw/Lista_Giocatori.tex"
files="Lista_Giocatori.tex Lista_NPC.tex"

for file in $files
do
    cp -v ${basedir_raw}/${file} ${basedir}/.
    #change source_raw to source in the file
    sed -i'' -e 's/source_raw/source/g' ${basedir}/${file}
    #delete first two lines in the file
    sed -i'' -e '1,2d' ${basedir}/${file}
done


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
            echo cleaning $file_name

            python3 clean_tex_file.py $file_name

        fi
    done < ${basedir_raw}/${file}
done
