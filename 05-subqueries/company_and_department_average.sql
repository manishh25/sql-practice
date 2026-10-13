-- Problem A: Employees earning more than the company average.
-- Problem B: Employees earning more than their own department's average.
-- Topic: Scalar subquery and correlated subquery

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

-- A. Salary greater than the company-wide average.
SELECT name, department, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

-- B. Salary greater than the average for that employee's department.
SELECT e.name, e.department, e.salary
FROM employees AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees AS e2
    WHERE e2.department = e.department
)
ORDER BY e.department, e.salary DESC;
