
----------------------------------------------------------------------------------
-- 18-01

-- to execute a single statement, move the cursor into the statement and press Ctrl+Enter
-- to execute the entire script, press Ctrl+Shift+Enter
-- to fix errors, you may need to execute the entire script twice

-- connect as root user before executing this script

-- drop users for the AP database
-- if they don't exist, these statements cause errors
DROP USER ap_admin@localhost;
DROP USER ap_user@localhost;

CREATE USER ap_admin@localhost IDENTIFIED BY 'pa55word';
CREATE USER ap_user@localhost IDENTIFIED BY 'pa55word';

GRANT ALL
ON ap.*
TO ap_admin@localhost;

GRANT SELECT, INSERT, DELETE, UPDATE
ON ap.*
TO ap_user@localhost;

-- view the privileges for these users
SHOW GRANTS FOR ap_admin@localhost;
----------------------------------------------------------------------------------
-- 18-04

-- drop users
-- if they don't exist, these statements cause errors
DROP USER joel@localhost;
DROP USER jane;

CREATE USER joel@localhost IDENTIFIED BY 'sesame';

CREATE USER jane IDENTIFIED BY 'sesame';    -- creates jane@%

RENAME USER joel@localhost TO joelmurach@localhost;

DROP USER joelmurach@localhost;

DROP USER jane;                             -- drops jane@%

----------------------------------------------------------------------------------
-- 18-06

GRANT USAGE
ON *.*
TO joel@localhost IDENTIFIED BY 'sesame';

GRANT ALL 
ON *.*
TO jim IDENTIFIED BY 'supersecret'
WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ap.*
TO ap_user@localhost IDENTIFIED BY 'pa55word';

GRANT SELECT, INSERT, UPDATE
ON *.* TO ap_user@localhost;

GRANT SELECT, INSERT, UPDATE
ON ap.* TO joel@localhost;

GRANT SELECT, INSERT, UPDATE
ON ap.vendors TO joel@localhost;

GRANT SELECT (vendor_name, vendor_state, vendor_zip_code), 
      UPDATE (vendor_address1)
ON ap.vendors TO joel@localhost;

GRANT SELECT, INSERT, UPDATE, DELETE
ON vendors TO ap_user@localhost;
----------------------------------------------------------------------------------
-- 18-07

SELECT User, Host FROM mysql.user;
 
SHOW GRANTS FOR jim;
 
SHOW GRANTS FOR ap_user@localhost;
 
SHOW GRANTS;

----------------------------------------------------------------------------------
-- 18-08

REVOKE ALL, GRANT OPTION 
FROM jim;

REVOKE ALL, GRANT OPTION 
FROM ap_admin, joel@localhost;

REVOKE UPDATE, DELETE
ON ap.invoices FROM joel@localhost
----------------------------------------------------------------------------------
-- 18-09

SET PASSWORD FOR john = PASSWORD('pa55word');

SET PASSWORD = PASSWORD('secret');

GRANT USAGE ON *.* TO john IDENTIFIED BY 'pa55word';

SELECT Host, User
FROM mysql.user
WHERE Password = '';
----------------------------------------------------------------------------------
-- 18-10

-- drop the users (causes an error if they don't exist yet)
DROP USER john;
DROP USER jane;
DROP USER jim;
DROP USER joel@localhost;

-- create the users
CREATE USER john IDENTIFIED BY 'sesame';
CREATE USER jane IDENTIFIED BY 'sesame';
CREATE USER jim IDENTIFIED BY 'sesame';
CREATE USER joel@localhost IDENTIFIED BY 'sesame';

-- grant privileges to the ap_developer (joel)
GRANT ALL ON *.* TO joel@localhost WITH GRANT OPTION;

-- grant privileges to the ap manager (jim)
GRANT SELECT, INSERT, UPDATE, DELETE ON ap.* TO jim;
GRANT USAGE ON ap.* TO jim WITH GRANT OPTION;

-- grant privileges to ap users (john, jane)
GRANT SELECT, INSERT, UPDATE, DELETE ON ap.vendors TO john, jane;
GRANT SELECT, INSERT, UPDATE, DELETE ON ap.invoices TO john, jane;
GRANT SELECT, INSERT, UPDATE, DELETE ON ap.invoice_line_items TO john, jane;
GRANT SELECT ON ap.general_ledger_accounts TO john, jane;
GRANT SELECT ON ap.terms TO john, jane;

-- view user account data
SELECT User, Host, Password FROM mysql.user;

-- view the privileges for each user
SHOW GRANTS FOR john;
SHOW GRANTS FOR jane;
SHOW GRANTS FOR jim;
SHOW GRANTS FOR joel@localhost;