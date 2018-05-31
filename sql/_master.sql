
SELECT '### CREATE TABLES ###' AS ' ';

source raw-gnaf/DOWNLOAD/G-NAF/Extras/GNAF_TableCreation_Scripts/create_tables_ansi.sql

SELECT '### IMPORT DATA ###' AS ' ';

SELECT '### CREATE TABLE RELATIONSHIPS ###' AS ' ';

source raw-gnaf/DOWNLOAD/G-NAF/Extras/GNAF_TableCreation_Scripts/add_fk_constraints.sql

SELECT '### CREATE VIEWS ###' AS ' ';


