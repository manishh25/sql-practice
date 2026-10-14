-- Level 1 | Question 1: Pharmacy Available Medicines
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display medicine_name and price for Available medicines costing more than 70; sort price descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE medicine_orders (order_id INT PRIMARY KEY, medicine_name VARCHAR(100), category VARCHAR(100), price NUMERIC(10,2), stock_status VARCHAR(30));
INSERT INTO medicine_orders VALUES
(101,'Paracetamol','Pain Relief',45,'Available'),(102,'Cetirizine','Allergy',80,'Available'),(103,'Amoxicillin','Antibiotic',150,'Out of Stock'),(104,'Vitamin C','Supplement',120,'Available'),(105,'Ibuprofen','Pain Relief',95,'Out of Stock'),(106,'Antacid','Digestive',60,'Available');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT medicine_name, price 
FROM medicine_orders
WHERE stock_status = 'Available' AND price > 70
ORDER BY price DESC;

-- FINAL ACCEPTED QUERY
SELECT medicine_name, price 
FROM medicine_orders
WHERE stock_status = 'Available' AND price > 70
ORDER BY price DESC;
