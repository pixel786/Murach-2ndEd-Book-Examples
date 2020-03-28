
----------------------------------------------------------------------------------
-- 16-01

USE ap;

DROP TRIGGER IF EXISTS vendors_before_update;

DELIMITER //

CREATE TRIGGER vendors_before_update
  BEFORE UPDATE ON vendors
  FOR EACH ROW 
BEGIN
  SET NEW.vendor_state = UPPER(NEW.vendor_state);
END//

DELIMITER ;

UPDATE vendors
SET vendor_state = 'wi'
WHERE vendor_id = 1;

SELECT vendor_name, vendor_state
FROM vendors
WHERE vendor_id = 1;
----------------------------------------------------------------------------------
-- 16-02

USE ap;

DROP TRIGGER IF EXISTS invoices_before_update;

DELIMITER //

CREATE TRIGGER invoices_before_update
  BEFORE UPDATE ON invoices
  FOR EACH ROW
BEGIN
  DECLARE sum_line_item_amount DECIMAL(9,2);
  
  SELECT SUM(line_item_amount) 
  INTO sum_line_item_amount
  FROM invoice_line_items
  WHERE invoice_id = NEW.invoice_id;
  
  IF sum_line_item_amount != NEW.invoice_total THEN
    SIGNAL SQLSTATE 'HY000'
      SET MESSAGE_TEXT = 'Line item total must match invoice total.';
  END IF;
END//

DELIMITER ;

UPDATE invoices
SET invoice_total = 600
WHERE invoice_id = 100;

SELECT invoice_id, invoice_total, credit_total, payment_total 
FROM invoices WHERE invoice_id = 100;

----------------------------------------------------------------------------------
-- 16-03

USE ap;

DROP TABLE invoices_audit;

CREATE TABLE invoices_audit
(
  vendor_id           INT             NOT NULL,
  invoice_number      VARCHAR(50)     NOT NULL,
  invoice_total       DECIMAL(9,2)    NOT NULL,
  action_type         VARCHAR(50)     NOT NULL,
  action_date         DATETIME        NOT NULL
);

DROP TRIGGER IF EXISTS invoices_after_insert;
DROP TRIGGER IF EXISTS invoices_after_delete;

DELIMITER //

CREATE TRIGGER invoices_after_insert
  AFTER INSERT ON invoices
  FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES
    (NEW.vendor_id, NEW.invoice_number, NEW.invoice_total, 
    'INSERTED', NOW());
END//

CREATE TRIGGER invoices_after_delete
  AFTER DELETE ON invoices
  FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES
    (OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 
    'DELETED', NOW());
END//

DELIMITER ;

-- make sure that there is at least one record to delete
INSERT INTO invoices VALUES 
(115, 34, 'ZXA-080', '2014-08-30', 14092.59, 0, 0, 3, '2014-09-30', NULL);

DELETE FROM invoices WHERE invoice_id = 115;

SELECT * FROM invoices_audit;

-- clean up
-- DELETE FROM invoices_audit;
----------------------------------------------------------------------------------
-- 16-04

SHOW TRIGGERS;

SHOW TRIGGERS IN ex;

SHOW TRIGGERS IN ap LIKE 'ven%';

DROP TRIGGER vendors_before_update;

DROP TRIGGER IF EXISTS vendors_before_update;
----------------------------------------------------------------------------------
-- 16-05

SHOW VARIABLES LIKE 'event_scheduler';

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS one_time_delete_audit_rows;
DROP EVENT IF EXISTS monthly_delete_audit_rows;

DELIMITER //

CREATE EVENT one_time_delete_audit_rows
ON SCHEDULE AT NOW() + INTERVAL 1 MONTH
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH LIMIT 100;
END//

CREATE EVENT monthly_delete_audit_rows
ON SCHEDULE EVERY 1 MONTH
STARTS '2015-06-30 00:00:00'
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH LIMIT 100;
END//

DELIMITER ;
----------------------------------------------------------------------------------
-- 16-06

SHOW EVENTS;

SHOW EVENTS IN ap;

SHOW EVENTS IN ap LIKE 'mon%';

ALTER EVENT monthly_delete_audit_rows DISABLE;

ALTER EVENT monthly_delete_audit_rows ENABLE;

ALTER EVENT one_time_delete_audit_rows RENAME TO one_time_delete_audits;

DROP EVENT monthly_delete_audit_rows;

DROP EVENT IF EXISTS monthly_delete_audit_rows;