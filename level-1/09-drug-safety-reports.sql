-- Level 1 | Question 9: Drug Safety Reports
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display all columns for Severe or Moderate reports, patient age above 50, reviewed status; sort age descending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE adverse_event_reports (report_id INT PRIMARY KEY, drug_name VARCHAR(100), severity VARCHAR(30), patient_age INT, report_status VARCHAR(30));
INSERT INTO adverse_event_reports VALUES
(901,'Drug A','Severe',67,'Reviewed'),(902,'Drug B','Mild',32,'Pending'),(903,'Drug A','Moderate',54,'Reviewed'),(904,'Drug C','Severe',45,'Pending'),(905,'Drug B','Severe',71,'Reviewed'),(906,'Drug C','Mild',28,'Reviewed');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT *
FROM adverse_event_reports
WHERE severity IN('Severe', 'Moderate') AND patient_age > 50 AND report_status = 'Reviewed'
ORDER BY patient_age DESC;

-- FINAL ACCEPTED QUERY
SELECT *
FROM adverse_event_reports
WHERE severity IN('Severe', 'Moderate') AND patient_age > 50 AND report_status = 'Reviewed'
ORDER BY patient_age DESC;
