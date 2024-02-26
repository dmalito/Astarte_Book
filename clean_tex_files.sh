# script to delete the last lines from a file

#get the files path from Lista_Giocatori.tex

file="Lista_Giocatori.tex"

# loop over the lines of the file
while read line
do
    echo $line
    # check if the line contains the word "include"
    if echo $line | grep -q "input"; then
        # get the file name from the line
        #the path is between {}
        file_name=$(echo $line | awk -F '{' '{print $2}' | awk -F '}' '{print $1}').tex
        #delete lines from 2 to 6 only if line 3 contains "Tags:"
        if grep -q "Tags:" $file_name; then
            sed -i"" -e '2,6d' $file_name
        fi
        #delete all the lines after "\subsection{5. Coinvolgimenti in eventi\subsection{5. Coinvolgimenti in eventi"
        sed -i"" -e '/\\subsection{5. Coinvolgimenti in eventi/,$d' $file_name
        sed -i"" -e '/\\\subsection{A./,$d' $file_name
        #delete the lines containig "\begin{center}\rule"
        sed -i"" -e '/\\begin{center}\\rule/d' $file_name
        #delete the lines containing " XP attuali"
        sed -i"" -e '/XP attuali/d' $file_name
        #change .webp to .jpeg
        sed -i"" -e 's/.webp/.jpeg/g' $file_name
        #sed -i"" -e 's/.jpg/.jpeg/g' $file_name
        #edit the lines with the subsection numbers
        sed -i'' -e 's/\\subsubsection{\\texorpdfstring{[0-9.]*\\textbf{\(.*\)}}{[0-9.]* \1}}/\\subsubsection{\1}/g' $file_name

        #delete all the charachters line number. and numner.number from the file
        sed -i'' -E -e 's/[0-9]+(\.[0-9]+)* //g' $file_name
        sed -i'' -e  's/1. //g' $file_name
        sed -i'' -e  's/1.1 //g' $file_name
        sed -i'' -e  's/1.2 //g' $file_name
        sed -i'' -e  's/1.3 //g' $file_name
        sed -i'' -e  's/1.4 //g' $file_name
        sed -i'' -e  's/1.5 //g' $file_name
        sed -i'' -e  's/1.6 //g' $file_name
        sed -i'' -e  's/1.7 //g' $file_name
        sed -i'' -e  's/1.8 //g' $file_name
        sed -i'' -e  's/1.9 //g' $file_name
        sed -i'' -e  's/2. //g' $file_name
        sed -i'' -e  's/2.1 //g' $file_name
        sed -i'' -e  's/2.2 //g' $file_name
        sed -i'' -e  's/2.3 //g' $file_name
        sed -i'' -e  's/2.4 //g' $file_name
        sed -i'' -e  's/2.5 //g' $file_name
        sed -i'' -e  's/2.6 //g' $file_name
        sed -i'' -e  's/2.7 //g' $file_name
        sed -i'' -e  's/2.8 //g' $file_name
        sed -i'' -e  's/2.9 //g' $file_name
        sed -i'' -e  's/3. //g' $file_name
        sed -i'' -e  's/3.1 //g' $file_name
        sed -i'' -e  's/3.2 //g' $file_name
        sed -i'' -e  's/3.3 //g' $file_name
        sed -i'' -e  's/3.4 //g' $file_name
        sed -i'' -e  's/3.5 //g' $file_name
        sed -i'' -e  's/3.6 //g' $file_name
        sed -i'' -e  's/3.7 //g' $file_name
        sed -i'' -e  's/3.8 //g' $file_name
        sed -i'' -e  's/3.9 //g' $file_name
        sed -i'' -e  's/4. //g' $file_name
        sed -i'' -e  's/4.1 //g' $file_name
        sed -i'' -e  's/4.2 //g' $file_name
        sed -i'' -e  's/4.3 //g' $file_name
        sed -i'' -e  's/4.4 //g' $file_name
        sed -i'' -e  's/4.5 //g' $file_name
        sed -i'' -e  's/4.6 //g' $file_name
        sed -i'' -e  's/4.7 //g' $file_name
        sed -i'' -e  's/4.8 //g' $file_name
        sed -i'' -e  's/4.9 //g' $file_name
        sed -i'' -e  's/5. //g' $file_name
        sed -i'' -e  's/5.1 //g' $file_name
        sed -i'' -e  's/5.2 //g' $file_name


    fi
done < $file