-- Level 1 | Question 6: Airline Bookings
-- Dialect: PostgreSQL-compatible SQL
-- Question: Display all columns for Delhi or Goa bookings under 5000 and not cancelled; sort price ascending.
-- Result: Correct

-- SETUP DATA
-- Run this setup in a fresh schema/database, or drop the table first if it already exists.
CREATE TABLE flight_bookings (booking_id INT PRIMARY KEY, passenger_name VARCHAR(100), destination VARCHAR(100), ticket_price NUMERIC(10,2), booking_status VARCHAR(30));
INSERT INTO flight_bookings VALUES
(601,'Aman','Delhi',4500,'Confirmed'),(602,'Priya','Mumbai',6200,'Cancelled'),(603,'Rohan','Delhi',3800,'Confirmed'),(604,'Sneha','Goa',7200,'Pending'),(605,'Isha','Mumbai',5500,'Confirmed'),(606,'Karan','Goa',2900,'Confirmed');

-- YOUR ORIGINAL ACCEPTED ATTEMPT
SELECT *
FROM flight_bookings
WHERE destination IN('Delhi', 'Goa') AND ticket_price < 5000 AND NOT booking_status = 'Cancelled'
ORDER BY ticket_price ASC;

-- FINAL ACCEPTED QUERY
SELECT *
FROM flight_bookings
WHERE destination IN('Delhi', 'Goa') AND ticket_price < 5000 AND NOT booking_status = 'Cancelled'
ORDER BY ticket_price ASC;
