-- Problem: Show each department's average salary and employee count.
-- Topic: CTE, JOIN, GROUP BY, aggregate functions

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary NUMERIC(10, 2)
);

INSERT INTO departments VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance');

INSERT INTO employees VALUES
(1, 'Rahul', 10, 60000),
(2, 'Priya', 20, 45000),
(3, 'Arjun', 10, 75000),
(4, 'Sneha', 30, 55000);

WITH department_stats AS (
    SELECT
        department_id,
        AVG(salary) AS average_salary,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY department_id
)
SELECT
    d.department_name,
    ds.average_salary,
    ds.employee_count
FROM departments AS d
JOIN department_stats AS ds
    ON d.department_id = ds.department_id
ORDER BY d.department_id;
