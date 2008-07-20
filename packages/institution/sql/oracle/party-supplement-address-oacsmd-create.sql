-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-oacsmd-create.sql
--
-- Package for holding information about parties (Supplementary Party Information)
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-05
-- @cvs-id $Id: party-supplement-address-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- ADDRESS ----------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'address',
		pretty_name		=> 'Address',
		pretty_plural	=> 'Addresses',
		table_name		=> 'INST_PARTY_ADDRESSES',
		id_column		=> 'ADDRESS_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'BUILDING_NAME',
		pretty_name		=> 'Building Name',
		pretty_plural	=> 'Building Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ROOM_NUMBER',
		pretty_name		=> 'Room Number',
		pretty_plural	=> 'Room Numbers',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ADDRESS_LINE_1',
		pretty_name		=> 'Address Line One',
		pretty_plural	=> 'First Address Lines',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ADDRESS_LINE_2',
		pretty_name		=> 'Address Line Two',
		pretty_plural	=> 'Second Address Lines',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ADDRESS_LINE_3',
		pretty_name		=> 'Address Line Three',
		pretty_plural	=> 'Third Address Lines',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ADDRESS_LINE_4',
		pretty_name		=> 'Address Line Four',
		pretty_plural	=> 'Fourth Address Lines',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ADDRESS_LINE_5',
		pretty_name		=> 'Address Line Five',
		pretty_plural	=> 'Fifth Address Lines',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'CITY',
		pretty_name		=> 'City',
		pretty_plural	=> 'Cities',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'FIPS_STATE_CODE',
		pretty_name		=> 'State',
		pretty_plural	=> 'States',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ZIPCODE',
		pretty_name		=> 'Zipcode',
		pretty_plural	=> 'Zipcodes',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'ZIPCODE_EXT',
		pretty_name		=> 'Zipcode Extension',
		pretty_plural	=> 'Zipcode Extensions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'address',
		attribute_name	=> 'COUNTRY_CODE',
		pretty_name		=> 'Country Code',
		pretty_plural	=> 'Country Codes',
		datatype		=> 'string'
	);
end;
/
show errors;

