
----------------------------------------------------------------------------------
-- 11-01

CREATE DATABASE ap;

CREATE DATABASE IF NOT EXISTS ap;

DROP DATABASE ap;

DROP DATABASE IF EXISTS ap;

USE ap;
----------------------------------------------------------------------------------
-- 11-02

USE ex;

CREATE TABLE vendors
(
  vendor_id     INT,
  vendor_name   VARCHAR(50)
);

CREATE TABLE vendors
(
  vendor_id     INT            NOT NULL    UNIQUE AUTO_INCREMENT,
  vendor_name   VARCHAR(50)    NOT NULL    UNIQUE
);

CREATE TABLE invoices
(
  invoice_id       INT            NOT NULL    UNIQUE,
  vendor_id        INT            NOT NULL,
  invoice_number   VARCHAR(50)    NOT NULL,
  invoice_date     DATE,
  invoice_total    DECIMAL(9,2)   NOT NULL,
  payment_total    DECIMAL(9,2)               DEFAULT 0
)
----------------------------------------------------------------------------------
-- 11-03

USE ex;

CREATE TABLE vendors
(
  vendor_id     INT            PRIMARY KEY   AUTO_INCREMENT,
  vendor_name   VARCHAR(50)    NOT NULL      UNIQUE
);

CREATE TABLE vendors
(
  vendor_id     INT            AUTO_INCREMENT,
  vendor_name   VARCHAR(50)    NOT NULL,
  CONSTRAINT vendors_pk PRIMARY KEY (vendor_id),
  CONSTRAINT vendor_name_uq UNIQUE (vendor_name)
);

CREATE TABLE invoice_line_items
(
  invoice_id              INT           NOT NULL,
  invoice_sequence        INT           NOT NULL,
  line_item_description   VARCHAR(100)  NOT NULL,
  CONSTRAINT line_items_pk PRIMARY KEY (invoice_id, invoice_sequence)
)
----------------------------------------------------------------------------------
-- 11-04

USE ex;

CREATE TABLE invoices
(
  invoice_id       INT            PRIMARY KEY,
  vendor_id        INT            REFERENCES vendors (vendor_id),
  invoice_number   VARCHAR(50)    NOT NULL    UNIQUE
);

CREATE TABLE invoices
(
  invoice_id       INT           PRIMARY KEY,
  vendor_id        INT           NOT NULL,
  invoice_number   VARCHAR(50)   NOT NULL    UNIQUE,
  CONSTRAINT invoices_fk_vendors
    FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id)
)
----------------------------------------------------------------------------------
-- 11-05

ALTER TABLE vendors
ADD last_transaction_date DATE;

ALTER TABLE vendors
DROP COLUMN last_transaction_date;

ALTER TABLE vendors
MODIFY vendor_name VARCHAR(100) NOT NULL UNIQUE;

ALTER TABLE vendors
MODIFY vendor_name CHAR(100) NOT NULL UNIQUE;

ALTER TABLE vendors
MODIFY vendor_name VARCHAR(100) NOT NULL DEFAULT 'New Vendor';

ALTER TABLE vendors
MODIFY vendor_name VARCHAR(10) NOT NULL UNIQUE;
----------------------------------------------------------------------------------
-- 11-06

ALTER TABLE vendors
ADD PRIMARY KEY (vendor_id);

ALTER TABLE invoices
ADD CONSTRAINT invoices_fk_vendors
FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id);

ALTER TABLE vendors
DROP PRIMARY KEY;

ALTER TABLE invoices
DROP FOREIGN KEY invoices_fk_vendors;
----------------------------------------------------------------------------------
-- 11-07

RENAME TABLE vendors TO vendor;

TRUNCATE TABLE vendor;

DROP TABLE vendor;

DROP TABLE ex.vendor;

DROP TABLE vendors;
----------------------------------------------------------------------------------
-- 11-08

CREATE INDEX invoices_invoice_date_ix
  ON invoices (invoice_date);
  
CREATE INDEX invoices_vendor_id_invoice_number_ix
  ON invoices (vendor_id, invoice_number);
  
CREATE UNIQUE INDEX vendors_vendor_phone_ix
  ON vendors (vendor_phone);
  
CREATE INDEX invoices_invoice_total_ix
  ON invoices (invoice_total DESC);
  
DROP INDEX vendors_vendor_phone_ix ON vendors;
----------------------------------------------------------------------------------
-- 11-09

-- create the database
DROP DATABASE IF EXISTS ap;
CREATE DATABASE ap;

-- select the database
USE ap;

-- create the tables
CREATE TABLE general_ledger_accounts
(
  account_number        INT            PRIMARY KEY,
  account_description   VARCHAR(50)    UNIQUE
);

CREATE TABLE terms
(
  terms_id              INT            PRIMARY KEY,
  terms_description     VARCHAR(50)    NOT NULL,
  terms_due_days        INT            NOT NULL
);

CREATE TABLE vendors
(
  vendor_id                     INT            PRIMARY KEY   AUTO_INCREMENT,
  vendor_name                   VARCHAR(50)    NOT NULL      UNIQUE,
  vendor_address1               VARCHAR(50),
  vendor_address2               VARCHAR(50),
  vendor_city                   VARCHAR(50)    NOT NULL,
  vendor_state                  CHAR(2)        NOT NULL,
  vendor_zip_code               VARCHAR(20)    NOT NULL,
  vendor_phone                  VARCHAR(50),
  vendor_contact_last_name      VARCHAR(50),
  vendor_contact_first_name     VARCHAR(50),
  default_terms_id              INT            NOT NULL,
  default_account_number        INT            NOT NULL,
  CONSTRAINT vendors_fk_terms
    FOREIGN KEY (default_terms_id)
    REFERENCES terms (terms_id),
  CONSTRAINT vendors_fk_accounts
    FOREIGN KEY (default_account_number)
    REFERENCES general_ledger_accounts (account_number)
);
CREATE TABLE invoices
(
  invoice_id            INT            PRIMARY KEY   AUTO_INCREMENT,
  vendor_id             INT            NOT NULL,
  invoice_number        VARCHAR(50)    NOT NULL,
  invoice_date          DATE           NOT NULL,
  invoice_total         DECIMAL(9,2)   NOT NULL,
  payment_total         DECIMAL(9,2)   NOT NULL      DEFAULT 0,
  credit_total          DECIMAL(9,2)   NOT NULL      DEFAULT 0,
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

CREATE TABLE invoice_line_items
(
  invoice_id              INT            NOT NULL,
  invoice_sequence        INT            NOT NULL,
  account_number          INT            NOT NULL,
  line_item_amount        DECIMAL(9,2)   NOT NULL,
  line_item_description   VARCHAR(100)   NOT NULL,
  CONSTRAINT line_items_pk
    PRIMARY KEY (invoice_id, invoice_sequence),
  CONSTRAINT line_items_fk_invoices
    FOREIGN KEY (invoice_id)
    REFERENCES invoices (invoice_id),
  CONSTRAINT line_items_fk_acounts
    FOREIGN KEY (account_number)
    REFERENCES general_ledger_accounts (account_number)
);

-- create an index
CREATE INDEX invoices_invoice_date_ix
  ON invoices (invoice_date DESC);
----------------------------------------------------------------------------------
-- 11-14

SHOW CHARSET;

SHOW CHARSET LIKE 'latin1';

SHOW COLLATION;

SHOW COLLATION LIKE 'latin1%';

SHOW VARIABLES LIKE 'character_set_server';

SHOW VARIABLES LIKE 'collation_server';

SHOW VARIABLES LIKE 'character_set_database';

SHOW VARIABLES LIKE 'collation_database';
----------------------------------------------------------------------------------
-- 11-15

CREATE DATABASE ar CHARSET latin1 COLLATE latin1_swedish_ci;

ALTER DATABASE ar CHARSET utf8 COLLATE utf8_general_ci;

ALTER DATABASE ar CHARSET utf8;

ALTER DATABASE ar COLLATE utf8_general_ci;

CREATE TABLE employees
(
  emp_id        INT          PRIMARY KEY,
  emp_name      VARCHAR(25)
)
CHARSET latin1 COLLATE latin1_swedish_ci;

ALTER TABLE employees 
CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE employees
(
  emp_id        INT          PRIMARY KEY,
  emp_name      VARCHAR(25)  CHARSET latin1 COLLATE latin1_swedish_ci
);

ALTER TABLE employees
MODIFY emp_name VARCHAR(25) CHARSET utf8 COLLATE utf8_general_ci;
----------------------------------------------------------------------------------
-- 11-16

SHOW VARIABLES LIKE 'storage_engine';

SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'ap';
----------------------------------------------------------------------------------
-- 11-17

CREATE TABLE product_descriptions
(
  product_id            INT           PRIMARY KEY,
  product_description   VARCHAR(200)
)
ENGINE = MyISAM;

ALTER TABLE product_descriptions ENGINE = InnoDB;

SET SESSION storage_engine = InnoDB;