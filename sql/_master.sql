
SELECT '### DROP TABLES ###' AS ' ';

source drop_tables.sql

SELECT '### CREATE TABLES ###' AS ' ';

source create_tables_ansi.sql

SELECT '### IMPORT AUTHORITY CODE DATA ###' AS ' ';

LOAD DATA LOCAL INFILE '../data/AuthorityCode/Authority_Code_ADDRESS_ALIAS_TYPE_AUT_psv.psv' INTO TABLE ADDRESS_ALIAS_TYPE_AUT FIELDS TERMINATED BY '|' IGNORE 1 LINES;

SELECT '### CREATE TABLE RELATIONSHIPS ###' AS ' ';

source add_fk_constraints.sql

SELECT '### CREATE VIEWS ###' AS ' ';

source address_view.sql

