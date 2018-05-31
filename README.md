# G-NAF Load

These scripts create MySQL database objects and load raw G-NAF address data into them.

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

* If you don't have a MySQL database ready then create one and a user e.g.

```sql
CREATE DATABASE gnaf;
CREATE USER 'gnaf'@'%' IDENTIFIED BY 'gnafsecretpassword';
GRANT ALL PRIVILEGES ON gnaf.* TO 'gnaf'@'%';
```

* As supplied, the `_master.sql` script loads data for all jurisdictions. If you require a subset of this data then comment out the apllicable lines in the loading part of the script.

* Run the `_master.sql` script.

```sh
mysql -u gnaf -h host -p gnaf < _master.sql
```