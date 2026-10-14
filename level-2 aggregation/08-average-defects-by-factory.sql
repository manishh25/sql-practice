-- Level 2 | Question 8: Average Defects by Factory
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display factory and average defects; include averages above 4; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE batch_inspections (inspection_id INT PRIMARY KEY, product_name VARCHAR(100), factory VARCHAR(100), defects_found INT);
INSERT INTO batch_inspections VALUES
(1,'MedA','Factory X',4),(2,'MedB','Factory Y',7),(3,'MedC','Factory X',3),(4,'MedA','Factory Y',6),(5,'MedB','Factory X',5),(6,'MedC','Factory Y',2);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT factory, AVG(defects_found) AS avg_defects
FROM batch_inspections
GROUP BY factory
HAVING AVG(defects_found) > 4
ORDER BY avg_defects DESC;

-- FINAL ACCEPTED QUERY
SELECT factory, AVG(defects_found) AS avg_defects
FROM batch_inspections
GROUP BY factory
HAVING AVG(defects_found) > 4
ORDER BY avg_defects DESC;
