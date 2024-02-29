#script to convert the markdown source files to tex

input_dir="./database/"
output_dir="./source_raw/"
mkdir -p $output_dir
# loop over the .md files in teh directory
for file in $(ls ${input_dir}/*.md)
do
  output_file=$(echo $file | sed 's/database/source_raw/' | sed 's/.md/.tex/')
  # convert the file to a .tex file
  pandoc $file -o ${output_file}
done

# move all the figures to the source directory
for ext in png jpg pdf eps svg gif webp jpeg 
do
  for file in $(ls ${input_dir}/*.$ext)
  do
    cp $file source/.
  done
done