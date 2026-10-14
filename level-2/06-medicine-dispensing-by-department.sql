-- Level 2 | Question 6: Medicine Dispensing by Department
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display department and total quantity dispensed; include totals at least 30; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE medicine_dispensing (dispense_id INT PRIMARY KEY, medicine_name VARCHAR(100), department VARCHAR(100), quantity_dispensed INT, unit_price NUMERIC(10,2));
INSERT INTO medicine_dispensing VALUES
(1,'MedA','Emergency',30,100),(2,'MedB','Oncology',20,250),(3,'MedA','Oncology',15,100),(4,'MedC','Emergency',40,80),(5,'MedB','Pediatrics',25,250),(6,'MedC','Oncology',10,80);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT department, SUM(quantity_dispensed) AS total_quantity_dispensed
FROM medicine_dispensing
GROUP BY department
HAVING SUM(quantity_dispensed) >= 30
ORDER BY total_quantity_dispensed DESC;

-- FINAL ACCEPTED QUERY
SELECT department, SUM(quantity_dispensed) AS total_quantity_dispensed
FROM medicine_dispensing
GROUP BY department
HAVING SUM(quantity_dispensed) >= 30
ORDER BY total_quantity_dispensed DESC;
