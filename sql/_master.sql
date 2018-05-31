
SELECT '### DROP TABLES ###' AS ' ';

source drop_tables.sql

SELECT '### CREATE TABLES ###' AS ' ';

source create_tables_ansi.sql

SELECT '### IMPORT DATA ###' AS ' ';

SELECT '### CREATE TABLE RELATIONSHIPS ###' AS ' ';

source add_fk_constraints.sql

SELECT '### CREATE VIEWS ###' AS ' ';

source address_view.sql

