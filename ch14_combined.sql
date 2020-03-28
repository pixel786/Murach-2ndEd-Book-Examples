
----------------------------------------------------------------------------------
-- 14-01

USE ap;

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  INSERT INTO invoices
  VALUES (115, 34, 'ZXA-080', '2014-06-30', 
          14092.59, 0, 0, 3, '2014-09-30', NULL);

  INSERT INTO invoice_line_items 
  VALUES (115, 1, 160, 4447.23, 'HW upgrade');
  
  INSERT INTO invoice_line_items 
  VALUES (115, 2, 167, 9645.36, 'OS upgrade');
  
  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;

CALL test();

-- Check data
SELECT invoice_id, invoice_number
FROM invoices WHERE invoice_id = 115;

SELECT invoice_id, invoice_sequence, line_item_description
FROM invoice_line_items WHERE invoice_id = 115;

-- Clean up
DELETE FROM invoice_line_items WHERE invoice_id = 115;
DELETE FROM invoices WHERE invoice_id = 115;
----------------------------------------------------------------------------------
-- 14-02

USE ap;

START TRANSACTION;
  
SAVEPOINT before_invoice;

INSERT INTO invoices
VALUES (115, 34, 'ZXA-080', '2015-01-18', 
        14092.59, 0, 0, 3, '2015-04-18', NULL);

SAVEPOINT before_line_item1;

INSERT INTO invoice_line_items 
VALUES (115, 1, 160, 4447.23, 'HW upgrade');
  
SAVEPOINT before_line_item2;

INSERT INTO invoice_line_items 
VALUES (115, 2, 167, 9645.36,'OS upgrade');

-- SELECT invoice_id, invoice_sequence FROM invoice_line_items WHERE invoice_id = 115;

ROLLBACK TO SAVEPOINT before_line_item2;

-- SELECT invoice_id, invoice_sequence FROM invoice_line_items WHERE invoice_id = 115;

ROLLBACK TO SAVEPOINT before_line_item1;

-- SELECT invoice_id, invoice_sequence FROM invoice_line_items WHERE invoice_id = 115;

ROLLBACK TO SAVEPOINT before_invoice;

-- SELECT invoice_id, invoice_number FROM invoices WHERE invoice_id = 115;

COMMIT;
----------------------------------------------------------------------------------
-- 14-03a

-- Transaction A

-- Execute each statement one at a time.
-- Alternate with Transaction B (14-03b.sql) as described.

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

START TRANSACTION;
  
UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 6;

-- The SELECT statement in Transaction B won't show the updated data.
-- The UPDATE statement in Transaction B will wait for transaction A to finish.

COMMIT;

-- The SELECT statement in Transaction B will display the updated data.
-- The UPDATE statement in Transaction B will execute immdediately.

-- clean up code
UPDATE invoices SET credit_total = 0 WHERE invoice_id = 6;
----------------------------------------------------------------------------------
-- 14-03b

-- Transaction B

-- Use a second connection to execute these statements!
-- Otherwise, they won't work as described.

START TRANSACTION;
  
SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

UPDATE invoices SET credit_total = credit_total + 200 WHERE invoice_id = 6;

COMMIT;
----------------------------------------------------------------------------------
-- 14-05

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;