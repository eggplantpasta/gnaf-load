# G-NAF Load

These scripts create MySQL database objects and load the raw Geocoded National Address File (G-NAF) data into them.

**_Note: As of this release these scripts have been tested on the "May 2018 - PSMA Geocoded National Address File (G-NAF)" only. Earlier and later releases may have a different database structure and the scripts will have to be changed accordingly._**

The loading scripts are based on instructions contained in the [Quick reference guide on unpacking the G-NAF](https://www.psma.com.au/sites/default/files/g-naf_-_getting_started_guide.pdf) and have been tested on MySQL.

## Instalation

* Download the latest [PSMA Geocoded National Address File (G-NAF)](https://data.gov.au/dataset/geocoded-national-address-file-g-naf) from data.gov.au and unzip it.

* Move the raw data directories `Authority Code` and `Standard` from the unzipped contents into the `data` directory. The containing folder names vary per release.

```
MAY18_GNAF_PipeSeparatedValue_20180521161504/
    - G-NAF/
        - G-NAF MAY 2018/
            - Authority Code
            - Standard
```

e.g.

```sh
mv "MAY18_GNAF_PipeSeparatedValue_20180521161504/G-NAF/G-NAF MAY 2018/Authority Code" data
mv "MAY18_GNAF_PipeSeparatedValue_20180521161504/G-NAF/G-NAF MAY 2018/Standard" data
```

* If you don't have a MySQL database ready then create one and a user to go with it.

e.g.

```sql
CREATE DATABASE gnaf;
CREATE USER 'gnaf'@'%' IDENTIFIED BY 'gnafsecretpassword';
GRANT ALL PRIVILEGES ON gnaf.* TO 'gnaf'@'%';
GRANT FILE on *.* to 'gnaf'@'%';
```

* As supplied, the `_master.sql` script loads data for all jurisdictions. If you require a subset of this data then comment out the apllicable lines in the loading part of the script.

* Run the `_master.sql` script.

```sh
cd sql
mysql -u gnaf -h host -p gnaf < _master.sql
```

## Troubleshooting

### Error loading data from files

`ERROR 1148 (42000) at line 12: The used command is not allowed with this MariaDB version`

See Stack overflow question "[access denied for load data infile in MySQL
](https://stackoverflow.com/questions/2221335/access-denied-for-load-data-infile-in-mysql)" for issues with loading the datafile.

Try loading the files into a local mysql database if you can't get them to load over a remote connection.

### Insufficient permissions on the destination database

If you are unable to get the required permissions on the destination server then as a work around you can run the scripts into a local MySQL instance on your machine and then make a dumpfile of the data that cann be run wherever required.

```sh
mysqldump -u gnaf -p gnaf db_name > gnaf-dump.sql
mysql -u gnaf -h host -p gnaf < gnaf-dump.sql
```