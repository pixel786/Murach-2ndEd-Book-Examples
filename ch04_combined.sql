
----------------------------------------------------------------------------------
-- 4-01

SELECT invoice_number, vendor_name
FROM vendors INNER JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
ORDER BY invoice_number;
----------------------------------------------------------------------------------
-- 4-02

SELECT invoice_number, vendor_name, invoice_due_date,
    invoice_total - payment_total - credit_total AS balance_due
FROM vendors v JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY invoice_due_date DESC;

SELECT invoice_number, line_item_amount, line_item_description
FROM invoices JOIN invoice_line_items line_items
    ON invoices.invoice_id = line_items.invoice_id
WHERE account_number = 540
ORDER BY invoice_date;
----------------------------------------------------------------------------------
-- 4-03

SELECT vendor_name, customer_last_name, customer_first_name,
    vendor_state AS state, vendor_city AS city
FROM vendors v
    JOIN om.customers c
    ON v.vendor_zip_code = c.customer_zip
ORDER BY state, city;
----------------------------------------------------------------------------------
-- 4-04

USE ex;

SELECT customer_first_name, customer_last_name
FROM customers c JOIN employees e 
    ON c.customer_first_name = e.first_name 
   AND c.customer_last_name = e.last_name;
----------------------------------------------------------------------------------
-- 4-05

SELECT DISTINCT v1.vendor_name, v1.vendor_city, 
    v1.vendor_state
FROM vendors v1 JOIN vendors v2
    ON v1.vendor_city = v2.vendor_city AND
       v1.vendor_state = v2.vendor_state AND
       v1.vendor_name <> v2.vendor_name
ORDER BY v1.vendor_state, v1.vendor_city;
----------------------------------------------------------------------------------
-- 4-06

SELECT vendor_name, invoice_number, invoice_date,
    line_item_amount, account_description
FROM vendors v
    JOIN invoices i 
        ON v.vendor_id = i.vendor_id
    JOIN invoice_line_items li 
        ON i.invoice_id = li.invoice_id
    JOIN general_ledger_accounts gl 
        ON li.account_number = gl.account_number
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name, line_item_amount DESC;
----------------------------------------------------------------------------------
-- 4-07

SELECT invoice_number, vendor_name
FROM vendors v, invoices i
WHERE v.vendor_id = i.vendor_id /*you would get a cross product if this wasn't there*/
ORDER BY invoice_number;

SELECT vendor_name, invoice_number, invoice_date,
    line_item_amount, account_description
FROM  vendors v, invoices i, invoice_line_items li, 
    general_ledger_accounts gl
WHERE v.vendor_id = i.vendor_id
  AND i.invoice_id = li.invoice_id
  AND li.account_number = gl.account_number
  AND invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name, line_item_amount DESC;
----------------------------------------------------------------------------------
-- 4-08

SELECT vendor_name, invoice_number, invoice_total
FROM vendors LEFT JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;
----------------------------------------------------------------------------------
-- 4-09

USE ex;

SELECT department_name, d.department_number, last_name
FROM departments d 
    LEFT JOIN employees e
    ON d.department_number = e.department_number
ORDER BY department_name;

SELECT department_name, e.department_number, last_name
FROM departments d 
    RIGHT JOIN employees e
    ON d.department_number = e.department_number
ORDER BY department_name;

SELECT department_name, last_name, project_number
FROM departments d
    LEFT JOIN employees e
        ON d.department_number = e.department_number
    LEFT JOIN projects p
        ON e.employee_id = p.employee_id
ORDER BY department_name, last_name;

SELECT department_name, last_name, project_number
FROM departments d
    JOIN employees e
        ON d.department_number = e.department_number
    LEFT JOIN projects p
        ON e.employee_id = p.employee_id
ORDER BY department_name, last_name;
----------------------------------------------------------------------------------
-- 4-10

SELECT invoice_number, vendor_name
FROM vendors 
    JOIN invoices USING (vendor_id)
ORDER BY invoice_number;

SELECT department_name, last_name, project_number
FROM departments
    JOIN employees USING (department_number)
    LEFT JOIN projects USING (employee_id)
ORDER BY department_name;
----------------------------------------------------------------------------------
-- 4-11

USE ap;

SELECT invoice_number, vendor_name
FROM vendors 
    NATURAL JOIN invoices
ORDER BY invoice_number;
 
USE ex;

SELECT department_name AS dept_name, last_name, project_number
FROM departments
    NATURAL JOIN employees
    LEFT JOIN projects USING (employee_id)
ORDER BY department_name;
----------------------------------------------------------------------------------
-- 4-12

SELECT departments.department_number, department_name, employee_id, 
    last_name
FROM departments CROSS JOIN employees
ORDER BY departments.department_number;

SELECT departments.department_number, department_name, employee_id, 
    last_name
FROM departments, employees
ORDER BY departments.department_number;
----------------------------------------------------------------------------------
-- 4-13

SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total
    FROM active_invoices
    WHERE invoice_date >= '2014-06-01'
UNION
    SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
    FROM paid_invoices
    WHERE invoice_date >= '2014-06-01'
ORDER BY invoice_total DESC;
----------------------------------------------------------------------------------
-- 4-14

SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0
UNION
    SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
    FROM invoices
    WHERE invoice_total - payment_total - credit_total <= 0
ORDER BY invoice_total DESC;

SELECT invoice_number, vendor_name, '33% Payment' AS payment_type,
        invoice_total AS total, invoice_total * 0.333 AS payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total > 10000
UNION
    SELECT invoice_number, vendor_name, '50% Payment' AS payment_type,
        invoice_total AS total, invoice_total * 0.5 AS payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total BETWEEN 500 AND 10000
UNION
    SELECT invoice_number, vendor_name, 'Full amount' AS payment_type,
        invoice_total AS total, invoice_total AS payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total < 500
ORDER BY payment_type, vendor_name, invoice_number;
----------------------------------------------------------------------------------
-- 4-15

USE ex;

SELECT department_name AS dept_name, d.department_number AS d_dept_no,
           e.department_number AS e_dept_no, last_name
    FROM departments d 
        LEFT JOIN employees e 
        ON d.department_number = e.department_number
UNION
    SELECT department_name AS dept_name, d.department_number AS d_dept_no,
           e.department_number AS e_dept_no, last_name
    FROM departments d 
        RIGHT JOIN employees e 
        ON d.department_number = e.department_number
ORDER BY dept_name;
----------------------------------------------------------------------------------
-- Assignment On1

-- Question 1:
Use om;
SELECT concat(c.customer_last_name, ", ", c.customer_first_name) as "Customer Name",
	concat("Contact #: ", substring(customer_phone, 1, 3), "-", 
		substring(customer_phone, 4,3),"-",
		substring(customer_phone, 7, 10)) as "Customer Contact Number", 
    concat(c.customer_address, ", ", c.customer_city, ", ", c.customer_state, ", ", c.customer_zip) as "Customer Address"
FROM customers c
where customer_last_name >= "B" and customer_last_name <= "F"
order by c.customer_last_name;


-- Question 2
use om;

select order_id as "Order ID", 
	concat(c.customer_first_name, " ", c.customer_last_name) as "Customer Name",
    order_date, ifnull(shipped_date, "Not Yet Shipped") as shipped_date
from orders o join customers c 
	on o.customer_id = c.customer_id
where order_date >= "2014-07-11" and order_date <= "2014-08-02";

-- Question 3
use ap;
select vendor_name as "Vendor Name", 
	concat(vc.first_name, " ", vc.last_name) as "Contact Full Name",
    invoice_id as "Invoice ID", 
	invoice_total - payment_total- credit_total as "Balance Due"
    from vendor_contacts vc left join vendors v
		on vc.vendor_id = v.vendor_id
	left join invoices i 
		on v.vendor_id = i.vendor_id
order by vendor_name;

-- Question 4
use ap;
select terms_description, vendor_state, vendor_name, v.vendor_id
	from terms t join vendors v 
		on t.terms_id = v.default_terms_id
where v.vendor_state > 'N' and
    v.vendor_state < "Q" 
order by terms_description, vendor_state; 











    
    
    

	














