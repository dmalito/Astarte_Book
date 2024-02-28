#read input file provided by command line argument
import re
import argparse

#usage: python clean_tex_file.py <input_file>

#parse command line arguments
parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('input', type=str, help='input file')

args = parser.parse_args()


file_name = parser.parse_args().input


# Function to filter lines based on patterns
def filter_lines(lines, patterns):
    return [line for line in lines if not any(pattern in line for pattern in patterns)]

# Read the file content
with open(file_name, 'r') as file:
    lines = file.readlines()

# Define patterns for lines to be removed or modified
patterns_to_remove = [
    '\\begin{center}\\rule',
    'XP attuali',
]
patterns_to_edit = [
    ('.webp', '.jpeg'),  # Change .webp to .jpeg
    #('begin{figure}', 'begin{figure}[h!]') # Add [h!] to \begin{figure}
    #(r'\d+(\.\d+)* ', ''),  # Delete all the characters line number and number.number
]

# Filter lines based on patterns
lines = filter_lines(lines, patterns_to_remove)

# Delete lines from 2 to 6 only if line 3 contains "Tags:"
#if any("Tags:" in line for line in lines[2:3]):
#    del lines[1:6]

# delete lines from 2 to the next instance of "\section{, including the line with "\section{
# "Tags
if any(r'\section{' in line for line in lines[2:]):
    end_index = next((i for i, line in enumerate(lines[2:]) if r'\section{' in line), None)
    if end_index is not None:
        del lines[1:end_index+3]

# Delete lines from the line containig "Informazioni Generali" to the next instance of "\section{" or "\subsection{"
start_index = next((i for i, line in enumerate(lines) if r'Informazioni Generali' in line), None)
if start_index is not None:
    end_index = next((i for i, line in enumerate(lines[start_index:]) if r'\section{' in line or r'\subsection{' in line), None)
    if end_index is not None:
        del lines[start_index:start_index+end_index]
        
# Delete lines from the line containig "Info generali" to the next instance of "\section{" or "\subsection{"
start_index = next((i for i, line in enumerate(lines) if r'Info generali' in line), None)
if start_index is not None:
    end_index = next((i for i, line in enumerate(lines[start_index:]) if r'\section{' in line or r'\subsection{' in line), None)
    if end_index is not None:
        del lines[start_index:start_index+end_index]

# if an open { down't have a close }, merge with the next lines until the close }
for i, line in enumerate(lines):
    if line.count('{') > line.count('}'):
        lines[i] = line.strip() + lines[i+1].strip()
        lines[i+1] = ''
        if lines[i].count('{') > lines[i].count('}'):
            lines[i] = line.strip() + lines[i+2].strip()
            lines[i+2] = ''



## remove the numbers in front of the name
for i, line in enumerate(lines):
    # put all the content enc
    if "texorpdfstring" in line:
        print(f"line {i}: {line}")
        content = re.findall(r'\{(.*?)\}', line)[-2]
        if "\\subsection{" in line:
            newline = "\\subsection{"+content+"}"
        elif "\\subsubsection{" in line:
            newline = "\\subsubsection{"+content+"}"
        lines[i] = newline
#        start_index = line.find('{') + 1
#        end_index = line.find('}', start_index)
#        content_within_braces = line[start_index:end_index]

# remove the numbers in front of the name
for i, line in enumerate(lines):
    if "\\subsection{" in line or "\\subsubsection{" in line:
        # Extract content within {}
        start_index = line.find('{') + 1
        #if the character at start_index is a number, then delete from start_index to the first space
        if line[start_index].isdigit():
            end_index = line.find('}', start_index)
            content_within_braces = line[start_index:end_index]
            content_within_braces_list = content_within_braces.split()
            new_content = ' '.join(content_within_braces_list[1:])
            lines[i] = line[:start_index] + new_content + line[end_index:]


# Delete all the lines after "\subsection{5. Coinvolgimenti in eventi"
start_index = next((i for i, line in enumerate(lines) if r'\subsection{5. Coinvolgimenti in' in line), None)
if start_index is not None:
    del lines[start_index:]
start_index = next((i for i, line in enumerate(lines) if r'\subsection{A.' in line), None)
if start_index is not None:
    del lines[start_index:]



# delete all lines after the one containing "Coinvolgimenti in eventi"
start_index = next((i for i, line in enumerate(lines) if (r'Coinvolgimenti in' in line and r'\subsection{' in line)), None)
if start_index is not None:
    del lines[start_index:]

# delete the lines between \begin{figure} and \end{figure}, but only the second time they appear
start_index = next((i for i, line in enumerate(lines) if r'\begin{figure}' in line), None)
if start_index is not None:
    end_index = next((i for i, line in enumerate(lines[start_index:]) if r'\end{figure}' in line), None)
    if end_index is not None:
        end_index = end_index + start_index
        start_index = next((i for i, line in enumerate(lines[end_index:]) if r'\begin{figure}' in line), None)
        if start_index is not None:
            start_index = start_index + end_index
            end_index = next((i for i, line in enumerate(lines[start_index:]) if r'\end{figure}' in line), None)
            if end_index is not None:
                end_index = end_index + start_index
                print(f"In file {file_name}, deleting lines from {start_index} to {end_index}")
                del lines[start_index:end_index+1]

# delete lines that contain "\caption"
for i, line in enumerate(lines):
    if "caption" in line:
        lines[i] = ''

# Apply modifications to lines based on patterns
for i, line in enumerate(lines):
    for pattern, replacement in patterns_to_edit:
        lines[i] = lines[i].replace(pattern, replacement)
        
#outfile = file_name.replace(".tex", "_cleaned.tex")
outfile = file_name
# Write the modified content back to the file
with open(outfile, 'w') as file:
    file.writelines(lines)