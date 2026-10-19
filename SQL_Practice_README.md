# SQL Practice Roadmap — Progress, Mistakes, and Corrections

This README summarizes the SQL practice levels completed so far. It focuses on the concepts practiced, the mistakes made, and what the corrected queries taught. The detailed `.sql` files contain the full question wording, sample data, original attempts, and accepted/corrected queries.

**SQL dialect:** PostgreSQL  
**Practice style:** Solve first, check the logic, then record the original attempt and correction. Questions marked **revealed** were shown/explained rather than solved independently.

---

## Level 1 — SQL Fundamentals and Filtering

**Status:** Completed — 10/10 correct.

### What was practiced
- `SELECT` and choosing the required columns
- `WHERE` filters
- `AND` / `OR`
- `BETWEEN`, `IN`, and `DISTINCT`
- Comparing numbers and text
- `IS NULL`
- Combining multiple conditions

### What went well
All 10 answers were recorded as correct. The queries applied filters to the right rows and selected the requested output.

### Main lesson
Read the question in two parts:
1. **What should the output show?** Choose the correct columns.
2. **Which rows qualify?** Translate each condition into `WHERE`, using parentheses when `AND` and `OR` are mixed.

Remember that SQL `NULL` values must be checked with `IS NULL` or `IS NOT NULL`, not `= NULL`.

---

## Level 2 — Aggregations and Grouping

**Status:** Completed — 10 questions. Q4 required correction before the final query was correct.

### What was practiced
- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY`
- `HAVING`
- Sorting aggregated results
- Calculations inside aggregates

### What went wrong — Q4 inventory value
The initial attempts calculated `quantity * unit_cost` for individual rows and tried to group by a warehouse or medicine name without correctly aggregating the warehouse total. The final query needed to add the inventory value across all rows in each warehouse.

Corrected pattern:

```sql
SELECT warehouse,
       SUM(quantity * unit_cost) AS total_inventory_value
FROM medicine_stock
GROUP BY warehouse
HAVING SUM(quantity * unit_cost) > 12000
ORDER BY total_inventory_value DESC;
```

### Why the correction works
- `quantity * unit_cost` calculates the value of one row.
- `SUM(quantity * unit_cost)` adds those row values together.
- `GROUP BY warehouse` produces one result per warehouse.
- `HAVING` filters groups after aggregation; `WHERE` filters individual rows before aggregation.

**Important:** The threshold in the recorded final query is `> 12000`. The initial attempt used `> 120000`, which was also inconsistent with the final intended threshold.

### Main lesson
If a question asks for a total, average, or count **per group**, aggregate the measure and group by the requested category. Use `HAVING` when filtering on an aggregate.

---

## Level 3 — JOINs

**Status:** Completed — 10/10; Q10 needed a logic correction.

### What was practiced
- `INNER JOIN`
- `LEFT JOIN`
- Joining related tables through IDs
- Counting related records
- Aggregating after joins
- `COALESCE`
- Conditional aggregation with `CASE`

### What went wrong — Q10 deposits per customer
The first attempt filtered the joined rows with `WHERE transaction_type = 'Deposit'`. That removed customers who had no deposit rows, even though the question asked to include every customer.

Corrected pattern:

```sql
SELECT c.customer_id,
       c.customer_name,
       COALESCE(
           SUM(CASE
                 WHEN t.transaction_type = 'Deposit' THEN t.amount
                 ELSE 0
               END),
           0
       ) AS total_deposits
FROM customers c
LEFT JOIN transactions t
       ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name;
```

### Why the correction works
- `LEFT JOIN` keeps every customer, including those without matching transactions.
- The `CASE` adds an amount only when the transaction is a deposit.
- `ELSE 0` makes non-deposit rows contribute zero.
- `COALESCE(..., 0)` returns zero instead of `NULL` where needed.

### Other notes
- For counting optional joined rows, use `COUNT(child_table.id)`, not `COUNT(*)`, if customers with no matching row should count as zero.
- `COALESCE(SUM(...), 0)` is useful when a group has no matching values.
- One query included a `WHERE ... IS NOT NULL` condition that was unnecessary for the intended join; avoid adding filters unless they serve the question.

### Main lesson
When the result must include every row from the main table, be careful not to put a filter in `WHERE` that removes unmatched rows from a `LEFT JOIN`. Conditional aggregation often preserves the rows while calculating only the requested category.

---

## Level 4 — Subqueries

**Status:** Completed — 10 main questions plus 5 reinforcement questions.

### What was practiced
- Scalar subqueries
- `IN` and `NOT IN`
- Correlated subqueries
- Comparing values with `AVG`, `MIN`, and `MAX`
- `EXISTS` / `NOT EXISTS` concepts
- `GROUP BY` and `HAVING` inside subqueries
- Second-highest distinct value patterns

### Mistakes and corrections

#### 1. Filtering employees by a department condition
An early attempt filtered employees directly by their own salary when the question asked for **all employees in a department where at least one employee** met a salary condition. The corrected query used a subquery to identify qualifying departments, then selected all employees in those departments.

**Lesson:** Distinguish “employees who meet the condition” from “employees who belong to a group in which someone meets the condition.”

#### 2. Comparing against the highest value
One attempt used `MIN` when the question required comparing against the highest salary in a group. The corrected logic used `MAX`.

**Lesson:** Check the exact comparison:
- greater than the highest value → compare with `MAX`
- greater than the lowest value → compare with `MIN`

#### 3. Customers who never placed a large order
An incomplete attempt used a `SUM` subquery, which did not answer the question “which customers never placed an order above the threshold?” A later approach using `IN` with orders below the threshold was also logically unsuitable: a customer could have both a small and a large order and still appear in the result.

The corrected pattern was to identify customer IDs that had **no order above the threshold**, using `NOT IN` with a subquery selecting IDs for large orders, and `DISTINCT` where needed. `NOT EXISTS` is another good option.

Example pattern:

```sql
SELECT DISTINCT c.customer_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_amount > 4000
);
```

### Other lesson
A correlated subquery references a row from the outer query. For example, comparing an employee’s salary with the average salary of that employee’s own department requires matching the inner department to the outer employee’s department.

**Main lesson:** Translate the wording precisely: “above average,” “above the maximum,” “in a department where someone…,” and “never had a matching row” are different conditions.

---

## Level 5 — Common Table Expressions (CTEs)

**Status:** Completed — 10 main questions plus 5 reinforcement questions.

### What was practiced
- `WITH ... AS (...)`
- Naming intermediate results
- Joining a CTE to a base table
- Multiple CTEs
- `LEFT JOIN` and `CROSS JOIN` with CTEs
- Aggregation and filtering
- `UNION ALL`
- Window functions inside a CTE

### Mistakes and corrections

#### 1. Multiple CTEs and preserving departments
In the reinforcement set, the first attempt was incorrect and the next was close. The corrected approach created a CTE for department averages and another for department information, then used a `LEFT JOIN` so departments without employees remained in the output. `COALESCE` was used to show zero rather than `NULL` where appropriate.

**Lesson:** Use `LEFT JOIN` when the result must preserve all rows from the department list, including departments with no employees.

#### 2. Comparing salary to both department and overall averages
The CTE definitions were correct, but the join condition tried to use an aggregate expression as if it were a column reference, with an expression like `e2.AVG(salary) = e3.AVG(salary)`. The averages had already been named as columns in the CTEs.

Corrected pattern:

```sql
WITH emp_details AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
overall_avg AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT e.employee_name
FROM employees e
JOIN emp_details d
  ON e.department = d.department
CROSS JOIN overall_avg o
WHERE e.salary > d.avg_salary
  AND e.salary > o.avg_salary;
```

**Why:** Once an aggregate is calculated inside a CTE, refer to its alias (such as `d.avg_salary`) from the outer query. `CROSS JOIN` attaches the one-row overall average to each employee row.

#### 3. Required output columns
Some attempts calculated the right rows but left out a requested output column, such as the department average. A query can have correct filtering and still be incomplete if it does not return every column the question asks for.

#### 4. Combining employees and contractors
The `UNION ALL` query was logically correct, but the final output was meant to contain only `person_name` and `department`; an extra ID column needed to be removed.

### Main lesson
A CTE is a named intermediate result, not a special kind of table that changes SQL rules. Give its output columns clear aliases, then refer to those columns from the outer query. Check the requested output columns separately from the filtering logic.

---

## Level 6 — Window Functions

**Status:** Completed — 10 questions. Q7 required clarification/correction, Q8 needed a correction, Q9 was corrected using a CTE, and Q10's solution was revealed.

### What was practiced
- `ROW_NUMBER`
- `RANK`
- `DENSE_RANK`
- `LAG` and `LEAD`
- `AVG(...) OVER (...)`
- Running totals
- Comparing each row to its group average
- Finding top-paid employees per department
- Calculating a row’s percentage of its department total

### What went well
Q1–Q6 were correct on the first attempt. These covered ranking, previous/next row values, and department-level averages while retaining individual employee rows.

### What went wrong or needed clarification

#### Q7 — Running total and tied values
The submitted query used:

```sql
SUM(salary) OVER (
    PARTITION BY department
    ORDER BY salary ASC
)
```

This is valid SQL. However, in PostgreSQL the default window frame can give rows with tied ordering values the same cumulative total. The user marked this question as wrong / needing clarification about tied-row behavior.

To make a row-by-row running total explicit, use a unique tie-breaker and a `ROWS` frame:

```sql
SUM(salary) OVER (
    PARTITION BY department
    ORDER BY salary ASC, employee_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

#### Q8 — Reusing a SELECT alias
The first attempt calculated `AVG(salary) OVER (...) AS avg_salary` and then tried to use `avg_salary` in another expression in the same `SELECT` list. PostgreSQL does not allow a select-list alias to be referenced by another expression at the same select-list level.

Correct the expression by repeating the window expression, or put the calculation in a CTE/subquery and refer to the alias outside it.

#### Q9 — Filtering a window-function result
The first attempt was incomplete/incorrect because the window expression/alias was not set up and filtered in the right query level. The corrected CTE calculated the rank first, then filtered it in the outer query:

```sql
WITH emp_details AS (
    SELECT employee_name,
           department,
           salary,
           DENSE_RANK() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS salary_rank
    FROM employees
)
SELECT employee_name
FROM emp_details
WHERE salary_rank = 1;
```

**Lesson:** Window functions are calculated after the `WHERE` stage, so filter their results in an outer query or CTE.

#### Q10 — Percentage of department salary total
The solution was revealed because percentage calculation had not been learned yet; it was **not an independent attempt**.

```sql
SELECT employee_name,
       department,
       salary,
       ROUND(
           salary * 100.0
           / SUM(salary) OVER (PARTITION BY department),
           2
       ) AS salary_percentage
FROM employees;
```

`100.0` helps avoid integer division, and the windowed `SUM` calculates each department’s total without collapsing employee rows.

### Main lesson
Window functions calculate values across related rows while preserving row-level output. Remember that window results generally need an outer query/CTE for filtering, and specify tie-breaking/frame behavior when you need deterministic row-by-row running totals.

---

## Level 7 — PostgreSQL Arrays

**Status:** Completed — 10 questions. Q3 and Q6 solutions were revealed; Q8 had syntax errors; Q9 needed an order-sensitivity clarification; Q10 had the right filter but the wrong output shape.

### What was practiced
- `ANY`
- Checking multiple array elements
- `CARDINALITY`
- Array indexing
- `UNNEST`
- `ARRAY_AGG`
- `STRING_AGG`
- Array containment operators `@>` and `<@`
- Counting rows whose arrays contain a value

### What went wrong or needed clarification

#### Q3 — Count array elements
The solution was revealed rather than solved independently:

```sql
SELECT product_name, CARDINALITY(tags) AS tag_count
FROM products;
```

`CARDINALITY` returns the number of elements in an array.

#### Q6 — Sort each product’s tags
The solution was revealed rather than solved independently:

```sql
SELECT product_name,
       ARRAY_AGG(tag ORDER BY tag) AS sorted_tags
FROM products,
     UNNEST(tags) AS tag
GROUP BY product_name;
```

- `UNNEST(tags)` turns array elements into rows.
- `ARRAY_AGG` collects those rows back into an array.
- `ORDER BY tag` inside `ARRAY_AGG` controls the order inside the resulting array.

`STRING_AGG(tag, ', ' ORDER BY tag)` is an alternative if the desired output is text, not a PostgreSQL array.

#### Q8 — Extra commas
The logic was correct, but the query had extra commas after the selected columns and table name. Those are syntax errors, not logic errors.

Corrected query:

```sql
SELECT product_name, tags
FROM products
WHERE CARDINALITY(tags) >= 3;
```

#### Q9 — Array equality is order-sensitive
The submitted `IN (SELECT tags ...)` approach is valid for exact array equality. But the question asked for arrays with the same elements regardless of order. PostgreSQL array equality considers element order, so arrays with the same elements in a different order would not compare equal.

For an order-independent comparison, check containment both ways:

```sql
SELECT p.product_name, p.tags
FROM products p
WHERE p.tags @> (
    SELECT tags FROM products WHERE product_name = 'Phone'
)
AND p.tags <@ (
    SELECT tags FROM products WHERE product_name = 'Phone'
);
```

`@>` means “contains” and `<@` means “is contained by.” Used together, they check that both arrays contain the same elements. This pattern assumes there are no duplicate elements that need special multiset handling.

#### Q10 — Correct filter, incorrect aggregation/output
The attempt filtered products whose tags contain `electronics`, but selected `product_name` and `COUNT(tags)` without a matching `GROUP BY`, and it did not match the requested total count.

Corrected query:

```sql
SELECT COUNT(*) AS electronics_count
FROM products
WHERE 'electronics' = ANY(tags);
```

This counts products whose array contains `electronics` (three products in the practice dataset). It does not count repeated occurrences of the same tag within a single array.

### What went well
Q1, Q2, Q4, Q5, and Q7 were correct on the first attempt.

### Main lesson
Be clear whether the result should be an array, text, one row per element, or a single count. Array membership, array equality, and order-independent matching are different operations.

---

## Separate Practice — Patient Consent Pivot

This was a separate pivoting exercise from the brother's example, not one of Levels 1–7.

**Question:** Convert the table so each patient appears on one row, with separate columns for Phone and Email consent. A follow-up asked to add SMS consent as a third column.

### Recovered first attempt
```sql
SELECT CASE
WHEN Phone = 'YES' THEN patient_name,
WHEN Phone = 'NO' THEN patient_name,
WHEN Email = 'YES' THEN patient_name,
WHEN Email = 'NO' THEN patient_name
FROM table_patients;
```

**Status:** Incorrect first attempt. This is the only original attempt recovered from the available history; it cannot be confirmed that it was the only attempt ever made.

### What went wrong
- The `CASE` syntax was invalid: commas were placed after `THEN` expressions, and the `CASE` expression was not completed with `END`.
- The attempt treated `Phone` and `Email` as if they were already separate columns, but the source data stored consent types as rows.
- It did not transform each patient’s multiple rows into one row with separate consent columns.

### Corrected pivot query
```sql
SELECT
    patient_id,
    patient_name,
    MAX(CASE WHEN consent_type = 'Phone'
             THEN consent_status END) AS phone,
    MAX(CASE WHEN consent_type = 'Email'
             THEN consent_status END) AS email
FROM patient_consent
GROUP BY patient_id, patient_name;
```

For SMS, add another conditional aggregate:

```sql
MAX(CASE WHEN consent_type = 'SMS'
         THEN consent_status END) AS sms
```

### Why it works
`CASE` places each consent status into the column for its consent type. `MAX` returns the single non-NULL value for that patient/type group, and `GROUP BY` combines the source rows into one row per patient.

### Main lesson
This is **conditional aggregation**, commonly used to pivot rows into columns. The original attempt was not correct; the corrected method was explained/revealed rather than successfully produced in the first attempt.

---

## Level 8 — Pivoting and Unpivoting

**Status:** Started; Question 1 is pending.

The first question uses a `sales` table with `sale_id`, `product`, `quarter`, and `amount`, and asks for one row per product with separate `Q1` and `Q2` columns.

The goal is to learn how to turn category values such as `Q1` and `Q2` into output columns, typically using conditional aggregation:

```sql
SELECT
    product,
    SUM(CASE WHEN quarter = 'Q1' THEN amount ELSE 0 END) AS q1,
    SUM(CASE WHEN quarter = 'Q2' THEN amount ELSE 0 END) AS q2
FROM sales
GROUP BY product;
```

This query is an example solution for the pending question, not a recorded user attempt.

---

## Overall Progress and Patterns to Keep Improving

### Strengths shown
- Filtering and combining conditions
- Aggregates and basic grouping
- Joins and preserving unmatched rows
- Subqueries and correlated comparisons
- CTE structure and multi-step queries
- Common window functions
- PostgreSQL array membership and expansion

### Repeated issues to watch
1. **Match the requested output shape.** A correct filter is not enough if the question asks for one total, one row per group, or specific output columns.
2. **Separate row filters from group filters.** Use `WHERE` for individual rows and `HAVING` for grouped aggregate results.
3. **Be careful with `LEFT JOIN`.** A filter on the right-side table in `WHERE` can remove unmatched rows.
4. **Use the correct aggregate.** `SUM` for totals, `COUNT` for counts, `AVG` for averages, `MIN`/`MAX` for extremes.
5. **Check query stages.** A select-list alias generally cannot be reused in another expression in the same `SELECT` list, and window-function results usually need an outer query/CTE to filter.
6. **Check syntax separately from logic.** Extra commas can make a logically sound query invalid.
7. **Read exact wording.** “Never had an order above $4,000” is not the same as “had an order below $4,000.”
8. **Record revealed solutions honestly.** A solution shown by the assistant should not be counted as independently solved.

### Files for the detailed records
The per-level `.sql` files and their individual READMEs contain the detailed exercises, sample data, original attempts, and corrections. This roadmap README is intended as the top-level progress guide for the repository.
