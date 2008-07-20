-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-tables-create.sql
-- 
-- The CTRL ADDRESS Package used to manage address for objects
-- 
-- @creation-date 12/06/2005
-- @author jmhek@cs.ucla.edu 
-- @cvs-id $Id: ctrl-addresses-tables-create.sql,v 1.1 2005/12/13 00:31:36 jwang1 Exp $
-- 

create table ctrl_addresses (
	address_id			integer
					constraint ctrl_addr_addr_id_pk primary key
					constraint ctrl_addr_addr_id_fk references acs_objects(object_id),
       	address_type_id			integer
					constraint ctrl_addr_addr_type_id_nn not null
					constraint ctrl_addr_addr_type_id_fk references ctrl_categories(category_id),
	description			varchar2(1000),
	room				varchar2(50),
	floor				varchar2(50),
	building_id			integer
					constraint ctrl_addr_building_id_fk references ctrl_categories(category_id),
	address_line_1			varchar2(200)
					constraint ctrl_addr_addr_line_1_nn not null,
	address_line_2			varchar2(200),
	address_line_3			varchar2(200),
	address_line_4			varchar2(200),
	address_line_5			varchar2(200),
	city				varchar2(200),
	fips_state_code			char(2)
					constraint ctrl_addr_fips_state_code_nn not null
					constraint ctrl_addr_fips_state_code_fk references us_states(fips_state_code),
	zipcode				char(5)
					constraint ctrl_addr_zipcode_nn not null,
	constraint ctrl_addr_zipcode_fk foreign key (fips_state_code,zipcode) references us_zipcodes(fips_state_code,zipcode),
	zipcode_ext			char(4),
	fips_country_code		char(2)
					constraint ctrl_addr_fips_country_code_fk references countries(iso),
	gis				varchar2(1000)
);
