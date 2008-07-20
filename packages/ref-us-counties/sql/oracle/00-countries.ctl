load data infile '[acs_root_dir]/packages/ref-us-counties/sql/common/us-counties.dat'
into table us_counties
replace
fields terminated by "," optionally enclosed by "'"
(fips_state_code,fips_county_code,name,state_abbrev,population,housing_units,land_area,
 water_area,latitude,longitude)
