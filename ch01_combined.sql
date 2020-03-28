
----------------------------------------------------------------------------------
-- 1-11

CREATE TABLE invoices
(
  invoice_id            INT            PRIMARY KEY   AUTO_INCREMENT,
  vendor_id             INT            NOT NULL,
  invoice_number        VARCHAR(50)    NOT NULL,
  invoice_date          DATE           NOT NULL,
  invoice_total         DECIMAL(9,2)   NOT NULL,
  payment_total         DECIMAL(9,2)                 DEFAULT 0,
  credit_total          DECIMAL(9,2)                 DEFAULT 0,
  terms_id              INT            NOT NULL,
  invoice_due_date      DATE           NOT NULL,
  payment_date          DATE,
  CONSTRAINT invoices_fk_vendors
    FOREIGN KEY (vendor_id)
    REFERENCES vendors (vendor_id),
  CONSTRAINT invoices_fk_terms
    FOREIGN KEY (terms_id)
    REFERENCES terms (terms_id)
);

ALTER TABLE invoices
ADD balance_due DECIMAL(9,2);

ALTER TABLE invoices
DROP COLUMN balance_due;

CREATE INDEX invoices_vendor_id_index
  ON invoices (vendor_id);

DROP INDEX invoices_vendor_id_index
    ON invocies;
----------------------------------------------------------------------------------
-- 1-12

SELECT invoice_number, invoice_date, invoice_total,
    payment_total, credit_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices 
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY invoice_date;
----------------------------------------------------------------------------------
-- 1-13

SELECT vendor_name, invoice_number, invoice_date, invoice_total
FROM vendors INNER JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total >= 500
ORDER BY vendor_name, invoice_total DESC;
----------------------------------------------------------------------------------
-- 1-14

INSERT INTO invoices
  (vendor_id, invoice_number, invoice_date, 
   invoice_total, terms_id, invoice_due_date)
VALUES 
  (12, '3289175', '2014-07-18', 165, 3, '2014-08-17');

UPDATE invoices
SET credit_total = 35.89
WHERE invoice_number = '367447';

UPDATE invoices
SET invoice_due_date = DATE_ADD(invoice_due_date, INTERVAL 30 DAY)
WHERE terms_id = 4;


DELETE FROM invoices
WHERE invoice_number = '4-342-8069';

DELETE FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;
----------------------------------------------------------------------------------
-- 1-15

select invoice_number, invoice_date, invoice_total, 
payment_total, credit_total, invoice_total - payment_total - 
credit_total as balance_due from invoices where invoice_total - 
payment_total - credit_total > 0 order by invoice_date;

SELECT invoice_number, invoice_date, invoice_total,
    payment_total, credit_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices 
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY invoice_date;

/*
Author: Joel Murach
Date: 8/22/2014
*/
SELECT invoice_number, invoice_date, invoice_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices; 

-- The fourth column calculates the balance due
SELECT invoice_number, invoice_date, invoice_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices;