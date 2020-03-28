
----------------------------------------------------------------------------------
-- 19-08

USE ap;

SELECT *
INTO OUTFILE '/murach/mysql/vendor_contacts_tab.txt'
FROM vendor_contacts;

SELECT *
INTO OUTFILE '/murach/mysql/vendor_contacts_comma.txt'
FIELDS TERMINATED BY ','
       ENCLOSED BY '"'
       ESCAPED BY '\\'    
FROM vendor_contacts;
----------------------------------------------------------------------------------
-- 19-09

USE ap;

TRUNCATE vendor_contacts;

LOAD DATA INFILE '/murach/mysql/vendor_contacts_tab.txt'
INTO TABLE vendor_contacts;

SELECT *
FROM vendor_contacts;

TRUNCATE vendor_contacts;

LOAD DATA INFILE '/murach/mysql/vendor_contacts_comma.txt'
INTO TABLE vendor_contacts
FIELDS TERMINATED BY ','
       ENCLOSED BY '"'
       ESCAPED BY '\\';

SELECT *
FROM vendor_contacts;
----------------------------------------------------------------------------------
-- 19-10

USE ap;

CHECK TABLE vendors;
 
CHECK TABLE vendors, invoices, terms, invoices_outstanding;
 
CHECK TABLE vendors, invoices FAST;
----------------------------------------------------------------------------------
-- 19-11

USE ap;

REPAIR TABLE vendors;

REPAIR TABLE vendors, invoices QUICK;