#script that reads a csv file and creates a tex file with the first column 

input_files=$(ls source/Lista*.csv)
for file in $input_files
do
    echo "Processing $file"
    output_file=$(echo $file | sed 's/source/./' | sed 's/.csv/.tex/')
    echo "" > ${output_file}
    cat $file | awk -F, '{print "\\input{source/" $1 "}"}' >> $output_file
    # add "\FloatBarrier" every other line
    #delete first three lines in the file
    sed -i'' -e '1,3d' $file
    #substitue every space with underscore
    sed -i'' -e  's/ /_/g' $file
done