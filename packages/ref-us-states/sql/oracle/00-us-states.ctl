load data infile '[acs_root_dir]/packages/ref-us-states/sql/common/us-states.dat'
into table us_states
replace
fields terminated by "," optionally enclosed by "'"
(abbrev,state_name,fips_state_code)
