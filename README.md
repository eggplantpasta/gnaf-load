# G-NAF Load

Scripts to create, load, and index an [SQLite](https://www.sqlite.org/) database with government [Geocoded National Address File (G-NAF)](https://data.gov.au/dataset/geocoded-national-address-file-g-naf) data.

## Installation and load

### Prerequisites

* A bash shell command line to run the load scripts.
* An installed SQLite runtime.
* A clone or download of this repository.

### Prepare

* Fetch the G_NAF zipped data file and extract it into the `gnaf-data/` directory.
* Edit the `gnaf-import.sh` script and change the variables in the 2 lines below as appropriate.

```sh
GNAF_PATH="gnaf-data/g-naf_nov24_allstates_gda2020_psv_1017/G-NAF"
GNAF_DATA_PATH="gnaf-data/g-naf_nov24_allstates_gda2020_psv_1017/G-NAF/G-NAF NOVEMBER 2024"
```

### Run

* Run the edited script `./gnaf-import.sh`. It will take about 30 minutes to complete.

## References

* GeocodeEarth, [Exploring G-NAF with SQLite](https://geocode.earth/blog/2021/exploring-gnaf-with-sqlite/)
