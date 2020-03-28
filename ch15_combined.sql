
----------------------------------------------------------------------------------
-- 15-01

USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param      INT,
  credit_total_param    DECIMAL(9,2) 
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;  

  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;

  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//

DELIMITER ;

-- Use the CALL statement
CALL update_invoices_credit_total(56, 200);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- Use the CALL statement within a stored procedure
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  CALL update_invoices_credit_total(56, 300);
END//

DELIMITER ;

CALL test();

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- Reset data to original value
CALL update_invoices_credit_total(56, 0);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;
----------------------------------------------------------------------------------
-- 15-02

USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  IN invoice_id_param    INT,
  IN credit_total_param  DECIMAL(9,2), 
  OUT update_count       INT
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    SET update_count = 1;
    COMMIT;
  ELSE
    SET update_count = 0;
    ROLLBACK;
  END IF;
END//

DELIMITER ;

CALL update_invoices_credit_total(56, 200, @row_count);

CALL update_invoices_credit_total(56, 0, @row_count);

SELECT CONCAT('row_count: ', @row_count) AS update_count;
----------------------------------------------------------------------------------
-- 15-03

USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param     INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    
  -- Set default values for NULL values
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;

  START TRANSACTION;
  
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//

DELIMITER ;

-- call with param
CALL update_invoices_credit_total(56, 200);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- call without param
CALL update_invoices_credit_total(56, NULL);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- reset data
CALL update_invoices_credit_total(56, 0);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;
----------------------------------------------------------------------------------
-- 15-04

USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param     INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
  -- Validate paramater values
  IF credit_total_param < 0 THEN
    UPDATE `The credit_total column must be greater than or equal to 0.`
       SET x = 'This UPDATE statement raises an error';
  ELSEIF credit_total_param >= 1000 THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 
        'The credit_total column must be less than 1000.', 
      MYSQL_ERRNO = 1264;
  END IF;

  -- Set default values for parameters
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;

  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;  
END//

DELIMITER ;

CALL update_invoices_credit_total(56, NULL);

CALL update_invoices_credit_total(56, -100);

CALL update_invoices_credit_total(56, 1000);

CALL update_invoices_credit_total(56, 0);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;
----------------------------------------------------------------------------------
-- 15-05

USE ap;

DROP PROCEDURE IF EXISTS insert_invoice;

DELIMITER //

CREATE PROCEDURE insert_invoice
(
  vendor_id_param        INT,
  invoice_number_param   VARCHAR(50),
  invoice_date_param     DATE,
  invoice_total_param    DECIMAL(9,2),
  terms_id_param         INT,
  invoice_due_date_param DATE
)
BEGIN
  DECLARE terms_id_var           INT;
  DECLARE invoice_due_date_var   DATE;  
  DECLARE terms_due_days_var     INT;

  -- Validate paramater values
  IF invoice_total_param < 0 THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 'The invoice_total column must be a positive number.', 
      MYSQL_ERRNO = 1264;
  ELSEIF invoice_total_param >= 1000000 THEN
    SIGNAL SQLSTATE '22003'
      SET MESSAGE_TEXT = 'The invoice_total column must be less than 1,000,000.', 
      MYSQL_ERRNO = 1264;
  END IF;

  -- Set default values for parameters
  IF terms_id_param IS NULL THEN
    SELECT default_terms_id INTO terms_id_var
    FROM vendors WHERE vendor_id = vendor_id_param;
  ELSE
    SET terms_id_var = terms_id_param;
  END IF;
  IF invoice_due_date_param IS NULL THEN
    SELECT terms_due_days INTO terms_due_days_var
      FROM terms WHERE terms_id = terms_id_var;
    SELECT DATE_ADD(invoice_date_param, INTERVAL terms_due_days_var DAY) 
      INTO invoice_due_date_var;
  ELSE
    SET invoice_due_date_var = invoice_due_date_param;
  END IF;

  INSERT INTO invoices
         (vendor_id, invoice_number, invoice_date, 
          invoice_total, terms_id, invoice_due_date)
  VALUES (vendor_id_param, invoice_number_param, invoice_date_param, 
          invoice_total_param, terms_id_var, invoice_due_date_var);
END//

DELIMITER ;

-- test
CALL insert_invoice(34, 'ZXA-080', '2015-01-18', 14092.59, 
                    3, '2015-03-18');
CALL insert_invoice(34, 'ZXA-082', '2015-01-18', 14092.59,
                    NULL, NULL);

-- this statement raises an error
CALL insert_invoice(34, 'ZXA-083', '2015-01-18', -14092.59,
                    NULL, NULL);

-- clean up
SELECT * FROM invoices WHERE invoice_id >= 115;

DELETE FROM invoices WHERE invoice_id >= 115;
----------------------------------------------------------------------------------
-- 15-06

USE ap;

DROP PROCEDURE IF EXISTS set_global_count;
DROP PROCEDURE IF EXISTS increment_global_count;

DELIMITER //

CREATE PROCEDURE set_global_count
(
  count_var INT
)
BEGIN
  SET @count = count_var;  
END//

CREATE PROCEDURE increment_global_count()
BEGIN
  SET @count = @count + 1;
END//

DELIMITER ;

CALL set_global_count(100);
CALL increment_global_count();

SELECT @count AS count_var

----------------------------------------------------------------------------------
-- 15-07

USE ap;

DROP PROCEDURE IF EXISTS select_invoices;

DELIMITER //

CREATE PROCEDURE select_invoices
(
  min_invoice_date_param   DATE,
  min_invoice_total_param  DECIMAL(9,2)
)
BEGIN
  DECLARE select_clause VARCHAR(200);
  DECLARE where_clause  VARCHAR(200);
  
  SET select_clause = "SELECT invoice_id, invoice_number, 
                       invoice_date, invoice_total 
                       FROM invoices ";      
  SET where_clause =  "WHERE ";
      
  IF min_invoice_date_param IS NOT NULL THEN
    SET where_clause = CONCAT(where_clause, 
       " invoice_date > '", min_invoice_date_param, "'");
  END IF;

  IF min_invoice_total_param IS NOT NULL THEN
    IF where_clause != "WHERE " THEN
      SET where_clause = CONCAT(where_clause, "AND ");
    END IF;
    SET where_clause = CONCAT(where_clause, 
       "invoice_total > ", min_invoice_total_param);
  END IF;

  IF where_clause = "WHERE " THEN
    SET @dynamic_sql = select_clause;
  ELSE
    SET @dynamic_sql = CONCAT(select_clause, where_clause);    
  END IF;
  
  PREPARE select_invoices_statement
  FROM @dynamic_sql;

  EXECUTE select_invoices_statement;
  
  DEALLOCATE PREPARE select_invoices_statement;  
END//

DELIMITER ;

CALL select_invoices('2014-07-25', 100);

CALL select_invoices('2014-07-25', NULL);

CALL select_invoices(NULL, 1000);

CALL select_invoices(NULL, NULL);

----------------------------------------------------------------------------------
-- 15-08

USE ap;

DROP PROCEDURE IF EXISTS clear_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE clear_invoices_credit_total
(
  invoice_id_param  INT
)
BEGIN
  UPDATE invoices
  SET credit_total = 0
  WHERE invoice_id = invoice_id_param;  
END//

DELIMITER ;

CALL clear_invoices_credit_total(56);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

DROP PROCEDURE clear_invoices_credit_total;
----------------------------------------------------------------------------------
-- 15-09

USE ap;

DROP FUNCTION IF EXISTS get_vendor_id;

DELIMITER //

CREATE FUNCTION get_vendor_id
(
   vendor_name_param VARCHAR(50)
)
RETURNS INT
BEGIN
  DECLARE vendor_id_var INT;
  
  SELECT vendor_id
  INTO vendor_id_var
  FROM vendors
  WHERE vendor_name = vendor_name_param;
  
  RETURN(vendor_id_var);
END//

DELIMITER ;

SELECT invoice_number, invoice_total
FROM invoices
WHERE vendor_id = get_vendor_id('IBM');

----------------------------------------------------------------------------------
-- 15-10

USE ap;

DROP FUNCTION IF EXISTS get_balance_due;

DELIMITER //

CREATE FUNCTION get_balance_due
(
   invoice_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE balance_due_var DECIMAL(9,2);
  
  SELECT invoice_total - payment_total - credit_total
  INTO balance_due_var
  FROM invoices
  WHERE invoice_id = invoice_id_param;
  
  RETURN balance_due_var;
END//

DELIMITER ;

SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due 
FROM invoices
WHERE vendor_id = 37;
----------------------------------------------------------------------------------
-- 15-11

USE ap;

DROP FUNCTION IF EXISTS get_sum_balance_due;

DELIMITER //

CREATE FUNCTION get_sum_balance_due
(
   vendor_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE sum_balance_due_var DECIMAL(9,2);
  
  SELECT SUM(get_balance_due(invoice_id))
  INTO sum_balance_due_var 
  FROM invoices
  WHERE vendor_id = vendor_id_param;
  
  RETURN sum_balance_due_var;
END//

DELIMITER ;

SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due, 
       get_sum_balance_due(vendor_id) AS sum_balance_due
FROM invoices
WHERE vendor_id = 37;

DROP FUNCTION get_sum_balance_due;