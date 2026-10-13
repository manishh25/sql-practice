-- Problem: Find employees earning either of the top two distinct salary levels
-- in each department. Include all employees tied at those salary levels.
-- Topic: CTE, PARTITION BY, DENSE_RANK()

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

WITH emp_details AS (
    SELECT
        name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)
SELECT name, department, salary
FROM emp_details
WHERE salary_rank <= 2
ORDER BY department, salary DESC, name;
