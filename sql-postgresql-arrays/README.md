# PostgreSQL Practice — Level 7: Arrays

This folder contains the sample table, question wording, original attempts, corrections, and final queries from the arrays practice session.

## Setup
Run `arrays-practice.sql` in PostgreSQL. It creates `products` and inserts five sample rows.

## Question record

1. **Find products whose tags contain `mobile`.** Correct first try; used `ANY(tags)`.
2. **Find products that have both `electronics` and `mobile`.** Correct first try; used two `ANY(tags)` conditions.
3. **Display each product and the number of tags in its array.** Solution revealed on request; not independently attempted. Used `CARDINALITY(tags)`.
4. **Display each product and the first element of its tags array.** Correct first try; used `tags[1]`.
5. **Return one row per tag, alongside the product name.** Correct first try; used `UNNEST(tags)`.
6. **Display each product and one array containing all its tags sorted alphabetically.** Solution revealed on request; used `UNNEST` and `ARRAY_AGG(... ORDER BY ...)`. Also discussed `STRING_AGG`, which returns text rather than an array.
7. **Display products whose tags array contains both `electronics` and `computers`.** Correct first try; used two `ANY(tags)` conditions.
8. **Display `product_name` and `tags` for products with at least three tags.** Logic correct, but original attempt had extra commas after `tags` and `products`. Corrected query is in the SQL file.
9. **Display products whose tags array has exactly the same tags as Phone, regardless of order.** User's subquery is valid for exact array equality and returns Phone and Tablet for the supplied data. PostgreSQL array equality is order-sensitive, so the SQL file also includes an order-independent solution using `@>` and `<@`.
10. **Display the number of times `electronics` appears across the entire table.** The original filter was right, but `product_name` plus `COUNT(tags)` did not return the requested overall count. Corrected query returns `3` matching products.

## Sample table

| product_id | product_name | tags |
|---:|---|---|
| 1 | Laptop | `{"electronics","computers"}` |
| 2 | Phone | `{"electronics","mobile"}` |
| 3 | Desk | `{"furniture","office"}` |
| 4 | Chair | `{"furniture","office","ergonomic"}` |
| 5 | Tablet | `{"electronics","mobile"}` |

## Topics covered
- `ANY()` with arrays
- `CARDINALITY()`
- Array indexing
- `UNNEST()`
- `ARRAY_AGG()` and `STRING_AGG()`
- Array equality and containment (`@>`, `<@`)
- `COUNT(*)`
