/*
SQL Practice — Subqueries
Dialect: PostgreSQL
Includes the main subquery round and 5 reinforcement questions.
Original attempts are preserved; corrected answers are labelled.
*/

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);
INSERT INTO employees VALUES
(1, 'Arjun', 'IT', 60000),
(2, 'Priya', 'HR', 45000),
(3, 'Rahul', 'IT', 75000),
(4, 'Sneha', 'Finance', 50000),
(5, 'Kiran', 'HR', 55000),
(6, 'Meera', 'Finance', 80000);

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price INT
);
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 65000),
(2, 'Headphones', 'Electronics', 3000),
(3, 'Office Chair', 'Furniture', 12000),
(4, 'Desk', 'Furniture', 18000),
(5, 'Smartphone', 'Electronics', 40000),
(6, 'Bookshelf', 'Furniture', 8000),
(7, 'Smartwatch', 'Electronics', 15000);

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_amount INT
);
INSERT INTO orders VALUES
(101, 1, 2500),
(102, 2, 1800),
(103, 1, 4200),
(104, 3, 3500),
(105, 4, 1200),
(106, 2, 5000),
(107, 5, 2800);

CREATE TABLE students (
    student_id INT,
    student_name VARCHAR(50),
    course_id INT,
    marks INT
);
INSERT INTO students VALUES
(1, 'Asha', 101, 85),
(2, 'Ravi', 102, 72),
(3, 'Neha', 101, 91),
(4, 'Karan', 103, 68),
(5, 'Divya', 102, 88),
(6, 'Arjun', 103, 75),
(7, 'Meera', 101, 79);

/* =========================================================
   MAIN SUBQUERY ROUND — QUESTIONS 1–10
   ========================================================= */

-- Q1. Display the names and salaries of employees who earn more than the overall average salary.
-- Original attempt (correct):
SELECT employee_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Q2. Display the names, departments, and salaries of employees who earn more than the average salary of their own department.
-- Original attempt (correct):
SELECT employee_name, department, salary
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e.department = e2.department
);

-- Q3. Display employees working in a department where at least one employee earns more than ₹70,000.
-- First attempt (logic incorrect; preserved):
SELECT employee_name, department, salary
FROM employees
WHERE salary > 70000;
-- Revised attempt (correct):
SELECT employee_name, department, salary
FROM employees
WHERE department IN (
    SELECT department
    FROM employees
    WHERE salary > 70000
);

-- Q4. Display employees who earn the second-highest distinct salary in the company.
-- Original attempt (correct for the supplied data, PostgreSQL):
SELECT employee_name, department, salary
FROM employees
WHERE salary = (
    SELECT DISTINCT salary
    FROM employees
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
);

-- Q5. Display employees who earn more than every employee in the HR department.
-- First attempt (logic incorrect; preserved):
SELECT employee_name, department, salary
FROM employees
WHERE salary > (
    SELECT MIN(salary)
    FROM employees
    WHERE department = 'HR'
);
-- Revised attempt (correct):
SELECT employee_name, department, salary
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department = 'HR'
);

-- Q6. Display all columns for products priced above the average price in their own category.
-- Original attempt (correct):
SELECT *
FROM products p
WHERE price > (
    SELECT AVG(price)
    FROM products p2
    WHERE p.category = p2.category
);

-- Q7. Display all columns for orders whose amount is above the average amount across all orders.
-- Original attempt (correct):
SELECT *
FROM orders
WHERE order_amount > (
    SELECT AVG(order_amount)
    FROM orders
);

-- Q8. Display customer_id and order_amount for orders belonging to customers who have placed more than one order.
-- Original attempt (correct):
SELECT customer_id, order_amount
FROM orders
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(customer_id) > 1
);

-- Q9. Display names and marks of students who scored the highest marks within their own course; include ties.
-- Original attempt (correct):
SELECT student_name, marks
FROM students s
WHERE marks = (
    SELECT MAX(marks)
    FROM students s2
    WHERE s.course_id = s2.course_id
);

-- Q10. Display customer IDs of customers who have never placed an order above ₹4,000.
-- Initial incomplete attempt (preserved):
SELECT customer_id
FROM orders;
-- Attempt with logic error (preserved):
SELECT customer_id
FROM orders
WHERE order_amount IN (
    SELECT SUM(order_amount)
    FROM orders
    GROUP BY customer_id
    HAVING SUM(order_amount) < 4000
);
-- Final accepted solution:
SELECT DISTINCT customer_id
FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE order_amount > 4000
);
-- Alternative discussed:
-- SELECT DISTINCT customer_id
-- FROM orders o
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM orders o2
--     WHERE o2.customer_id = o.customer_id
--       AND o2.order_amount > 4000
-- );
-- Note: NOT IN can behave unexpectedly if its subquery returns NULL values.

/* =========================================================
   REINFORCEMENT ROUND — QUESTIONS 1–5
   ========================================================= */

-- R1. Display product names and prices for products costing more than the overall average product price.
-- Original attempt (correct):
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- R2. Display names of students who scored more than 80 marks. Must use a subquery.
-- Original attempt (correct):
SELECT student_name
FROM students
WHERE marks IN (
    SELECT marks
    FROM students
    WHERE marks > 80
);
-- Note: A direct WHERE marks > 80 is simpler when a subquery is not required.

-- R3. Display employees earning more than the highest-paid employee in HR.
-- Original attempt (correct):
SELECT employee_name
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department = 'HR'
);

-- R4. Display employees who work in a department where at least one employee earns more than ₹70,000.
-- Original attempt (correct):
SELECT employee_name
FROM employees
WHERE department IN (
    SELECT department
    FROM employees
    WHERE salary > 70000
);

-- R5. Display customer IDs of customers who have never placed an order above ₹4,000. Return each ID once.
-- Accepted attempt:
SELECT customer_id
FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE order_amount > 4000
);
-- Improved to guarantee unique customer IDs:
SELECT DISTINCT customer_id
FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE order_amount > 4000
);

-- Explored but does NOT answer R5 correctly:
SELECT DISTINCT customer_id
FROM orders
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_amount < 4000
);
-- Why not: customers 1 and 2 also have an order below ₹4,000, but they each have another order above ₹4,000.
-- This checks "has at least one order below ₹4,000", not "never has an order above ₹4,000".
