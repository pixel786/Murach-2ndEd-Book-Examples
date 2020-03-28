# Zainab Sherani
# Created: 03-27-20
# Purpose: This script combines each Murach 2nd edition's chapter examples into a single SQL file. 
#          All the combined files are saved in the "combined_ch_scripts" folder

import os
from pathlib import Path

book_scripts_path = '/Users/zainabsherani/Desktop/mysql copy/book_scripts/'

# retreive all folders in the book_scripts folder
# all folders are in the format: ch01, ch02...ch10...ch19
dir_list = [directory for directory in os.listdir(book_scripts_path) if os.path.isdir(book_scripts_path+directory)]

# combine all examples for each chapter 
for ch_name in dir_list:
    # the file for the combined sql code examples
    appended_name = ''
    appended_name = ch_name + "_combined.sql"
    appended_file = open('/Users/zainabsherani/Desktop/combined_ch_scripts/' + appended_name, 'a')

    ch_path = '/Users/zainabsherani/Desktop/mysql copy/book_scripts/' + ch_name + '/'

    # save the sql files from each folder of chapter examples
    sqlFiles = []
    for filename in os.listdir(ch_path):
        if filename.endswith('.sql'):
            sqlFiles.append(filename)
    
    # organize sql files in descending order
    sqlFiles.sort()
    
    for filename in sqlFiles:
        # retreive the sql file's title 
        name = os.path.splitext(filename)
        appended_file.write(
        '\n-------------------------------------------------------------------------------\n' + 
        '-- '+ name[0] + '\n')

        # save the file as a file object 
        file_obj = open(ch_path + filename, errors='ignore')
        file_content = file_obj.read()

        # append the file's content to the file with all examples combined
        if ';' in file_content:
            appended_file.write('\n' + file_content)
        else:
            appended_file.write('\n' + file_content + ';')
        file_obj.close()
    appended_file.close()

