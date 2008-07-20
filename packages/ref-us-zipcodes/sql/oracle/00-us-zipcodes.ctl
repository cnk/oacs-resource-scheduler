load data infile '[acs_root_dir]/packages/ref-us-zipcodes/sql/common/us-zipcodes.dat'
into table us_zipcodes
replace
fields terminated by "," optionally enclosed by "'"
(zipcode,name,fips_state_code,fips_county_code,latitude,longitude)
