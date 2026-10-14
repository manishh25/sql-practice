-- Level 2 | Question 2: Hospital Visits by Department
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display department and visit count; include departments with at least 3 visits; sort count descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE patient_visits (visit_id INT PRIMARY KEY, department VARCHAR(100), patient_id INT, consultation_fee NUMERIC(10,2));
INSERT INTO patient_visits VALUES
(1,'Cardiology',101,1200),(2,'Neurology',102,1500),(3,'Cardiology',103,1000),(4,'Pediatrics',104,800),(5,'Neurology',105,1800),(6,'Cardiology',106,1400),(7,'Pediatrics',107,900);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT department, COUNT(*)
FROM patient_visits
GROUP BY department
HAVING COUNT(*) >= 3
ORDER BY COUNT(*) DESC;

-- FINAL ACCEPTED QUERY
SELECT department, COUNT(*) AS visit_count
FROM patient_visits
GROUP BY department
HAVING COUNT(*) >= 3
ORDER BY visit_count DESC;
