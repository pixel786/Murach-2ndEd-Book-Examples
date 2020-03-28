
----------------------------------------------------------------------------------
-- select_vendor_city_state

SELECT vendor_name, vendor_city, vendor_state
FROM vendors
ORDER BY vendor_name;
----------------------------------------------------------------------------------
-- select_vendor_information

SELECT vendor_name, vendor_city
FROM vendors
WHERE vendor_id = 34;

SELECT COUNT(*) AS number_of_invoices,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE vendor_id = 34;
----------------------------------------------------------------------------------
-- select_vendor_total_due

SELECT COUNT(*) AS number_of_invoices,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;