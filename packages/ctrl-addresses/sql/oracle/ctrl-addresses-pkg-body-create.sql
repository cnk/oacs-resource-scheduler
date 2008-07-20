-- /packages/ctrl-addresses/sql/oracle/ctrl-addresses-pkg-body-create.sql
--
-- CTRL ADDRESSES Package Definition
-- 
-- @author jmhek@cs.ucla.edu
-- @creation-date 12/06/2005
-- @cvs-id $Id: ctrl-addresses-pkg-body-create.sql,v 1.1 2005/12/13 00:31:36 jwang1 Exp $
-- 

create or replace package body ctrl_address
as 
   function new (
	address_id			in ctrl_addresses.address_id%TYPE,
       	address_type_id			in ctrl_addresses.address_type_id%TYPE,
	description			in ctrl_addresses.description%TYPE default null,
	room				in ctrl_addresses.room%TYPE default null,
	floor				in ctrl_addresses.floor%TYPE default null,
	building_id			in ctrl_addresses.building_id%TYPE default null,
	address_line_1			in ctrl_addresses.address_line_1%TYPE,
	address_line_2			in ctrl_addresses.address_line_2%TYPE default null,
	address_line_3			in ctrl_addresses.address_line_3%TYPE default null,
	address_line_4			in ctrl_addresses.address_line_4%TYPE default null,
	address_line_5			in ctrl_addresses.address_line_5%TYPE default null,
	city				in ctrl_addresses.city%TYPE default null,
	fips_state_code			in ctrl_addresses.fips_state_code%TYPE,
	zipcode				in ctrl_addresses.zipcode%TYPE,
	zipcode_ext			in ctrl_addresses.zipcode_ext%TYPE default null,
	fips_country_code		in ctrl_addresses.fips_country_code%TYPE,
	gis				in ctrl_addresses.gis%TYPE default null,
	creation_date			in acs_objects.creation_date%TYPE default sysdate,
	creation_user			in acs_objects.creation_user%TYPE default null,
	object_type			in acs_object_types.object_type%TYPE default 'ctrl_address',
	creation_ip			in acs_objects.creation_ip%TYPE default null,
	context_id			in acs_objects.context_id%TYPE default null
   ) return ctrl_addresses.address_id%TYPE
   is 
	v_address_id acs_objects.object_id%TYPE;
   begin
	v_address_id := acs_object.new (
	  object_id       => address_id,
	  creation_date   => creation_date,
	  creation_user	  => creation_user,
	  object_type	  => object_type,
	  creation_ip	  => creation_ip,
	  context_id	  => context_id
	);

	insert into ctrl_addresses (
		address_id, address_type_id, description, room, floor, building_id,
		address_line_1, address_line_2, address_line_3, address_line_4, address_line_5,
		city, fips_state_code, zipcode, zipcode_ext, fips_country_code, gis
	) values (
		v_address_id, new.address_type_id, new.description, new.room, new.floor, new.building_id,
		new.address_line_1, new.address_line_2, new.address_line_3, new.address_line_4, new.address_line_5,
		new.city, new.fips_state_code, new.zipcode, new.zipcode_ext, new.fips_country_code, new.gis
	);

	return v_address_id;
   end new;
   
   procedure del (
	address_id in ctrl_addresses.address_id%TYPE
   )
   is 
   begin
	acs_object.del(address_id);
   end del;
end ctrl_address;
/ 
show errors

commit;
