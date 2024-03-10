# Unlocking Advanced Data Analysis in PostgreSQL with Window Functions #
## Introduction ##
Dive into the powerful world of window functions in PostgreSQL, a feature that supercharges data analysis and reporting capabilities beyond traditional SQL queries. 
This blog will explore how window functions can transform the way you work with data sets, enabling more sophisticated calculations and insights directly within your
 database queries.
## What are Window Functions ##
Window functions in PostgreSQL, introduced in version 8.4, enable data analysis that extends beyond the current row, giving rise to the term "window." These functions can aggregate data for each row in the output, offering a unique method for performing calculations across multiple records. Unlike traditional approaches that rely heavily on subqueries and JOINS for aggregating data from related rows, window functions simplify this process. They provide an efficient alternative for calculations that would otherwise require complex queries, by allowing operations over a set of rows related to the current row without the need for explicit JOIN operations or nested queries. This feature enhances the capability to perform sophisticated data analysis directly within SQL queries, making it easier to compute running totals, rankings, and moving averages, among other analytics, directly on a set of database rows.
Key Components of Window Functions  
A window function sql query  look like.

```sql
SELECT coulmn_name1, 
 window_function(cloumn_name2)
 OVER([PARTITION BY column_name1] [ORDER BY column_name3]) AS new_column
FROM table_name;
```
- **window_function**: Any aggregate or ranking function.
- **column_name1**: Column to be selected.
- **column_name2**: Column on which the window function is to be applied.
- **column_name3**: Column on whose basis the partition of rows is to be done.
- **new_column**: Name of the new column.
- **table_name**: Name of the table.

The key components of Window Functions are `OVER()`, `PARTITION BY`, `ORDER BY`, and frame specifications, and they play crucial roles in defining how the window function operates over a set of rows. Here's a breakdown of each component:

- **OVER() Clause**: This clause is what differentiates a window function from other aggregate functions. It determines the set of rows used by the window function for each row. The `OVER()` clause can include `PARTITION BY`, `ORDER BY`, and frame specifications, dictating how the data is split, ordered, and which rows are included in the window.

- **PARTITION BY**: `PARTITION BY` divides the result set into partitions to which the window function is applied. Essentially, it groups rows that have the same value in specified columns into summary rows, like the SQL `GROUP BY` clause, but without aggregating the data into a single output row per group. This allows you to perform calculations across each group while still returning the same number of rows as the input.

- **ORDER BY**: Within the `OVER()` clause, `ORDER BY` specifies the order of rows in each partition. This ordering is critical for functions like running totals or moving averages where the sequence of rows affects the calculation. It determines the sequence in which the window function's calculations are applied to the rows in each partition.

- **Frame Specification**: Frame specifications define the subset of rows within a partition to be considered for calculations at any point. It further refines how the window function operates on the rows within each partition. There are two primary types of frames:
  - Rows-based frames: Specify the frame in terms of physical offsets from the current row (e.g., 3 rows preceding to 3 rows following).
  - Range-based frames: Define the frame in terms of logical boundaries (e.g., all rows with the same value as the current row for the ordering column). It's often used with `ORDER BY`. The default frame specification is `RANGE UNBOUNDED PRECEDING`, which includes all rows from the start of the partition up to the current row's last peer (rows considered equal based on the `ORDER BY` clause).

By combining these components, window functions offer powerful capabilities for data analysis, such as calculating running totals, ranking, and performing statistical calculations across segments of data while maintaining the original row context.

> [Frame specification itself is a topic for discussion. I will explain more in my next blog.]

## Getting Started with Window Functions in Your Projects.
Let's illustrate the use of window functions in PostgreSQL with a simple example involving a sales table. Suppose we have a table named employeeperformance.

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
(101,'Alice','Q4',2023,20000),
(101,'Alice','Q1',2024,20000),
(101,'Alice','Q2',2024,25000),
(102,'Bob','Q4',2023,15000),
(102,'Bob','Q1',2024,15000),
(102,'Bob','Q2',2024,30000),
(103,'Charlie','Q1',2024,28000),
(103,'Charlie','Q2',2024,22000),
(104,'Danny','Q2',2024,22000)
```
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/7c452698-f285-4dec-b30a-383092c7f7f5" alt="Alt text for the image">
  <br>
  <em>Employee Performance Table</em>
</p>

### Aggregate Functions
Most aggregate functions that PostgreSQL supports can be used as window functions. This includes functions like `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`, and more, with the addition of the `OVER()` clause to specify the window.

- **Calculate the Average Sales Amount for Each Year**.

  `AVG()`: Calculates the average of a set of values. When used with the `OVER()` clause, it computes the average within the defined partition. These tasks demonstrate how window functions can be applied to real-world scenarios for analytical purposes, providing insights into data with respect to rankings, distributions, and aggregations.


```sql
SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  ROUND(AVG(sales_amount) OVER (PARTITION BY  year),2)AS avg_sales_year
FROM employeeperformance;
```
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/1fb16dce-0a8e-43d2-b3fb-23b02a6cb0ad" alt="Alt text for the image">
  <br>
  <em>Average Sales per Year</em>
</p>

Try applying various aggregrate function in windows function.
### Ranking Functions
- `ROW_NUMBER()`: Assigns a unique number to each row starting from 1 within each partition, based on the ordering specified. It does not allow for ties; each row will receive a distinct rank.

- `RANK()`: Assigns a rank to each row within a partition, with gaps in ranking numbers if there are ties. If two rows have the same sales amount, they will receive the same rank, and the next rank will be skipped.

- `DENSE_RANK()`: Similar to `RANK()`, but without gaps in the ranking sequence. If two rows have the same sales amount, they receive the same rank, and the next rank is not skipped.

- `PERCENT_RANK()`: This window function in SQL computes the relative rank of a row within a partition as a percentage. The percentage rank of a row is calculated as `(RANK-1)/(NO OF ROWS-1)`, where the rank of the first row is 1. If the partition has only one row, the result is 0. This function is useful for understanding the position of a row within its partition on a relative scale from 0 to 1. It's often used in analytics to determine percentile rankings within groups.

- `CUME_DIST()`: This window function in SQL computes the cumulative distribution of a value within a set of values. It calculates the proportion of rows with a value less than or equal to the current row's value. The function is part of the SQL standard and is available in many SQL databases, including PostgreSQL, SQL Server, and Oracle. This function is useful for understanding how a particular value is positioned within the context of a distribution in a dataset.

**Question**: How can you rank the sales amounts for each employee within the `employeeperformance` table by quarter, using descending order of sales amounts, and calculate their row number, rank, dense rank, percentile rank, and cumulative distribution within each quarter?


```sql
SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  ROW_NUMBER() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS row_num,
  RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS sales_rank,
  DENSE_RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS dens_rank,
  PERCENT_RANK() OVER(PARTITION BY quarter ORDER BY sales_amount  DESC) AS percentile_rank,
  CUME_DIST() OVER(PARTITION BY quarter ORDER BY sales_amount DESC) AS cum_distr
FROM employeeperformance
```
<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/db06e172-8db3-42a7-9c40-5f12cd8d1bd7" alt="Alt text for the image">
  <br>
  <em>Ranking Rows in Each Quarter</em>
</p>


### Analytic Functions
- **LEAD()**: This function is used to return a value from a row that is a certain number of rows ahead of the current row within the partition. It allows you to "look forward" in your dataset. When you see `LEAD(column_name, 2)` in a query, it means the function is configured to return a value from a column in the row that is two positions ahead of the current row in the ordered partition.

- **LAG()**: This function in SQL is a window function that allows you to access data from a previous row (a "lag" row) relative to the current row within the same result set, without the need for a self-join. It's particularly useful for comparing the current row's data with that of preceding rows. The `LAG(column_name, 2)` function in SQL is used to access data from the row that is two positions behind the current row within the same result set.

- **FIRST_VALUE()**: Returns the first value in an ordered set of values in each partition.

- **LAST_VALUE()**: Returns the last value in an ordered set of values in each partition, but needs specific frame specification for expected results.

- **NTH_VALUE()**: Returns the value of a specified column at the nth row of the window frame. The function requires specifying the window frame to ensure it can access the nth row across the entire partition. By using `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`, you ensure the function has visibility across all rows from the first to the last within each partition. If there are less than n rows in the window frame (e.g., an employee has fewer than three sales), the result for `third_sale_amount` will be null for that partition.

```sql
SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  LAG(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter)
  AS prevquart_saleamount,
  LEAD(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter) 
  AS nextquart_saleamount,
  FIRST_VALUE(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter) 
  AS firstsale_amount,
  LAST_VALUE(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  AS lastsale_amount,
  NTH_VALUE(sales_amount, 3) OVER (PARTITION BY employee_id ORDER BY year, quarter ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS third_saleamount
FROM employeeperformance
ORDER BY employee_id, year, quarter;
```

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/50c55df6-bca0-4c26-9730-f48d21cbc2a7" alt="Alt text for the image">
  <br>
  <em>Analytical Window Function Results for Each Employee</em>
</p>


### Statistical Functions
*NTILE(n):* The `NTILE()` function in SQL is a window function that divides the rows in an ordered partition into a specified number of approximately equal groups, or "tiles". It assigns a number to each row that indicates which tile or quantile the row belongs to. This function is particularly useful for dividing a dataset into quantiles, deciles, percentiles, or any other division as required. 
*    How can you divide the sales amount data from the employeeperformance table into three groups (tiles) for each quarter, ordered by the sales amount, to analyze the performance distribution within each quarter?

```sql
SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  NTILE(3) OVER (PARTITION BY quarter ORDER BY sales_amount)AS tiles
FROM employeeperformance;
```

<p align="center">
  <img src="https://github.com/anusoosanbaby/DataAnalysis/assets/20100713/e379da6b-7db4-4c67-8adf-40e9fbac4f3f" alt="Alt text for the image">
  <br>
  <em>Divided Salesamount Data into 3 Groups for Each Quarter</em>
</p>

### Navigation Functions
Although not a separate category, functions like `LEAD()` ,`LAG()`,`FIRST_VALUE()` and `LAST_VALUE()` can be considered part of navigational aids in windowing.

## Real-World Applications and Case Studies
Window functions in SQL are essential for advanced data analysis, offering insights through comparisons and calculations across related sets of rows. Here are concise examples of their real-world applications:

- **Financial Analysis** Calculate running totals and moving averages for trends in revenue, expenses, or stock prices.

- **Data Reporting:** Rank entities based on performance metrics to identify top or bottom performers.

- **Business Intelligence:** Compare year-over-year metrics for growth analysis and segment customers for targeted marketing.

- **Time Series Data:** Fill gaps and interpolate missing values, and analyze event sequences to model behavior patterns.

- **Human Resources:** Analyze employee turnover trends and compare performance across departments.

- **Healthcare:** Track patient metric trends over time and assess treatment effectiveness.

- **E-commerce and Retail:** Calculate customer lifetime value and inventory turnover rates for better stock management.

- **Education:** Monitor student performance and engagement levels to improve learning outcomes.

These applications highlight the flexibility and power of window functions in facilitating complex analyses across various industries.

## Conclusion
Window functions in PostgreSQL unlock sophisticated data analysis capabilities, allowing for intricate calculations across related data rows without complex joins. They enhance data insights through functionalities like trend analysis, ranking, and segmentation, crucial for informed decision-making. This exploration demonstrates their versatility and power in transforming raw data into actionable intelligence across various industries.
