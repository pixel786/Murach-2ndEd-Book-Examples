
----------------------------------------------------------------------------------
-- 7-01

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total > 
    (SELECT AVG(invoice_total)
     FROM invoices)
ORDER BY invoice_total;
----------------------------------------------------------------------------------
-- 7-02

SELECT invoice_number, invoice_date, invoice_total
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = 'CA'
ORDER BY invoice_date;

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_state = 'CA')
ORDER BY invoice_date;
----------------------------------------------------------------------------------
-- 7-03

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id NOT IN
    (SELECT DISTINCT vendor_id
     FROM invoices)
ORDER BY vendor_id;

SELECT v.vendor_id, vendor_name, vendor_state
FROM vendors v LEFT JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE i.vendor_id IS NULL
ORDER BY v.vendor_id;
----------------------------------------------------------------------------------
-- 7-04

SELECT invoice_number, invoice_date, 
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices
WHERE invoice_total - payment_total - credit_total  > 0 
  AND invoice_total - payment_total - credit_total <
    (
     SELECT AVG(invoice_total - payment_total - credit_total)
     FROM invoices
     WHERE invoice_total - payment_total - credit_total > 0
    )
ORDER BY invoice_total DESC;
----------------------------------------------------------------------------------
-- 7-05

SELECT vendor_name, invoice_number, invoice_total
FROM invoices i JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE invoice_total > ALL
    (SELECT invoice_total
     FROM invoices
     WHERE vendor_id = 34)
ORDER BY vendor_name;
----------------------------------------------------------------------------------
-- 7-06

SELECT vendor_name, invoice_number, invoice_total
FROM vendors JOIN invoices ON vendors.vendor_id = invoices.invoice_id
WHERE invoice_total < ANY
    (SELECT invoice_total
     FROM invoices
     WHERE vendor_id = 115);
----------------------------------------------------------------------------------
-- 7-07

SELECT vendor_id, invoice_number, invoice_total
FROM invoices i
WHERE invoice_total >
    (SELECT AVG(invoice_total)
     FROM invoices
     WHERE vendor_id = i.vendor_id)
ORDER BY vendor_id, invoice_total;
----------------------------------------------------------------------------------
-- 7-08

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE NOT EXISTS
    (SELECT * 
     FROM invoices
     WHERE vendor_id = vendors.vendor_id);
----------------------------------------------------------------------------------
-- 7-09

SELECT vendor_name,
    (SELECT MAX(invoice_date) FROM invoices
     WHERE vendor_id = vendors.vendor_id) AS latest_inv
FROM vendors
ORDER BY latest_inv DESC;

SELECT vendor_name, MAX(invoice_date) AS latest_inv
FROM vendors v 
    LEFT JOIN invoices i ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY latest_inv DESC;
----------------------------------------------------------------------------------
-- 7-10

SELECT vendor_state, MAX(sum_of_invoices) AS max_sum_of_invoices
FROM
(
     SELECT vendor_state, vendor_name,
         SUM(invoice_total) AS sum_of_invoices
     FROM vendors v JOIN invoices i 
         ON v.vendor_id = i.vendor_id
     GROUP BY vendor_state, vendor_name
) t
GROUP BY vendor_state;
----------------------------------------------------------------------------------
-- 7-11

SELECT t1.vendor_state, vendor_name, t1.sum_of_invoices
FROM
    (
        -- invoice totals by vendor
        SELECT vendor_state, vendor_name,
            SUM(invoice_total) AS sum_of_invoices
        FROM vendors v JOIN invoices i 
            ON v.vendor_id = i.vendor_id
        GROUP BY vendor_state, vendor_name
    ) t1
    JOIN
        (
            -- top invoice totals by state
            SELECT vendor_state,  
                   MAX(sum_of_invoices) AS sum_of_invoices
            FROM
            (
                 -- invoice totals by vendor
                 SELECT vendor_state, vendor_name,
                     SUM(invoice_total) AS sum_of_invoices
                 FROM vendors v JOIN invoices i 
                     ON v.vendor_id = i.vendor_id
                 GROUP BY vendor_state, vendor_name
            ) t2
            GROUP BY vendor_state
        ) t3
    ON t1.vendor_state = t3.vendor_state AND 
       t1.sum_of_invoices = t3.sum_of_invoices
ORDER BY vendor_state;
----------------------------------------------------------------------------------
-- 7-12

SELECT vendor_state, vendor_name, SUM(invoice_total) AS sum_of_invoices
FROM vendors v JOIN invoices i 
    ON v.vendor_id = i.vendor_id
GROUP BY vendor_state, vendor_name;

SELECT vendor_state, MAX(sum_of_invoices) AS sum_of_invoices
FROM
(
     SELECT vendor_state, vendor_name,
         SUM(invoice_total) AS sum_of_invoices
     FROM vendors v JOIN invoices i 
         ON v.vendor_id = i.vendor_id
     GROUP BY vendor_state, vendor_name
) t
GROUP BY vendor_state;