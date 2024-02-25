#script that reads a csv file and creates a tex file with the first column 

input_files=$(ls source/Lista*.csv)
for file in $input_files
do
    echo "Processing $file"
    output_file=$(echo $file | sed 's/.csv/.tex/')
    echo " " > ${output_file}
    cat $file | awk -F, '{print "\\input{} " $1 "}"}' >> $output_file
done
```