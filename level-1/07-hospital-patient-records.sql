-- Level 1 | Question 7: Hospital Patient Records
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display patient_name, blood_group, assigned_doctor for not-discharged patients with blood group A+ or O+; sort alphabetically.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE patient_records (patient_id INT PRIMARY KEY, patient_name VARCHAR(100), blood_group VARCHAR(5), assigned_doctor VARCHAR(100), discharge_date DATE);
INSERT INTO patient_records VALUES
(701,'Anil','O+','Dr. Rao','2026-09-10'),(702,'Bhavya','A+','Dr. Mehta',NULL),(703,'Charan','B+','Dr. Rao','2026-09-18'),(704,'Deepa','AB+','Dr. Kumar',NULL),(705,'Eshan','O+','Dr. Mehta','2026-09-22'),(706,'Farah','A+','Dr. Rao',NULL);

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT patient_name, blood_group, assigned_doctor
FROM patient_records
WHERE discharge_date IS NULL AND blood_group IN('A+', 'O+')
ORDER BY patient_name ASC;

-- FINAL ACCEPTED QUERY
SELECT patient_name, blood_group, assigned_doctor
FROM patient_records
WHERE discharge_date IS NULL AND blood_group IN('A+', 'O+')
ORDER BY patient_name ASC;
