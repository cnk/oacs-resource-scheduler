-- /web/drc/packages/ctrl-addresses/sql/oracle/ctrl-addresses-pkg-create.sql
--
-- CTRL Address Package Declaration
-- 
-- @author jmhek@cs.ucla.edu
-- @creation-date 12/06/2005
-- @cvs-id $Id: ctrl-addresses-pkg-create.sql,v 1.1 2005/12/13 00:31:36 jwang1 Exp $
-- 

create or replace package ctrl_address
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
   ) return ctrl_addresses.address_id%TYPE;

   procedure del (
	     address_id in ctrl_addresses.address_id%TYPE
   );

end ctrl_address;
/ 
show errors


 
declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'ctrl_address' ,
        pretty_name        => 'CTRL Address',
        pretty_plural      => 'CTRL Addresses',
        table_name         => 'ctrl_addresses',
        supertype          => 'acs_object',
        id_column          => 'address_id'
    --  other parameters below
    --  abstract_p
    --  type_extension_table
    --  name_method
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_type_id',
        datatype           => 'number' ,
        pretty_name        => 'Address Type ID',
        pretty_plural      => 'Address Type IDs'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'description',
        datatype           => 'string' ,
        pretty_name        => 'description',
        pretty_plural      => 'descriptions'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'room',
        datatype           => 'string' ,
        pretty_name        => 'room',
        pretty_plural      => 'rooms'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'floor',
        datatype           => 'string' ,
        pretty_name        => 'floor',
        pretty_plural      => 'floor'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'building_id',
        datatype           => 'number' ,
        pretty_name        => 'building id',
        pretty_plural      => 'building ids'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_line_1',
        datatype           => 'string' ,
        pretty_name        => 'Address Line 1',
        pretty_plural      => 'Address Line 1'
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_line_2',
        datatype           => 'string' ,
        pretty_name        => 'Address Line 2',
        pretty_plural      => 'Address Line 2'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_line_3',
        datatype           => 'string' ,
        pretty_name        => 'Address Line 3',
        pretty_plural      => 'Address Line 3'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_line_4',
        datatype           => 'string' ,
        pretty_name        => 'Address Line 4',
        pretty_plural      => 'Address Line 4'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'address_line_5',
        datatype           => 'string' ,
        pretty_name        => 'Address Line 5',
        pretty_plural      => 'Address Line 5'
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'city',
        datatype           => 'string' ,
        pretty_name        => 'city',
        pretty_plural      => 'city'
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'fips_state_code',
        datatype           => 'string' ,
        pretty_name        => 'fips_state_code',
        pretty_plural      => 'fips_state_code'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'zipcode',
        datatype           => 'string' ,
        pretty_name        => 'zipcode',
        pretty_plural      => 'zipcodes'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'zipcode_ext',
        datatype           => 'string' ,
        pretty_name        => 'zipcode_ext',
        pretty_plural      => 'zipcode_exts'
    );
 attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'fips_country_code',
        datatype           => 'string' ,
        pretty_name        => 'fips_country_code',
        pretty_plural      => 'fips_country_codes'
    );
 attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_address',
        attribute_name     => 'gis',
        datatype           => 'string' ,
        pretty_name        => 'gis',
        pretty_plural      => 'gis'
    );



end;
/
show errors

commit;




