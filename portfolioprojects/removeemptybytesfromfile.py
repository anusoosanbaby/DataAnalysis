input_csv_path = 'C:\Repos\DataAnalysis\portfolioprojects\Covidvaccination.csv'
output_csv_path = 'C:\Repos\DataAnalysis\portfolioprojects\CleanedCovidvaccination.csv'

try:
    # Open the input file in read mode and the output file in write mode
    with open(input_csv_path, 'r', encoding='utf-8', errors='ignore') as infile, \
         open(output_csv_path, 'w', encoding='utf-8') as outfile:
        
        # Iterate through each line in the input file
        for line in infile:
            # Remove null bytes from the current line
            cleaned_line = line.replace('\x00', '')
            
            # Write the cleaned line to the output file
            outfile.write(cleaned_line)
            
    print("File has been cleaned and saved successfully.")
except Exception as e:
    print(f"An error occurred: {e}")