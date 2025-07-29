-- WA	PERTH	6000	-31.9510027251793	115.860423275377
-- radius of earth = 6371km
-- pi (12 decimal places) = 3.141592653589
-- 1 radian (pi/180) = 0.0174532925199389

drop table suburb;
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