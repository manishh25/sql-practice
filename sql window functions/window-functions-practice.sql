-- SQL Practice: Level 6 - Window Functions
-- Dialect: PostgreSQL
--
-- Sample table:
-- CREATE TABLE employees (
--   employee_id INT PRIMARY KEY,
--   employee_name TEXT,
--   department TEXT,
--   salary NUMERIC
-- );
--
-- INSERT INTO employees VALUES
-- (1, 'Arjun', 'IT', 60000),
-- (2, 'Priya', 'HR', 45000),
-- (3, 'Rahul', 'IT', 75000),
-- (4, 'Sneha', 'Finance', 50000),
-- (5, 'Kiran', 'HR', 55000),
-- (6, 'Meera', 'Finance', 80000),
-- (7, 'Vikram', 'IT', 60000);

-- Q1. Display each employee's name, department, salary, and a row number
-- within each department ordered by salary highest to lowest.
-- User attempt: CORRECT
SELECT employee_name, department, salary,
       ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS Row_rank
FROM employees;

-- Q2. Rank salaries within each department, with ties sharing rank and
-- the next rank skipping accordingly. User attempt: CORRECT
SELECT employee_name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS Ranks
FROM employees;

-- Q3. Rank salaries within each department, with ties sharing rank and
-- no gaps after ties. User attempt: CORRECT
SELECT employee_name, department, salary,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM employees;

-- Q4. Show the previous employee salary within each department when ordered
-- lowest to highest. Show NULL when there is no previous row. User attempt: CORRECT
SELECT employee_name, department, salary,
       LAG(salary) OVER (PARTITION BY department ORDER BY salary ASC) AS Previous_employee_salary
FROM employees;

-- Q5. Show the next employee salary within each department when ordered
-- lowest to highest. Show NULL when there is no next row. User attempt: CORRECT
SELECT employee_name, department, salary,
       LEAD(salary) OVER (PARTITION BY department ORDER BY salary ASC) AS Next_employee_salary
FROM employees;

-- Q6. Show each employee and their department's average salary. Keep all rows.
-- User attempt: CORRECT
SELECT employee_name, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary
FROM employees;

-- Q7. Show a running salary total within each department ordered low to high.
-- User attempt: CORRECT
SELECT employee_name, department, salary,
       SUM(salary) OVER (PARTITION BY department ORDER BY salary ASC) AS running_total
FROM employees;

-- Note for Q7: tied salaries are peers under PostgreSQL's default frame and
-- can show the same cumulative total. For strictly row-by-row totals, use:
-- SUM(salary) OVER (
--   PARTITION BY department
--   ORDER BY salary ASC, employee_id
--   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- ) AS running_total

-- Q8. Show each employee and the difference between their salary and
-- their department average. Keep all employees.
-- Original attempt (incorrect in PostgreSQL because SELECT aliases cannot
-- be reused in another expression in the same SELECT list):
-- SELECT employee_name, department, salary,
--        AVG(salary) OVER (PARTITION BY department) AS avg_salary,
--        salary - avg_salary AS difference_salary
-- FROM employees;
-- Corrected query:
SELECT employee_name, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS avg_salary,
       salary - AVG(salary) OVER (PARTITION BY department) AS difference_salary
FROM employees;

-- Q9. Return employees with the highest salary in their department,
-- including ties.
-- Original attempt (incorrect: missing comma after salary, and window-function
-- aliases cannot be filtered in WHERE at the same query level):
-- SELECT employee_name, salary
-- DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
-- FROM employees
-- WHERE dense_rank = 1;
--
-- Corrected CTE solution:
WITH emp_details AS (
    SELECT employee_name, department, salary,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
    FROM employees
)
SELECT employee_name
FROM emp_details
WHERE dense_rank = 1;

-- Alternative correlated-subquery solution:
-- SELECT employee_name, department, salary
-- FROM employees e
-- WHERE salary = (
--   SELECT MAX(salary)
--   FROM employees
--   WHERE department = e.department
-- );

-- Q10. Show each employee and the percentage of their department's total
-- salary represented by their own salary. Keep all employees.
-- Formula: employee salary / department total salary * 100.
SELECT employee_name, department, salary,
       ROUND(
           salary * 100.0 / SUM(salary) OVER (PARTITION BY department),
           2
       ) AS salary_percentage
FROM employees;

-- I didnt get answer for 10th.
-- Expected percentages:
-- IT: Arjun 30.77%, Rahul 38.46%, Vikram 30.77%
-- HR: Priya 45.00%, Kiran 55.00%
-- Finance: Sneha 38.46%, Meera 61.54%
--
-- Note: A final ORDER BY is needed if you require a guaranteed output order.

-- wrong answers - 8th, 7th
-- tried CTE method for 9th question after first try.