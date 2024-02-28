#script to convert the markdown source files to tex

input_dir="./database/"
output_dir="./source/"
# loop over the .md files in teh directory
for file in $(ls ${input_dir}/*.md)
do
  output_file=$(echo $file | sed 's/database/source/' | sed 's/.md/.tex/')
  # convert the file to a .tex file
  pandoc $file -o ${output_file}
done
