-- SQL Practice: Patient Consent Pivot
-- Dialect: PostgreSQL
-- Topic: Pivoting rows into columns using conditional aggregation.

DROP TABLE IF EXISTS patient_consent;

CREATE TABLE patient_consent (
    patient_id INT,
    patient_name TEXT,
    consent_type TEXT,
    consent_status TEXT
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

-- QUESTION 1:
-- Convert the table so each patient appears on one row, with separate
-- columns for phone consent and email consent.

-- Reconstructed accepted approach from the available conversation:
SELECT
    patient_id,
    patient_name,
    MAX(CASE WHEN consent_type = 'Phone' THEN consent_status END) AS Phone,
    MAX(CASE WHEN consent_type = 'Email' THEN consent_status END) AS Email
FROM patient_consent
GROUP BY patient_id, patient_name
ORDER BY patient_id;

-- Expected result:
-- patient_id | patient_name | Phone | Email
-- 101        | Rahul        | YES   | NO
-- 102        | Priya        | NO    | YES
-- 103        | Arjun        | YES   | YES
-- 104        | Sneha        | NO    | NO

-- QUESTION 2 (FOLLOW-UP):
-- Suppose the company also records SMS consent using consent_type = 'SMS'.
-- Modify the query to produce three consent columns: Phone, Email, and SMS.

-- Add example SMS records for this follow-up.
INSERT INTO patient_consent (patient_id, patient_name, consent_type, consent_status) VALUES
(101, 'Rahul', 'SMS', 'YES'),
(102, 'Priya', 'SMS', 'NO'),
(103, 'Arjun', 'SMS', 'YES');
-- Sneha has no SMS record, so her SMS output is NULL.

SELECT
    patient_id,
    patient_name,
    MAX(CASE WHEN consent_type = 'Phone' THEN consent_status END) AS Phone,
    MAX(CASE WHEN consent_type = 'Email' THEN consent_status END) AS Email,
    MAX(CASE WHEN consent_type = 'SMS' THEN consent_status END) AS SMS
FROM patient_consent
GROUP BY patient_id, patient_name
ORDER BY patient_id;

-- Expected result:
-- patient_id | patient_name | Phone | Email | SMS
-- 101        | Rahul        | YES   | NO    | YES
-- 102        | Priya        | NO    | YES   | NO
-- 103        | Arjun        | YES   | YES   | YES
-- 104        | Sneha        | NO    | NO    | NULL

/* ============================================================
   LEARNING RECORD — WHAT I ANSWERED / METHODS / CORRECTIONS
   ============================================================

   WHAT I SOLVED:
   1. Pivoted consent_type values into separate Phone and Email columns.
   2. Used conditional aggregation with MAX(CASE WHEN ... THEN ... END).
   3. Corrected the GROUP BY to include both patient_id and patient_name.
   4. Extended the same pattern to include an SMS column as a follow-up.

   METHOD I TRIED:
   - Conditional aggregation: MAX(CASE WHEN consent_type = 'Phone'
     THEN consent_status END), repeated for each consent type.
   - This is a standard PostgreSQL pivoting technique; it does not require
     a dedicated PIVOT keyword.

   WHAT GOT ME TO THE CORRECT ANSWER:
   - Grouping by patient_id and patient_name produces one row per patient.
   - Each CASE expression keeps the consent status for one consent type.
   - MAX collapses each patient's matching status into the output column.

   CORRECTION / ISSUE:
   - The earlier conversation record says the initial query grouped only by
     patient_name and was corrected to GROUP BY patient_id, patient_name.
   - Grouping by patient_id as well avoids accidentally merging different
     patients who share the same name.

   DID THE ASSISTANT REVEAL THE ANSWER?
   - The available conversation summary says the pivot logic was yours and
     was correct after the GROUP BY correction; it does not indicate that
     the full answer was revealed before you solved it.
   - The exact original query and every intermediate attempt are not available
     in the recovered history, so this is a reconstruction, not a verbatim log.

   SMS FOLLOW-UP:
   - The conversation summary records that you extended the query with SMS
     as another conditional-aggregation column.
   - The exact original SMS attempt is not available, so the query above is
     included as a working reference solution, not claimed as your verbatim
     submitted query.
   - A missing SMS row yields NULL; it does not automatically mean NO.
*/
