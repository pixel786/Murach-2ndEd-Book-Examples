
----------------------------------------------------------------------------------
-- 3-02

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
ORDER BY invoice_total DESC;
 
SELECT invoice_id, invoice_total,
       credit_total + payment_total AS total_credits
FROM invoices
WHERE invoice_id = 17;
 
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_date BETWEEN '2014-06-01' AND '2014-06-30'
ORDER BY invoice_date;
 
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total > 50000;
----------------------------------------------------------------------------------
-- 3-04

SELECT invoice_number AS "Invoice Number", invoice_date AS Date,
       invoice_total AS Total
FROM invoices;

SELECT invoice_number, invoice_date, invoice_total,
       invoice_total - payment_total - credit_total
FROM invoices;


----------------------------------------------------------------------------------
-- 3-05

SELECT invoice_total, payment_total, credit_total,
       invoice_total - payment_total - credit_total AS balance_due
FROM invoices;


SELECT invoice_id, 
       invoice_id + 7 * 3 AS multiply_first, 
       (invoice_id + 7) * 3 AS add_first
FROM invoices;

SELECT invoice_id, 
       invoice_id / 3 AS decimal_quotient,
       invoice_id DIV 3 AS integer_quotient,
       invoice_id % 3 AS remainder
FROM invoices;
----------------------------------------------------------------------------------
-- 3-06

SELECT vendor_city, vendor_state, CONCAT(vendor_city, vendor_state)
FROM vendors;

SELECT vendor_name,
       CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) 
           AS address
FROM vendors;

SELECT CONCAT(vendor_name, '''s Address: ') AS Vendor,
       CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) 
           AS Address
FROM vendors;


----------------------------------------------------------------------------------
-- 3-07

SELECT vendor_contact_first_name, vendor_contact_last_name,
       CONCAT(LEFT(vendor_contact_first_name, 1), 
              LEFT(vendor_contact_last_name, 1)) AS initials
FROM vendors;

SELECT invoice_date,
       DATE_FORMAT(invoice_date, '%m/%d/%y') AS 'MM/DD/YY',
       DATE_FORMAT(invoice_date, '%e-%b-%Y') AS 'DD-Mon-YYYY'
FROM invoices;

SELECT invoice_date, invoice_total,
       ROUND(invoice_total) AS nearest_dollar,
       ROUND(invoice_total, 1) AS nearest_dime
FROM invoices;


----------------------------------------------------------------------------------
-- 3-08

SELECT 1000 * (1 + .1) AS "10% More Than 1000";

SELECT "Ed" AS first_name, "Williams" AS last_name,
    CONCAT(LEFT("Ed", 1), LEFT("Williams", 1)) AS initials;
    
SELECT DATE_FORMAT(CURRENT_DATE, '%m/%d/%y') AS 'MM/DD/YY',
       DATE_FORMAT(CURRENT_DATE, '%e-%b-%Y') AS 'DD-Mon-YYYY';

SELECT 12345.6789 AS value,
       ROUND(12345.67) AS nearest_dollar,
       ROUND(12345.67, 1) AS nearest_dime;
----------------------------------------------------------------------------------
-- 3-09

SELECT vendor_city, vendor_state
FROM vendors
ORDER BY vendor_city;

SELECT DISTINCT vendor_city, vendor_state
FROM vendors
ORDER BY vendor_city;
----------------------------------------------------------------------------------
-- 3-11

SELECT invoice_number, invoice_date, invoice_total, 
(invoice_total - payment_total - credit_total) AS balance_due
FROM invoices
WHERE invoice_date > '2014-07-03' OR invoice_total > 500
  AND invoice_total - payment_total - credit_total > 0;  
  
SELECT invoice_number, invoice_date, invoice_total, 
(invoice_total - payment_total - credit_total) AS balance_due
FROM invoices
WHERE (invoice_date > '2014-07-03' OR invoice_total > 500)
  AND invoice_total - payment_total - credit_total > 0;
----------------------------------------------------------------------------------
-- 3-15

USE ex;

SELECT * FROM null_sample;

SELECT * FROM null_sample
WHERE invoice_total = 0;

SELECT * FROM null_sample
WHERE invoice_total <> 0;

SELECT * FROM null_sample
WHERE invoice_total IS NULL;

SELECT * 
FROM null_sample
WHERE invoice_total IS NOT NULL;
----------------------------------------------------------------------------------
-- 3-16

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY vendor_name;

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY vendor_name DESC;

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY vendor_state, vendor_city, vendor_name;
----------------------------------------------------------------------------------
-- 3-17

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY address, vendor_name;

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY CONCAT(vendor_contact_last_name, vendor_contact_first_name);

SELECT vendor_name,
  CONCAT(vendor_city, ', ', vendor_state, ' ', vendor_zip_code) AS address
FROM vendors
ORDER BY 2, 1;
----------------------------------------------------------------------------------
-- 3-18

SELECT vendor_id, invoice_total
FROM invoices
ORDER BY invoice_total DESC
LIMIT 5;

SELECT invoice_id, vendor_id, invoice_total
FROM invoices
ORDER BY invoice_id
LIMIT 2, 3;

SELECT invoice_id, vendor_id, invoice_total
FROM invoices
ORDER BY invoice_id
LIMIT 100, 1000;