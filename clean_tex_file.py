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

patterns_to_remove = [ # Remove lines containing any of these strings
    '\\begin{center}\\rule',
    'XP attuali',
    'Descrizione Generale',
    'caption',
    'Età:', 'Razza:', 'Relazioni:', 'Alleati:', 'Nemesi:', 'Possedimenti importanti:', 'Tags:', 'Livello:', 'Info generali', 'Classe:', 'Alias:', 'di nascita:', 'Informazioni Generali', 'Professione:', 'Conosciuto come:'
]
patterns_to_edit = [ # Replace the first string with the second string
    ('.webp', '.jpeg'),  
    #('begin{figure}', 'begin{figure}[h!]'),
    ('begin{figure}', 'begin{wrapfigure}{r}{.4\\textwidth}'),
    ('end{figure}', 'end{wrapfigure}'),
    ('includegraphics', 'includegraphics[width=0.4\\textwidth]'),
    (' ,', ','),
]
strings_delete_after = [ # Delete the lines after the first instance of any of these strings
    r'\subsection{A.',
    r'Coinvolgimenti in'
]

# Read the file content
with open(file_name, 'r') as file:
    lines = file.readlines()

# Filter lines based on patterns
lines = filter_lines(lines, patterns_to_remove)

# delete lines from 2 to the next instance of "\section{, including the line with "\section{
# DM probabilmente si può fare in modo più efficiente
if any(r'\section{' in line for line in lines[2:]):
    end_index = next((i for i, line in enumerate(lines[2:]) if r'\section{' in line), None)
    if end_index is not None:
        del lines[1:end_index+3]

        
# if an open { down't have a close }, merge with the next lines until the close }
for i, line in enumerate(lines):
    if line.count('{') > line.count('}'):
        lines[i] = line.strip() + ' ' + lines[i+1].strip()
        lines[i+1] = ''
        if lines[i].count('{') > lines[i].count('}'):
            lines[i] = line.strip() + lines[i+2].strip()
            lines[i+2] = ''
            
#find lines containig "texorpdfstring" and extract the name of the section, subsection or subsubsection
for i, line in enumerate(lines):
    if r'texorpdfstring' in line:
        # Extract content within \textbf{ and }
        start_index = line.find('\\textbf{')
        end_index = line.find('}', start_index)
        content_within_braces = line[start_index+8:end_index]
        # Extract content within \label{ and }
        start_index = line.find('\\label{') 
        end_index = line.find('}', start_index)
        label = line[start_index:end_index+1]
        if "subsubsection" in line:
            lines[i] = '\\subsubsection{'+ content_within_braces + '}'+label+'\n'
        elif "subsection" in line:
            lines[i] = '\\subsection{'+ content_within_braces + '}'+label+'\n'
        elif "section" in line:
            lines[i] = '\\section{'+ content_within_braces + '}'+label+'\n'

# remove the numbers in front of the section names
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


# delete the lines after the first instance of a string in strings_delete_after
start_index = None
for i, line in enumerate(lines):
    for string in strings_delete_after:
        if string in line:
            start_index = i
            break
    if start_index is not None:
        break
if start_index is not None:
    del lines[start_index:]


# gather all the lines enclosed between \begin{figure} and \end{figure}
# keep only the first figure and delete the others
figures_list = []
for i, line in enumerate(lines):
    if r'\begin{figure}' in line:
        start_index = i
    if r'\end{figure}' in line:
        end_index = i
        figure_lines = lines[start_index:end_index+1]
        # delete the lines between \begin{figure} and \end{figure}
        del lines[start_index:end_index+1]
        # add the figure lines to the end of the file
        figures_list.append(figure_lines)
if len(figures_list) > 1:
    del figures_list[1:]
    
    
#append the figure lines after the first instance of \subsection if the next section is not \subsubsection
for i, line in enumerate(lines):
    if r'\subsection{' in line:
        start_index = i
        #if any of the next 5 lines contains \subsubsection, then append the figure lines after the first instance of \subsubsection
        if any(r'\subsubsection{' in line for line in lines[start_index:start_index+5]):
            #get the index of the first \subsubsection
            start_index = next((i for i, line in enumerate(lines[start_index:]) if r'\subsubsection{' in line), None)
            if start_index is not None:
                start_index = start_index + i + 1
                lines[start_index:start_index] = figures_list[0]
                break
            else:
                break
        else:
            lines[start_index:start_index] = figures_list[0]
            break


# Replace the first letter of the first section to use \lettrine
#find the firs instance of \section
start_index = next((i for i, line in enumerate(lines) if r'\section{' in line), None)
#get the first word after \section
if start_index is not None:
    i = 1
    first_line = []
    search_index = start_index
    while len(first_line) == 0:
        search_index = start_index + i
        first_line = re.findall(r'\w+', lines[search_index])
        i = i + 1
    first_word = first_line[0]
    #replace first letter of first_word
    first_word = first_word[0].replace(first_word[0],'\lettrine[lines=3]{'+first_word[0]+'}{}') 
    #replace the first word of the line
    lines[search_index] = first_word + lines[search_index][1:]

# Apply modifications to lines based on patterns
for i, line in enumerate(lines):
    for pattern, replacement in patterns_to_edit:
        lines[i] = lines[i].replace(pattern, replacement)

        
outfile = file_name.replace("source_raw", "source")
# Write the modified content back to the file
with open(outfile, 'w') as file:
    file.writelines(lines)