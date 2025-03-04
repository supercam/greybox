r"""
.Synopsis
    Data Export using python.  Intended as a way to sort noise out of CSV's by selected a certain column of data and pulling it and adding it to a new .csv.
.Description
    1. Import modules
    2. Import CSVs
    3. Select columns from CSVs
    4. Export columns to new CSVs

    example usage
    -i = location where csv's are
    -o = output file location
    -c = columns to use
    -clog = console logging
    -outlog = output logging to text file
    py pyLibCSVSort_004a.py -i "C:/usrchk" -o "C:/usrChk/output.csv" -c 0 1 -clog -outlog

.Author
    James Lewis
.Date
    02/17/2025
"""

#importing modules
import time
import csv
import datetime
import pathlib
import os
import shutil
import argparse
from os.path import isfile

#cmdline parameters
parser = argparse.ArgumentParser(description="Data Export using Python. Sorts noise out of CSVs by selecting a certain column and exporting it.")
parser.add_argument("-i", "--input_dir", required=True, help="Input directory containing CSV files")
parser.add_argument("-o", "--output_file", required=True, help="Output CSV file path")
parser.add_argument("-c", "--columns", type=int, nargs="+", required=True, help="Column indices to extract (0-based index)")
parser.add_argument("-clog", "--console", action="store_true", help="Enable console logging output")
parser.add_argument("-outlog", "--outlog", action="store_true", help="Enable logging output to txt file")

args = parser.parse_args()

#variable declaration
nowTime = datetime.datetime.now()
sys_drive = os.environ.get("SYSTEMDRIVE", "C:")
#python does not like backslashes in windows so need to use forward slashes to get this to work.
path = pathlib.Path(sys_drive)/"temp/pyCSVSortLog_001.txt"
parentDir = path.parent

#test if path exists and if it doesn't exist create folder
def logTest():
    try:
        if os.path.exists(path.parent):
            with path.open("a") as file:
                file.write(f"\n{nowTime}: Path is Valid for logging")
        else:
            os.makedirs(path.parent, exist_ok=True)
            with path.open("a") as file:
                file.write(f"\n{nowTime}"
                        "\nDirectory did not exist, created directory for logging")
                
    except:
        errLogFlag = True
        print("\nUnable to make path for logging")
        exit()

#call once to check for path
logTest()


#Function for logging errors
def errLog(msg):
    if args.outlog:
        try:
            with path.open("a") as file:
                file.write(f"{msg}\n")
        except Exception as e:
            print(f"\nUnable to do operation: {e}")
            exit()

# Function to log messages when verbose mode is enabled
def logConsole(logMsg):
    if args.console:
        print(logMsg)


#test logging
errLog(f"\n{nowTime}: Logging the start of operation after logging validation")
logConsole(f"Log file setup complete at {path}")


#read multi csvs in and export data from them.
def csvReadMulti(input_dir, output_file, column_index):
    try:
        logConsole("Starting operation.")
        logConsole(f"Columns specified is {args.columns}")

        input_dir = pathlib.Path(input_dir)
        out_file_path = pathlib.Path(output_file)

        #open a new CSV file to write the selected column
        with open(out_file_path, mode='w', newline='') as output_file:
            csv_writer = csv.writer(output_file)

            errLog(f"{nowTime}: Creating output file: {out_file_path.name} at {out_file_path}")
            logConsole(f"Creating output file: {out_file_path.name} at {out_file_path}")
            

            #loop through all csv files in input dir
            for file_path in input_dir.glob("*.csv"):
                file_name = file_path.stem

                errLog(f"{nowTime}: Reading Input file: {file_name} in {input_dir}")
                logConsole(f"Reading Input file: {file_name} in {input_dir}")

                # Open and read the .csv file
                with open(file_path, mode='r', newline='') as file:
                    csv_reader = csv.reader(file)

                    try:
                        #get the header
                        header = next(csv_reader)
                        #print(f"header: {header}")
                    except StopIteration:
                        continue

                    new_header = ["Filename"] + header
                    csv_writer.writerow(new_header)

                    # Loop through the rows and print them
                    for row in csv_reader:
                        selected_columns = [file_name]
                        for index in column_index:
                            selected_columns.append(row[index])
                        #print(selected_columns)
                        csv_writer.writerow(selected_columns)

                    errLog(f"{nowTime}: CSV {file_name} completed processing.")
                    logConsole(f"CSV {file_name} completed processing.")
        
    except Exception as error:
        logConsole(f"Failed to complete operation {error}")
        errLog(f"\n{nowTime}: Failed to complete operation {error}")
        
csvReadMulti(args.input_dir, args.output_file, args.columns)

logConsole("Script execution completed successfully.")
errLog(f"\n{nowTime}: Logging operation complete")