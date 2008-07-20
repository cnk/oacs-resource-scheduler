-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-phone-oacsmd-create.sql
--
-- Package for holding information about parties (Supplementary Party Information)
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-05
-- @cvs-id $Id: party-supplement-phone-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- PHONE NUMBER --------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'phone_number',
		pretty_name		=> 'Phone Number',
		pretty_plural	=> 'Phone Numbers',
		table_name		=> 'INST_PARTY_PHONES',
		id_column		=> 'PHONE_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'phone_number',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'phone_number',
		attribute_name	=> 'PHONE_NUMBER',
		pretty_name		=> 'Phone Number',
		pretty_plural	=> 'Phone Numbers',
		datatype		=> 'string'
	);
end;
/
show errors;

