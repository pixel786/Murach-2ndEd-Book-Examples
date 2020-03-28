
----------------------------------------------------------------------------------
-- 17-08

SET GLOBAL  autocommit = ON;
SET SESSION autocommit = OFF;
SET GLOBAL  autocommit = DEFAULT;

SET GLOBAL  max_connections = 90;
SET GLOBAL  max_connections = DEFAULT;

SET GLOBAL  tmp_table_size = 36700160;
SET GLOBAL  tmp_table_size = 35 * 1024 * 1024;

SELECT @@GLOBAL.autocommit, @@SESSION.autocommit;

SELECT @@autocommit;

-- reset values
SET SESSION autocommit = DEFAULT;
SET GLOBAL  tmp_table_size = DEFAULT;
----------------------------------------------------------------------------------
-- 17-11

SELECT * FROM mysql.general_log;

SELECT * FROM mysql.slow_log;

----------------------------------------------------------------------------------
-- 17-13

USE mysql;

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS general_log_rotate;

DELIMITER //

CREATE EVENT general_log_rotate
ON SCHEDULE EVERY 1 MONTH
DO BEGIN
  DROP TABLE IF EXISTS general_log_old;
  
  CREATE TABLE general_log_old AS
  SELECT *
  FROM general_log;
  
  TRUNCATE general_log;
END//

DELIMITER ;

SELECT * FROM mysql.general_log;