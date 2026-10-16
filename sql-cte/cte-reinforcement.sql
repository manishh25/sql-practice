-- SQL CTE Practice: Reinforcement Questions 1-5
-- Dialect: PostgreSQL
-- Includes sample data, exact task wording, original attempts, explanations,
-- and accepted/corrected solutions from the practice session.

DROP TABLE IF EXISTS contractors;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS orders;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(30),
    salary INT
);

INSERT INTO employees VALUES
(1, 'Arjun', 'IT', 60000),
(2, 'Priya', 'HR', 45000),
(3, 'Rahul', 'IT', 75000),
(4, 'Sneha', 'Finance', 50000),
(5, 'Kiran', 'HR', 55000),
(6, 'Meera', 'Finance', 80000);

CREATE TABLE departments (
    department VARCHAR(30) PRIMARY KEY,
    location VARCHAR(50)
);

INSERT INTO departments VALUES
('IT', 'Hyderabad'),
('HR', 'Chennai'),
('Finance', 'Bengaluru'),
('Marketing', 'Mumbai');

CREATE TABLE contractors (
    contractor_id INT PRIMARY KEY,
    contractor_name VARCHAR(50),
    department VARCHAR(30)
);

INSERT INTO contractors VALUES
(101, 'Kiran', 'IT'),
(102, 'Meera', 'Marketing'),
(103, 'Vikram', 'HR');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount INT,
    order_status VARCHAR(20)
);

INSERT INTO orders VALUES
(101, 1, 2500, 'Completed'),
(102, 2, 4000, 'Pending'),
(103, 1, 1500, 'Completed'),
(104, 3, 6000, 'Cancelled'),
(105, 2, 3000, 'Completed'),
(106, 4, 5000, 'Completed'),
(107, 3, 2000, 'Completed');


-- ============================================================
-- QUESTION 1/5: MULTIPLE CTEs + LEFT JOIN + COALESCE
-- Exact task:
-- Write a SQL query using multiple CTEs to display each department's
-- name, location, and average employee salary. Include departments that
-- have no employees, and show their average salary as 0.

-- User's first attempt (incorrect):
WITH details AS (
    SELECT department, location, AVG(salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.department = d.department
    GROUP BY d.department
)
SELECT department, avg_salary, COALESCE(avg_salary, 0)
FROM employees e
JOIN details d2 ON e.department = d2.department;

-- Why it was incorrect:
-- INNER JOIN omits departments without employees; location was not grouped;
-- employees was joined again unnecessarily; it did not meet the multiple-CTE
-- requirement and COALESCE was not applied to the final aggregate.

-- User's second attempt (nearly correct):
WITH emp_details AS (
    SELECT employee_name, department, salary FROM employees
),
department_details AS (
    SELECT department, location FROM departments
)
SELECT department, location, AVG(salary) AS avg_salary
FROM department_details d
LEFT JOIN emp_details e ON d.department = e.department
GROUP BY department, location;

-- Why it needed one change:
-- This includes empty departments, but AVG is NULL for Marketing.
-- The task requires 0 instead of NULL.

-- Accepted/corrected solution:
WITH emp_details AS (
    SELECT employee_name, department, salary FROM employees
),
department_details AS (
    SELECT department, location FROM departments
)
SELECT d.department, d.location,
       COALESCE(AVG(e.salary), 0) AS avg_salary
FROM department_details d
LEFT JOIN emp_details e ON d.department = e.department
GROUP BY d.department, d.location
ORDER BY d.department;

-- Expected output:
-- Finance   | Bengaluru  | 65000
-- HR        | Chennai    | 50000
-- IT        | Hyderabad  | 75000
-- Marketing | Mumbai     | 0


-- ============================================================
-- QUESTION 2/5: MULTIPLE CTEs + OVERALL AND DEPARTMENT AVERAGES
-- Exact task:
-- Write a SQL query using multiple CTEs to find each department's average
-- salary and then display only employees who earn more than the overall
-- average salary AND more than their own department's average salary.

-- User's CTE definitions (correct):
WITH emp_details AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
emp2 AS (
    SELECT AVG(salary) AS avg2
    FROM employees
)
SELECT employee_name
FROM employees e
JOIN emp_details e2 ON e.department = e2.department
CROSS JOIN emp2 e3
WHERE e.salary > e2.avg_salary
  AND e.salary > e3.avg2;

-- User's attempted join condition (incorrect; preserved for learning):
-- JOIN emp2 e3 ON e2.AVG(salary) = e3.AVG(salary)
-- Why incorrect: AVG(salary) is not a column exposed by either CTE.
-- The output columns are avg_salary and avg2. The averages are compared
-- with each employee's salary in WHERE; the single-row overall average
-- CTE can be CROSS JOINed to make its value available to each employee.

-- Expected output with this dataset:
-- Meera
-- Vikram


-- ============================================================
-- QUESTION 3/5: FILTERING BEFORE AGGREGATION
-- Exact task:
-- Write a SQL query using a CTE to calculate the total amount of completed
-- orders for each customer, then display only customers whose completed-order
-- total is greater than 3000.

-- User's answer (correct):
WITH orders_details AS (
    SELECT customer_id, SUM(order_amount) AS total_order_amount
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT customer_id
FROM orders_details
WHERE total_order_amount > 3000;

-- Expected output:
-- customer_id 1 (2500 + 1500 = 4000)
-- customer_id 4 (5000)
-- Customer 2's completed total is exactly 3000, so it does not qualify.
-- Customer 3's completed total is 2000; cancelled order 6000 is excluded.


-- ============================================================
-- QUESTION 4/5: CTE + UNION ALL
-- Exact task:
-- Write a SQL query using CTEs and UNION ALL to combine the employee names
-- and contractor names into a single result with two columns: person_name
-- and department. Include everyone from both tables.

-- User's answer (works, but returns an extra ID column):
WITH details AS (
    SELECT employee_id, employee_name AS person_name, department
    FROM employees
    UNION ALL
    SELECT contractor_id, contractor_name AS person_name, department
    FROM contractors
)
SELECT * FROM details;

-- Why it needed a change:
-- The task requests only person_name and department.

-- Accepted/corrected solution:
WITH details AS (
    SELECT employee_name AS person_name, department FROM employees
    UNION ALL
    SELECT contractor_name AS person_name, department FROM contractors
)
SELECT person_name, department
FROM details
ORDER BY person_name;

-- UNION ALL preserves duplicates; UNION removes duplicate rows.


-- ============================================================
-- Add Vikram for Question 5, as he was introduced in that question's table.
INSERT INTO employees (employee_id, employee_name, department, salary)
VALUES (7, 'Vikram', 'IT', 90000);

-- ============================================================
-- QUESTION 5/5: CTE + WINDOW FUNCTION
-- Exact task:
-- Write a SQL query using a CTE to find the second-highest distinct salary
-- in each department, then display the department, employee name, and salary
-- of the employee(s) earning that salary.

-- User's answer (correct):
WITH emp_details AS (
    SELECT employee_name, department, salary,
           DENSE_RANK() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS dense_rank
    FROM employees
)
SELECT department, employee_name, salary
FROM emp_details
WHERE dense_rank = 2;

-- Expected output:
-- Finance | Sneha | 50000
-- HR      | Priya | 45000
-- IT      | Arjun | 60000


-- ============================================================
-- LEARNING SUMMARY
-- ============================================================
-- Patterns practised:
-- 1. Multiple CTEs in one WITH clause
-- 2. LEFT JOIN to retain unmatched departments
-- 3. COALESCE to replace NULL aggregate output with 0
-- 4. Comparing individual rows against group and overall averages
-- 5. CROSS JOIN to make a single-row aggregate available to every row
-- 6. Filtering rows before aggregation
-- 7. UNION ALL with a CTE
-- 8. CTE + DENSE_RANK() window function
