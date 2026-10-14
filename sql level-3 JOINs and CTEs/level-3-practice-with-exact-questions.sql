-- SQL PRACTICE — LEVEL 3
-- Exact question wording, original attempts, and accepted/corrected queries.
-- Only logic errors are marked incorrect. Spelling, formatting, and alias-name mismatches are not.
-- PostgreSQL compatible.

-- SCENARIO 1: HOSPITAL APPOINTMENTS (Questions 1–3)
CREATE TABLE doctors (doctor_id INT PRIMARY KEY, doctor_name VARCHAR(50), specialty VARCHAR(50));
CREATE TABLE appointments (appointment_id INT PRIMARY KEY, patient_name VARCHAR(50), doctor_id INT REFERENCES doctors(doctor_id));
INSERT INTO doctors VALUES
(1,'Dr. Rao','Cardiology'),(2,'Dr. Mehta','Neurology'),(3,'Dr. Kumar','Pediatrics'),(4,'Dr. Shah','Dermatology');
INSERT INTO appointments VALUES
(101,'Ananya',1),(102,'Rahul',2),(103,'Priya',1),(104,'Kiran',3),(105,'Meera',2),(106,'Arjun',1);

-- QUESTION 1
-- "Write a query to display each doctor_name and the number of appointments assigned to that doctor.
-- Include only doctors who have at least one appointment. Display the appointment count with the alias
-- appointment_count. Sort by appointment count from highest to lowest."
-- RESULT: CORRECT
-- Original attempt
SELECT doctor_name, COUNT(appointment_id) AS appointment_count
FROM doctors d JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY doctor_name
ORDER BY appointment_count DESC;
-- Accepted query: same as original.

-- QUESTION 2
-- "Using the same doctors and appointments tables, write a query to display every doctor's name and
-- their appointment count, including doctors who have zero appointments. Sort the results by
-- doctor_name in ascending order."
-- RESULT: CORRECT
-- Original attempt
SELECT doctor_name, COUNT(appointment_id) AS appointment_count
FROM doctors d LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY doctor_name
ORDER BY doctor_name ASC;
-- Accepted query: same as original.

-- QUESTION 3
-- "Using the same tables, write a query to display the doctor name and patient name for appointments
-- handled by doctors whose specialty is Cardiology. Sort the results by patient_name in ascending order."
-- RESULT: CORRECT
-- Original attempt
SELECT doctor_name, patient_name
FROM doctors d LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE specialty = 'Cardiology'
ORDER BY patient_name ASC;
-- Accepted query: same as original.

-- SCENARIO 2: PHARMACY SALES (Questions 4–6)
CREATE TABLE medicines (medicine_id INT PRIMARY KEY, medicine_name VARCHAR(50), category VARCHAR(50));
CREATE TABLE sales (sale_id INT PRIMARY KEY, medicine_id INT REFERENCES medicines(medicine_id), quantity_sold INT, sale_amount NUMERIC(10,2));
INSERT INTO medicines VALUES
(1,'Paracetamol','Pain Relief'),(2,'Cetirizine','Allergy'),(3,'Amoxicillin','Antibiotic'),(4,'Omeprazole','Digestive');
INSERT INTO sales VALUES
(101,1,10,500),(102,2,5,250),(103,1,8,400),(104,3,4,800),(105,2,7,350);

-- QUESTION 4
-- "Write a query to display the medicine name, quantity sold, and sale amount for every sale.
-- Sort the results by medicine_name in ascending order."
-- RESULT: CORRECT
-- Original attempt
SELECT medicine_name, quantity_sold, sale_amount
FROM medicines m JOIN sales s ON m.medicine_id = s.medicine_id
ORDER BY medicine_name ASC;
-- Accepted query: same as original.

-- QUESTION 5
-- "Using the same medicines and sales tables, write a query to display each medicine's name and total
-- quantity sold. Include only medicines that have at least one sale. Sort by total quantity sold from
-- highest to lowest."
-- RESULT: LOGIC CORRECT. WHERE medicine_id IS NOT NULL is redundant with INNER JOIN. Because both
-- tables have medicine_id, the unqualified reference may be ambiguous in PostgreSQL; not a logic error.
-- Original attempt
SELECT medicine_name, SUM(quantity_sold) AS total_quantity
FROM medicines m JOIN sales s ON m.medicine_id = s.medicine_id
WHERE medicine_id IS NOT NULL
GROUP BY medicine_name
ORDER BY total_quantity DESC;
-- Accepted query (redundant WHERE removed)
SELECT medicine_name, SUM(quantity_sold) AS total_quantity
FROM medicines m JOIN sales s ON m.medicine_id = s.medicine_id
GROUP BY medicine_name
ORDER BY total_quantity DESC;

-- QUESTION 6
-- "Using the same medicines and sales tables, write a query to display every medicine's name and its
-- total sales amount, including medicines that have no sales. Show 0 as the total sales amount for
-- medicines without any sales, and sort alphabetically by medicine name."
-- RESULT: CORRECT
-- Original attempt
SELECT medicine_name, COALESCE(SUM(sale_amount), 0) AS total_sales
FROM medicines m LEFT JOIN sales s ON m.medicine_id = s.medicine_id
GROUP BY medicine_name
ORDER BY medicine_name ASC;
-- Accepted query: same as original.

-- SCENARIO 3: BANKING (Questions 7–10)
CREATE TABLE customers (customer_id INT PRIMARY KEY, customer_name VARCHAR(50), city VARCHAR(50));
CREATE TABLE transactions (transaction_id INT PRIMARY KEY, customer_id INT REFERENCES customers(customer_id), transaction_type VARCHAR(20), amount NUMERIC(10,2));
INSERT INTO customers VALUES
(1,'Anil','Hyderabad'),(2,'Priya','Chennai'),(3,'Rahul','Bengaluru'),(4,'Sneha','Hyderabad');
INSERT INTO transactions VALUES
(101,1,'Deposit',5000),(102,2,'Withdrawal',2000),(103,1,'Withdrawal',1000),(104,3,'Deposit',7000),(105,2,'Deposit',3000);

-- QUESTION 7
-- "Write a query to display the customer name and transaction type for customers who made a Deposit.
-- Sort the results by customer_name in ascending order."
-- RESULT: CORRECT
-- Original attempt
SELECT customer_name, transaction_type
FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
WHERE transaction_type = 'Deposit'
ORDER BY customer_name ASC;
-- Accepted query: same as original.

-- QUESTION 8
-- "Using the same customers and transactions tables, write a query to display each customer's name and
-- their total transaction amount, including customers who have no transactions. Show 0 for customers
-- without transactions. Name the calculated column total_amount. Sort by total_amount from highest to lowest."
-- RESULT: CORRECT
-- Original attempt
SELECT customer_name, COALESCE(SUM(amount), 0) AS total_amount
FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY customer_name
ORDER BY total_amount DESC;
-- Accepted query: same as original.

-- QUESTION 9
-- "Using the same customers and transactions tables, write a query to display the names of customers who
-- have made at least one transaction, along with their number of transactions. Display customer_name and
-- transaction_count. Include only customers who have transactions. Sort by transaction_count from highest to lowest."
-- RESULT: CORRECT
-- Original attempt
SELECT customer_name, COUNT(transaction_id) AS transaction_count
FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY customer_name
ORDER BY transaction_count DESC;
-- Accepted query: same as original.

-- QUESTION 10
-- "Using the same customers and transactions tables, write a query to display each customer's name and
-- their total deposit amount. Include every customer, even those with no deposits. Show 0 for customers
-- with no deposits. Name the calculated column total_deposits. Sort by customer_name in ascending order."
-- RESULT: LOGIC ERROR in original: WHERE transaction_type = 'Deposit' removes customers without deposits.
-- Original attempt
SELECT customer_name, COALESCE(SUM(amount), 0) AS total_deposits
FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE transaction_type = 'Deposit'
GROUP BY customer_name
ORDER BY customer_name ASC;
-- Corrected query
SELECT customer_name,
       SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE 0 END) AS total_deposits
FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY customer_name
ORDER BY customer_name ASC;

-- FOLLOW-UP PRACTICE (after Level 3)
-- "Using the customers and transactions tables, write a query to display each customer's name and their
-- total withdrawal amount. Every customer must appear, including those who have never made a withdrawal."
-- RESULT: LOGIC CORRECT. The original alias total_amount differs from the requested total_withdrawals;
-- alias mismatch is not marked incorrect.
-- Original attempt
SELECT customer_name,
       SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_amount
FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY customer_name;
-- Accepted query with requested alias
SELECT customer_name,
       SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_withdrawals
FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY customer_name;
