drop table persons
CREATE TABLE persons (
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(255),
  dob DATE
);

COPY persons FROM 'C:\Repos\sql-experiments\portfolioprojects\persons.csv' DELIMITER ',' CSV HEADER;

SELECT *FROM persons
drop table persons1
CREATE TABLE persons1 (
	id serial ,
	age int,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(255),
  dob DATE
);
SELECT *FROM persons1