# Understanding Frame Specification in PostgreSQL Window Functions. #
In the realm of PostgreSQL, window functions stand out as powerful tools for performing complex calculations across sets of rows relative to the current row within a query result set. Among the aspects that make window functions so versatile is the concept of frame specification. This component is crucial for fine-tuning how these functions calculate their results, offering a level of precision and customization that elevates data analysis to new heights.
## What is Frame Specification?
A window function sql query  look like.
```sql
SELECT coulmn_name1, 
 window_function(cloumn_name2)
 OVER([PARTITION BY column_name1] [ORDER BY column_name3]) AS new_column
FROM table_name;
```

- **window_function** = any aggregate or ranking function    
- **column_name1** = column to be selected
- **coulmn_name2** = column on which window function is to be applied
- **column_name3** = column on whose basis partition of rows is to be done
- **new_column** = Name of new column
- **table_name** = Name of table

Frame specification is an advanced feature of the `OVER()` clause in PostgreSQL window functions. It allows users to define a subset of rows within a partition or result set to be considered for the calculation of the window function. Essentially, it tells PostgreSQL not just to look at all rows in the partition but to focus on a specific range of rows around the current row, based on the defined criteria.Without frame specification, a window function operates on all rows determined by the `PARTITION BY` and `ORDER BY` clauses of the `OVER()` clause. While this is useful, it sometimes provides more data than needed for specific calculations. Frame specification narrows down the focus, enabling more targeted analyses like moving averages, running totals that reset under certain conditions, or cumulative sums within specific bounds.

## Understanding Frame Specification Modes
We can set the frame either as `ROWS` or `RANGE` in window function specifications.
* `ROWS`: This mode allows you to define the frame in terms of physical rows. When you specify `ROWS`, you're telling PostgreSQL to count the exact number of rows from the current row to determine the frame. This mode is ideal when you need a fixed number of rows for your calculation, such as when calculating moving averages or running totals that span a specific row count.
* `RANGE`: Unlike `ROWS`, the `RANGE` mode focuses on the values of the ordering column(s) to define the frame. It groups rows that have the same values as the current row in the ordering column(s), effectively treating rows with identical values as a single entity in the calculation. `RANGE` is particularly useful for dealing with duplicate values in the dataset.
The keywords used to specify the frame are:
* `PRECEDING` and `FOLLOWING`: These keywords let you specify the start and end of the frame relative to the current row. `PRECEDING` refers to the rows before the current row, and `FOLLOWING` refers to the rows after. You can use a specific number to indicate how many rows before or after the current row should be included in the frame.
* `UNBOUNDED PRECEDING` and `UNBOUNDED FOLLOWING`: When you use `UNBOUNDED` with `PRECEDING` or `FOLLOWING`, you're extending the frame to the beginning or end of the partition, respectively. This means all rows from the start up to the current row (`UNBOUNDED PRECEDING`) or from the current row to the end of the partition (`UNBOUNDED FOLLOWING`) are included in the calculation.
* `CURRENT ROW`: This keyword indicates that the frame should start or end with the current row. When used with `RANGE`, it includes all rows with values equal to the current row's value in the frame.

## Examples in Action
Let' create an `employeperformnace` table like this.
```sql
CREATE TABLE employeeperformance(
employee_id integer,
employee_name varchar(50),
quarter varchar(10),
year integer,
sales_amount numeric)
```
```sql
INSERT INTO employeeperformance VALUES
(101,'Alice','Q2',2023,20000),
(101,'Alice','Q3',2023,20000),
(101,'Alice','Q4',2023,22000),
(101,'Alice','Q1',2024,23000),
(101,'Alice','Q2',2024,25000),
(102,'Bob','Q4',2023,15000),
(102,'Bob','Q1',2024,15000),
(102,'Bob','Q2',2024,30000),
(103,'Charlie','Q3',2023,25000),
(103,'Charlie','Q4',2023,28000),
(103,'Charlie','Q1',2024,28000),
(103,'Charlie','Q2',2024,30000),
(104,'Danny','Q1',2024,22000),
(104,'Danny','Q2',2024,22000)
```
 <p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/da2ddddf-dcbe-42c8-98dd-7b0712b1a5fc" alt="Alt text for the image">
  <br>
  <em>Employee Performance Table</em>
</p>
### ROWS PRECEDING ###

`ROWS PRECEDING` specifies the  aggregate functions in the current partition in the `OVER` clause will consider the current row, and a specific number of rows before the current row.
```sql
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as CurrentAndPrev2
FROM employeeperformance
ORDER BY employee_id;
```
SQL query calculates the sum of the current and the previous two sales amounts for each employee within the `employeeperformance` table. It partitions the data by *employee_id* , ensuring that the calculation is done separately for each employee.

 <p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/22975ec0-c024-4a59-8ee0-68c9e72395c5" alt="Alt text for the image">
  <br>
  <em> Sum Of The Current And The Previous Two Sales Amounts For Each Employee</em>
</p>

 
### ROWS FOLLOWING
The `ROWS FOLLOWING` option specifies a specific number of rows in the current partition to use after the current row.
```sql
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN  CURRENT ROW AND 2 FOLLOWING) as CurrentAndFollow2
FROM employeeperformance
ORDER BY employee_id;
```
 This SQL query calculates the sum of the sales amount for the current row and the two following rows for each employee within the `employeeperformance` table.
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/995fa858-74d0-4a0d-8b40-b186ff51c02f" alt="Alt text for the image">
  <br>
  <em>Sum Of The Current And The Two FollowingSales Amounts For Each Employee</em>
</p>
### BOTH PRECEDING AND FOLLOWING
`PRECEDING` and `FOLLOWING` in a single statement show how many rows before and after the current row.
```sql
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as BeforeandAfter
FROM employeeperformance
ORDER BY employee_id;
```
This SQL query calculates the sum of sales amounts for each employee in the `employeeperformance` table, considering the current row's sales amount, one preceding row's sales amount, and one following row's sales amount within the same employee partition.
 
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/26345896-92d7-469d-b5f9-7c28b2c5a94e" alt="Alt text for the image">
  <br>
  <em>Sum of One Preceding And One Following</em>
</p>

### UNBOUNDED
`UNBOUNDED PRECEDING` tells the windowing function and aggregates to use the current value, and all values in the partition before the current value. Using `UNBOUNDED PRECEDING` and `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` in the context of window functions will provide the same result. Both expressions specify that the window frame includes all rows from the beginning of the partition up to the current row.
```sql
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS UNBOUNDED PRECEDING ) as BeforeandAfter
FROM employeeperformance
ORDER BY employee_id;
```
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/1effdaa5-46ef-4bc0-9301-a71f867062c1" alt="Alt text for the image">
  <br>
  <em>Unbounded Preceding</em>
</p>

When you use `UNBOUNDED FOLLOWING` in a window function's `OVER` clause, you're defining the window frame's end boundary to extend to the last row of the partition. This is useful when you want to include all rows from the current row to the end of the partition in your calculation.
```SQL
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) as BeforeandAfter
FROM employeeperformance
ORDER BY employee_id;
```
 <p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/613f6e61-1aee-48ad-aac0-0d72209017b4" alt="Alt text for the image">
  <br>
  <em>Unbounded Following</em>
</p>
### RANGES
`ROWS` means the specific row or rows specified, and `RANGE` refers to those same rows plus any others that have the same matching values.
```SQL
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS UNBOUNDED PRECEDING ) as RowsUnboundprece,
 SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 RANGE UNBOUNDED PRECEDING ) as RangeUnboundprece
FROM employeeperformance
ORDER BY employee_id;
```

  * `ROWS UNBOUNDED PRECEDING`: This frame specification tells the database to include in the calculation all rows from the start of the partition up to the current row. It considers the physical order of rows as determined by the `ORDER BY` clause.
* `RANGE UNBOUNDED PRECEDING`: Similar to `ROWS UNBOUNDED PRECEDING`, this includes all rows from the start of the partition up to the current row, but it groups rows with the same *sales_amount*  value together. This means if multiple rows have the same*sales_amount* , they are treated as a single group in the calculation, and the function's result is the same for all these rows.
 
    <p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/e26c53c7-d56d-44a5-8afd-5cd9a3f47b5a" alt="Alt text for the image">
  <br>
  <em>Range vs Rows</em>
</p>                   
## CONCLUSION
The frame specification in SQL window functions is a powerful feature that allows for precise control over the set of rows used in calculations for each row in the query's result set. Understanding and using frame specifications effectively can enhance data analysis, reporting, and the generation of insights from structured data.  Proper use of frame specifications can significantly enhance the utility of SQL for business intelligence, financial analysis, operational reporting, and other areas where insights derived from historical data are critical.In summary, frame specifications in window functions are an indispensable tool in the SQL querying toolkit, offering the ability to conduct sophisticated and precise analyses directly within a database. 
