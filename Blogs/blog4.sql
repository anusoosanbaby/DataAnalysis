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

INSERT INTO employeeperformance VALUES
(101,'Alice','Q2',2023,20000)

SELECT *FROM employeeperformance
------PRECEDING

SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as CurrentAndPrev2
FROM employeeperformance
ORDER BY employee_id;

--FOLLOWING

SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN  CURRENT ROW AND 2 FOLLOWING) as CurrentAndFollow2
FROM employeeperformance
ORDER BY employee_id;



--PRECEDING & FOLLOWING

SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as BeforeandAfter
FROM employeeperformance
ORDER BY employee_id;


--UNBOUNDED PRECEDING

SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS UNBOUNDED PRECEDING ) as UnboundPreceding
FROM employeeperformance
ORDER BY employee_id;


SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as UnboudPreceding
FROM employeeperformance
ORDER BY employee_id;

--UNBOUNED FOLLOWING

SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) as UnboundFollowing
FROM employeeperformance
ORDER BY employee_id;

--ROWS and RANGE
SELECT employee_id, employee_name,quarter,year,sales_amount,
  SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 ROWS UNBOUNDED PRECEDING ) as RowsUnboundprece,
 SUM(sales_amount) OVER (PARTITION by employee_id
 ORDER BY sales_amount
 RANGE UNBOUNDED PRECEDING ) as RangeUnboundprece
FROM employeeperformance
ORDER BY employee_id;



