-- Problem: Pivot consent rows into separate Phone and Email columns.
-- Topic: CASE WHEN, MAX(), GROUP BY
-- Database: PostgreSQL

DROP TABLE IF EXISTS patient_consent;

CREATE TABLE patient_consent (
    patient_id INT,
    patient_name VARCHAR(50),
    consent_type VARCHAR(20),
    consent_status VARCHAR(3)
);

INSERT INTO patient_consent (patient_id, patient_name, consent_type, consent_status) VALUES
(101, 'Rahul', 'Phone', 'YES'),
(101, 'Rahul', 'Email', 'NO'),
(102, 'Priya', 'Phone', 'NO'),
(102, 'Priya', 'Email', 'YES'),
(103, 'Arjun', 'Phone', 'YES'),
(103, 'Arjun', 'Email', 'YES'),
(104, 'Sneha', 'Phone', 'NO'),
(104, 'Sneha', 'Email', 'NO');

-- Solution: one row per patient, with a column for each consent type.
SELECT
    patient_id,
    patient_name,
    MAX(CASE WHEN consent_type = 'Phone' THEN consent_status END) AS phone,
    MAX(CASE WHEN consent_type = 'Email' THEN consent_status END) AS email
FROM patient_consent
GROUP BY patient_id, patient_name
ORDER BY patient_id;

-- Expected output:
-- 101 | Rahul | YES | NO
-- 102 | Priya | NO  | YES
-- 103 | Arjun | YES | YES
-- 104 | Sneha | NO  | NO
--
-- Note: MAX() is used to combine the conditional values into one row per patient.
-- Missing consent records remain NULL; NULL should not automatically be treated as NO.
