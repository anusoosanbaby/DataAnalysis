drop table employeeperformance
CREATE TABLE employeeperformance(
employee_id integer,
employee_name varchar(50),
quarter varchar(10),
year integer,
sales_amount numeric)

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

INSERT INTO employeeperformance VALUES (103,'Danny','Q2',2024,22000)

SELECT *FROM employeeperformance

------------------------RANKING FUNCTIONS-----------------------------------------------
-------------------------------------------------------------------------------------------
--1.Assign Row Numbers to Each Record by Sales Amount within Each Quarter

SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  ROW_NUMBER() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS sales_rank
FROM employeeperformance;


--2: Rank Employees by Sales Amount within Each Quarter (Allowing Ties)

SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS sales_rank
FROM employeeperformance;

--3: Assign Dense Ranks to Employees by Sales Amount within Each Quarter


SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  DENSE_RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS sales_rank
FROM employeeperformance;

--4:PERCENT_RANK()
SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  PERCENT_RANK() OVER(PARTITION BY employee_id ORDER BY sales_amount) AS percentile_rank
FROM employeeperformance
ORDER BY employee_id, sales_amount;

--5.CUME_DIST()


SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  ROW_NUMBER() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS row_num,
  RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS sales_rank,
  DENSE_RANK() OVER (PARTITION BY quarter ORDER BY sales_amount DESC) AS dens_rank,
  PERCENT_RANK() OVER(PARTITION BY quarter ORDER BY sales_amount) AS percentile_rank
FROM employeeperformance
ORDER BY quarter,sales_amount;

------------------------AGGREGRATE FUNCTIONS-----------------------------------------------
-------------------------------------------------------------------------------------------
--Task 4: Calculate the Average Sales Amount for Each Quarter

SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  ROUND(AVG(sales_amount) OVER (PARTITION BY  year),2)AS avg_sales_year
FROM employeeperformance;

------------------------ANALYTICAL FUNCTIONS-----------------------------------------------
-------------------------------------------------------------------------------------------

--Task5:compare each employee's sales amount between consecutive quarters.
--Compare Sales Amount with the Previous and Next Quarters

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

--find the 3rd entry
SELECT
   employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  NTH_VALUE(sales_amount, 3) OVER (
    PARTITION BY employee_id
    ORDER BY year, quarter
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS third_sale_amount
FROM employeeperformance
ORDER BY employee_id, year, quarter;

--FIRST AND LAST SALE FOR EACH EMPLOYEE

SELECT
  employee_id,
  employee_name,
  quarter,
  year,
  sales_amount,
  FIRST_VALUE(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter) AS firstsale,
  LAST_VALUE(sales_amount) OVER (PARTITION BY employee_id ORDER BY year, quarter ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lastsale
FROM employeeperformance
ORDER BY employee_id, year, quarter;
