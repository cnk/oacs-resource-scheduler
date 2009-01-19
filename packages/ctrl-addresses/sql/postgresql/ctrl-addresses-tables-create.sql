-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-tables-create.sql
-- 
-- The CTRL ADDRESS Package used to manage address for objects
-- 
-- @author jmhek@cs.ucla.edu 
-- @author cnk@ugcs.caltech.edu
-- @creation-date 08/16/2008
-- @cvs-id $Id:$
-- 

create table ctrl_addresses (
	address_id			integer
					constraint ctrl_addresses_address_id_pk primary key
					constraint ctrl_addrressses_address_id_fk references acs_objects(object_id),
       	address_type_id			integer
					constraint ctrl_addresses_address_type_id_nn not null
					constraint ctrl_addresses_address_type_id_fk references ctrl_categories(category_id),
	description			varchar(1000),
	room				varchar(50),
	floor				varchar(50),
	building_id			integer
					constraint ctrl_addresses_building_id_fk references ctrl_categories(category_id),
	address_line_1			varchar(200)
					constraint ctrl_addresses_address_line_1_nn not null,
	address_line_2			varchar(200),
	address_line_3			varchar(200),
	address_line_4			varchar(200),
	address_line_5			varchar(200),
	city				varchar(200),
	fips_state_code			char(2)
					constraint ctrl_addresses_fips_state_code_nn not null
					constraint ctrl_addresses_fips_state_code_fk references us_states(fips_state_code),
	zipcode				char(5)
					constraint ctrl_addresses_zipcode_nn not null,
	constraint ctrl_addresses_zipcode_fk foreign key (fips_state_code,zipcode) references us_zipcodes(fips_state_code,zipcode),
	zipcode_ext			char(4),
	fips_country_code		char(2)
					constraint ctrl_addresses_fips_country_code_fk references countries(iso),
	gis				varchar(1000)
);
