#!/usr/bin/env bash

# based on code from https://geocode.earth/blog/2021/exploring-gnaf-with-sqlite/

# edit these variables to the correct paths (relative to the root of the repository)
GNAF_PATH="gnaf-data/g-naf_nov24_allstates_gda2020_psv_1017/G-NAF"
GNAF_DATA_PATH="gnaf-data/g-naf_nov24_allstates_gda2020_psv_1017/G-NAF/G-NAF NOVEMBER 2024"

###########################################################
# generate the database schema
###########################################################

rm -f gnaf-data/gnaf.db gnaf-data/gnaf-import.sql gnaf-data/gnaf-indices.sql
sqlite3 gnaf-data/gnaf.db < ${GNAF_PATH}/Extras/GNAF_TableCreation_Scripts/create_tables_ansi.sql

###########################################################
# generate the import script
###########################################################

# handle spaces in filenames
exec > gnaf-data/gnaf-import.sql
OIFS="$IFS"
IFS=$'\n'

# csv mode (configured for .psv files)
echo '.mode csv'
echo '.separator "|"'

# fast import pragmas
echo 'PRAGMA synchronous=OFF;'
echo 'PRAGMA journal_mode=OFF;'
echo 'PRAGMA temp_store=MEMORY;'

# be verbose
echo '.echo on'

# import 'authority code'
for FILEPATH in `find "${GNAF_DATA_PATH}/Authority Code" -type f -name "*.psv"`; do
  BASENAME=$(basename $FILEPATH)
  TABLE_NAME="${BASENAME/Authority_Code_/}"
  TABLE_NAME="${TABLE_NAME/_psv.psv/}"
  TABLE_NAME="${TABLE_NAME/.psv/}"
  echo ".import '${FILEPATH}' '${TABLE_NAME}'"
done

# import 'standard'
for FILEPATH in `find "${GNAF_DATA_PATH}/Standard" -type f -name "*.psv"`; do
  BASENAME=$(basename $FILEPATH)
  TABLE_NAME="${BASENAME#*_}"
  TABLE_NAME="${TABLE_NAME/_psv.psv/}"
  TABLE_NAME="${TABLE_NAME/.psv/}"

  # only import to uppercase tables
  # this avoids files like 'nt_locality_pid_linkage.psv which don't exist in the schema
  if [[ $TABLE_NAME != $(echo $TABLE_NAME | tr '[:lower:]' '[:upper:']) ]]; then
    continue
  fi

  # skip the header row
  echo ".import '| tail -n +2 \"${FILEPATH}\"' '${TABLE_NAME}'"
done

IFS="$OIFS"
exec >/dev/tty

###########################################################
# import the data
###########################################################

sqlite3 gnaf-data/gnaf.db < gnaf-data/gnaf-import.sql

###########################################################
# index the data
###########################################################

sqlite3 gnaf-data/gnaf.db > gnaf-data/gnaf-indices.sql << SQL

  /* use fast import pragmas */
  SELECT 'PRAGMA synchronous=OFF;';
  SELECT 'PRAGMA journal_mode=OFF;';
  SELECT 'PRAGMA temp_store=MEMORY;';
  SELECT '.echo on';

  SELECT printf(
    'CREATE INDEX IF NOT EXISTS %s ON %s (%s);',
    printf('%s_%s', LOWER(t.name), LOWER(c.name)),
    t.name, c.name
  )
  FROM sqlite_master t
  LEFT OUTER JOIN pragma_table_info(t.name) c
  WHERE t.type = 'table'
  AND (
    c.name LIKE '%\_pid' ESCAPE '\' OR
    c.name LIKE '%\_code' ESCAPE '\' OR
    c.name == 'code'
  );
SQL

sqlite3 gnaf-data/gnaf.db < gnaf-data/gnaf-indices.sql