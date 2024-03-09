DROP TABLE employee
CREATE TABLE employee(
	id numeric,
name varchar(30), 
	salary numeric,
manager_id numeric)

ALTER TABLE employee ADD COLUMN salary numeric

INSERT INTO employee VALUES(1,'John Smith',1000,3),
(2,'Jane Ander',1200,3),
(3,'Tom Cruise',1500,4),
(4,'Annie',2000,NULL),
(5,'Dav Smith',4000,1)

INSERT INTO employee VALUES(3,'errr',1000,3)
delete from employee where name='errr'

SELECT *FROM employee


SELECT * FROM
    employee e1 JOIN
    employee e2 ON e1.manager_id = e2.id;
	
--To obtain a list of employees and their immediate managers 


SELECT  e1.name AS Employee,
    e2.name AS Manager FROM
    employee e1 JOIN
    employee e2 ON e1.manager_id = e2.id;
	
--to get the level of each employees

WITH RECURSIVE OrgChart AS (
  SELECT
    id,
    name,
    manager_id,
    1 AS Level
  FROM employee
  WHERE manager_id IS NULL
  UNION ALL
  SELECT
    e.id,
    e.name,
    e.manager_id,
    oc.Level + 1
  FROM Employee e
  JOIN OrgChart oc ON e.manager_id = oc.id
)
SELECT * FROM OrgChart;

--to check what error will get if we don't use recursive key word
WITH  OrgChart AS (
  SELECT
    id,
    name,
    manager_id,
    1 AS Level
  FROM employee
  WHERE manager_id IS NULL
  UNION ALL
  SELECT
    e.id,
    e.name,
    e.manager_id,
    oc.Level + 1
  FROM Employee e
  JOIN OrgChart oc ON e.manager_id = oc.id
)
SELECT * FROM OrgChart;


--display the reprties chain

WITH RECURSIVE OrgChart AS (
  SELECT
    id,
    name,
    manager_id,
    name::text AS ManagementChain -- Initialize as TEXT, no need for explicit CAST
  FROM employee
  WHERE manager_id IS NULL -- Top-level managers who have no managers
  
  UNION ALL
  
  SELECT
    e.id,
    e.name,
    e.manager_id,
    oc.ManagementChain || ' -> ' || e.name::text -- Concatenate the management chain
  FROM employee e
  JOIN OrgChart oc ON e.manager_id = oc.id -- Join on manager_id to find the next level manager
)
SELECT * FROM OrgChart;




--display the skip level manager

WITH  OrgChart AS (
  SELECT
    e.id,
    e.name,
    m.manager_id AS nextlevelmanagerid,
    m.name AS SkipLevelManager -- Direct manager's name for the base case
  FROM employee e
  LEFT JOIN employee m ON e.manager_id = m.id -- Join to get the direct manager
  WHERE m.manager_id IS NOT NULL -- Exclude top-level managers who have no managers
  )
  
  SELECT
    oc.name,
    e.name
  FROM OrgChart oc
  JOIN employee e ON oc.nextlevelmanagerid = e.id 


