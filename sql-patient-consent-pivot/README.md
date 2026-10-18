# Patient Consent Pivot — SQL Practice

**Dialect:** PostgreSQL  
**Topic:** Pivoting rows into columns with conditional aggregation.

## Question 1

Convert the `patient_consent` table so each patient appears on one row, with separate columns for phone consent and email consent.

## Question 2 — Follow-up

Suppose the company also records SMS consent using `consent_type = 'SMS'`. Modify your query to produce three consent columns: `Phone`, `Email`, and `SMS`.

## Sample data

| patient_id | patient_name | consent_type | consent_status |
|---:|---|---|---|
| 101 | Rahul | Phone | YES |
| 101 | Rahul | Email | NO |
| 102 | Priya | Phone | NO |
| 102 | Priya | Email | YES |
| 103 | Arjun | Phone | YES |
| 103 | Arjun | Email | YES |
| 104 | Sneha | Phone | NO |
| 104 | Sneha | Email | NO |

## Learning record — appended at the end of the SQL file

- **What you solved:** Pivoted Phone and Email into separate columns, then extended the pattern to SMS.
- **Method tried:** Conditional aggregation using `MAX(CASE WHEN ... THEN ... END)`.
- **What got you to the correct answer:** Grouping by both `patient_id` and `patient_name`, and creating one conditional expression per consent type.
- **Correction:** The earlier conversation record says the first query grouped only by `patient_name`; the correction was to include `patient_id` too.
- **Was the answer revealed?** The recovered conversation summary indicates your pivot logic was correct after the `GROUP BY` correction and does not indicate that the full answer was revealed before you solved it.
- **Historical accuracy note:** The exact original SQL attempts and every intermediate message could not be recovered. The file labels the accepted query as reconstructed and does not pretend it is your verbatim original answer.
- **SMS follow-up:** The discussion records that you extended the query to SMS, but the exact submitted SMS query is unavailable. The file includes a working reference solution. A missing SMS record results in `NULL`, not automatically `NO`.

## Main concept

`MAX(CASE WHEN consent_type = 'Phone' THEN consent_status END)` selects the consent status for that type within each patient group. Repeat for each type and group by patient identity.
