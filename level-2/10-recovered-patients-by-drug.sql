-- Level 2 | Question 10: Recovered Patients by Drug
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display drug and total patients recovered across conditions; include totals above 100; sort descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE treatment_outcomes (outcome_id INT PRIMARY KEY, drug_name VARCHAR(100), condition VARCHAR(100), patients_treated INT, patients_recovered INT);
INSERT INTO treatment_outcomes VALUES
(1,'MedA','Condition X',80,60),(2,'MedB','Condition Y',100,70),(3,'MedA','Condition Y',50,40),(4,'MedC','Condition X',120,90),(5,'MedB','Condition X',60,45),(6,'MedC','Condition Y',80,56);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT drug_name, SUM(patients_recovered) AS total_recovered
FROM treatment_outcomes
GROUP BY drug_name
HAVING SUM(patients_recovered) > 100
ORDER BY total_recovered DESC;

-- FINAL ACCEPTED QUERY
SELECT drug_name, SUM(patients_recovered) AS total_recovered
FROM treatment_outcomes
GROUP BY drug_name
HAVING SUM(patients_recovered) > 100
ORDER BY total_recovered DESC;
