-- Problem: Find the highest-paid employee(s) in every department.
-- Include all ties at the highest salary.
-- Topic: PARTITION BY and RANK()

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees VALUES
(1, 'Rahul', 'IT', 80000),
(2, 'Priya', 'IT', 70000),
(3, 'Arjun', 'IT', 70000),
(4, 'Sneha', 'HR', 60000),
(5, 'Kiran', 'HR', 50000),
(6, 'Meena', 'HR', 50000),
(7, 'Aditya', 'Finance', 90000),
(8, 'Ravi', 'Finance', 75000);

WITH ranked_employees AS (
    SELECT
        name,
        department,
        salary,
        RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)
SELECT name, department, salary
FROM ranked_employees
WHERE salary_rank = 1
ORDER BY department, name;
