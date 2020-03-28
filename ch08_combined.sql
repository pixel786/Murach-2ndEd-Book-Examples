
----------------------------------------------------------------------------------
-- 8-08

SELECT invoice_total, CONCAT('$', invoice_total)
FROM invoices;

SELECT invoice_number, 989319/invoice_number
FROM invoices;

SELECT invoice_date, invoice_date + 1
FROM invoices;
----------------------------------------------------------------------------------
-- 8-09

SELECT invoice_id, invoice_date, invoice_total,
    CAST(invoice_date AS CHAR(10)) AS char_date,
    CAST(invoice_total AS SIGNED) AS integer_total
FROM invoices;

SELECT invoice_id, invoice_date, invoice_total,
    CONVERT(invoice_date, CHAR(10)) AS char_date,
    CONVERT(invoice_total, SIGNED) AS integer_total
FROM invoices;
----------------------------------------------------------------------------------
-- 8-10

SELECT CONCAT(vendor_name, CHAR(13,10), vendor_address1, CHAR(13,10),
       vendor_city, ', ', vendor_state, ' ', vendor_zip_code)
FROM vendors
WHERE vendor_id = 1;