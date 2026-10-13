-- Problem: Compare ROW_NUMBER(), RANK(), and DENSE_RANK() for salaries.
-- Topic: Window functions and ties

DROP TABLE IF EXISTS salary_demo;

CREATE TABLE salary_demo (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT
);

INSERT INTO salary_demo VALUES
(1, 'Rahul', 90000),
(2, 'Priya', 80000),
(3, 'Arjun', 80000),
(4, 'Sneha', 70000),
(5, 'Kiran', 60000);

SELECT
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC, name) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM salary_demo
ORDER BY salary DESC, name;

-- ROW_NUMBER(): unique number for each row.
-- RANK(): ties share a rank; later rank numbers are skipped.
-- DENSE_RANK(): ties share a rank; later rank numbers are not skipped.
