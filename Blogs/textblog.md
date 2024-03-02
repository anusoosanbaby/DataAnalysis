# How to Seamlessly Import Tables from Excel into PostgreSQL

SQL is a powerful tool for analyzing data, offering extensive capabilities to filter, aggregate, and transform information stored in databases. However, in many practical scenarios, the data we need to analyze is not initially found within a SQL database but rather in more accessible formats such as Excel or CSV files. This presents a challenge: how do we efficiently transfer this data into a SQL table for analysis? This process of importing external data into a database is crucial for leveraging SQL's full analytical power on datasets that reside outside traditional database systems.

Importing an Excel sheet into PostgreSQL is a common task that many database administrators and developers need to perform. There are various methods to accomplish this, each with its own set of steps. Here, we discuss several effective ways to import data from an Excel sheet into PostgreSQL, focusing primarily on converting the Excel sheet into CSV format, as it's one of the most straightforward and universally accepted methods for data import across different database systems.


### **1.Convert Your Excel Sheet to CSV**

The first step in this process is to convert your Excel sheet into a CSV (Comma Separated Values) file. CSV files are plain text files that contain data separated by commas, and they are widely supported by database management systems, including PostgreSQL. Here's how you can convert your Excel sheet into a CSV file.

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/6323d09e-2e93-4ebf-9df7-65e56514dfb4" alt="Alt text for the image">
  <br>
  <em>Excel worksheet</em>
</p>
  
Open your  Excel document you wish to export to PostgreSQL.
Save As CSV: Go to the File menu, select "Save As," and choose the location where you want to save the file. In the "Save as type" dropdown menu, select "CSV (Comma delimited) (*.csv)" option. Click "Save."

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/271a0662-8e68-4f9a-8ba5-fef20a6cc476" alt="Alt text for the image">
  <br>
  <em>Save Excel as CSV</em>
</p>

### **2. Preparing PostgreSQL for Data Import**

Before importing the CSV file into PostgreSQL, you need to prepare the database.In PostgreSQL, data from a CSV file is imported into an existing table. Therefore, you must create a table in your PostgreSQL database that matches the structure of your CSV file. This includes defining the correct data types for each column. PgAdmin is a popular graphical user interface for managing PostgreSQL databases. It can be used to execute the SQL command for creating tables, as well as for importing the CSV file.

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/2392c6b3-26c3-4931-a285-ba5dfbdd2930" alt="Alt text for the image">
  <br>
  <em>Create a table in PostgreSQL</em>
</p>

### **3. Importing CSV into PostgreSQL**

Once you have your CSV file and a corresponding table in PostgreSQL, you can import the data in several ways as explained below.

#### Using the COPY Command:
PostgreSQL’s COPY command is a quick way to import data from a CSV file. This command requires that the table already exists in the database and that the CSV file's column structure matches that of the table.

```sql
COPY table_name FROM 'path to csv file' DELIMITER ',' CSV HEADER;
```
Here is an example from my work.
```sql
COPY persons FROM 'C:\Repos\sql-experiments\portfolioprojects\persons.csv' DELIMITER ',' CSV HEADER;
```

#### Using PgAdmin:
PgAdmin provides a graphical interface for importing CSV files. Right-click on the table you want to import data into, select the Import/Export option, choose "Import," and then configure the import settings to match your CSV file (e.g., specifying the delimiter as a comma, indicating if your file includes a header, etc.).

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/accaeff1-5e24-433d-8b68-c0a27808a63e" alt="Alt text for the image">
  <br>
  <em>Select Import/Export option in PostegreSQL</em>
</p>
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/23b54e79-037b-402f-b340-6698f2388782" alt="Alt text for the image">
  <br>
  <em>Browse the file path</em>
</p>
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/348bd708-4be0-4f55-b1f4-a7077b4c3d37" alt="Alt text for the image">
  <br>
  <em>Specify the delimeter as a comma</em>
</p>


### **4. Post-Import Checks**
After importing your data, it's crucial to perform some checks to ensure that the import process was successful.Run some SELECT queries to check if the data has been imported correctly.

```sql
SELECT *FROM persons;
```

Converting an Excel sheet to a CSV file and importing it into PostgreSQL is a straightforward process that involves preparing both your data and the database for the import. By following these steps, you can efficiently transfer data from Excel to PostgreSQL, enabling you to leverage the powerful features of this database management system for storing, querying, and analyzing your data.





