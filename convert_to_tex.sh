#script to convert the markdown source files to tex

basedir="./source/"
# loop over the .md files in teh directory
for file in $(ls ${basedir}/*.md)
do
  # convert the file to a .tex file
  pandoc $file -o ${file%.md}.tex
done
