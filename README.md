# SQL Practice Repository

A collection of runnable SQL practice problems covering the topics practiced so far.

## Database

These scripts use **PostgreSQL** as the default because the array exercises we practiced use PostgreSQL features such as arrays, `ANY()`, `UNNEST()`, and `STRING_AGG()`.

Most of the other queries use common SQL patterns, but syntax can differ across databases.

## How to run

1. Install PostgreSQL, or open a PostgreSQL online editor.
2. Open a `.sql` file.
3. Run the entire file from top to bottom. Each exercise creates its own sample table(s), inserts data, and runs the solution.
4. Check the result against the expected output comments at the end of each file.

You can also use a GUI such as pgAdmin or a code editor connected to PostgreSQL.

## Folder guide

- `01-pivot/` — conditional aggregation to turn consent rows into columns.
- `02-arrays/` — arrays, `ANY()`, and `UNNEST()`.
- `03-cte-and-joins/` — common table expressions (CTEs), joins, and grouped calculations.
- `04-window-functions/` — `PARTITION BY`, `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, top salaries.
- `05-subqueries/` — company-wide and department-specific average salary comparisons.
- `06-string-aggregation/` — `STRING_AGG()`.

## Good practice

- Keep the problem statement and sample data in each file.
- Run the query yourself before looking at the solution.
- Add your own attempt above the final solution if you want to track progress.
- Never commit real patient/customer data, passwords, API keys, or other confidential information. The pharma consent example uses fictional sample data only.
