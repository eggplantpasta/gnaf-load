#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DB="${ROOT_DIR}/gnaf-data/gnaf.db"

# https://ethertubes.com/bash-snippet-calculating-the-distance-between-2-coordinates/

deg2rad () {
        bc -l <<< "$1 * 0.0174532925"
}

rad2deg () {
        bc -l <<< "$1 * 57.2957795"
}

acos () {
        pi="3.141592653589793"
        bc -l <<<"$pi / 2 - a($1 / sqrt(1 - $1 * $1))"
}

distance () {
        lat_1="$1"
        lon_1="$2"
        lat_2="$3"
        lon_2="$4"
        delta_lat=`bc <<<"$lat_2 - $lat_1"`
        delta_lon=`bc <<<"$lon_2 - $lon_1"`
        lat_1="`deg2rad $lat_1`"
        lon_1="`deg2rad $lon_1`"
        lat_2="`deg2rad $lat_2`"
        lon_2="`deg2rad $lon_2`"
        delta_lat="`deg2rad $delta_lat`"
        delta_lon="`deg2rad $delta_lon`"

        distance=`bc -l <<< "s($lat_1) * s($lat_2) + c($lat_1) * c($lat_2) * c($delta_lon)"`
        distance=`acos $distance`
        distance="`rad2deg $distance`"
        distance=`bc -l <<< "$distance * 60 * 1.85200"`
        distance=`bc <<<"scale=4; $distance / 1"`
        echo $distance
}

PERTH_LAT=-31.9510027251793
PERTH_LON=115.860423275377

# test Perth to Albany 375.1 kilometers (233.1 miles)
distance ${PERTH_LAT} ${PERTH_LON} -35.0245861729829 117.883658338622

# make sure the address view exists
sqlite3 ${DB} <<EOF
drop view if exists address_view
EOF
sqlite3 ${DB} < ${ROOT_DIR}/sql/address_view.sql

# create table suburb from address view
sqlite3 ${DB} <<EOF
drop table if exists suburb;
create table suburb as
select 
  state_abbreviation as state
, locality_name as suburb
, postcode as postcode
, avg(latitude) as latitude
, avg(longitude) as longitude
, 0 as km_to_perth
from address_view 
where state_abbreviation = 'WA'
group by state_abbreviation, locality_name, postcode
;
EOF

sqlite3 -csv ${DB} "SELECT rowid, latitude, longitude FROM suburb;" | while IFS=, read rowid lat lon; do
    km=$(distance "$PERTH_LAT" "$PERTH_LON" "$lat" "$lon")
    sqlite3 ${DB} "UPDATE suburb SET km_to_perth=$km WHERE rowid=$rowid;"
done

# test data from db
sqlite3 gnaf-data/gnaf.db "select * from suburb where suburb in ('PERTH', 'ALBANY')"
