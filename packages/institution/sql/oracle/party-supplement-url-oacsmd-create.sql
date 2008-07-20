-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-url-oacsmd-create.sql
--
-- Package for maintaining URLs of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-13
-- @cvs-id $Id: party-supplement-url-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- URL --------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'url',
		pretty_name		=> 'URL',
		pretty_plural	=> 'URL',
		table_name		=> 'INST_PARTY_URLS',
		id_column		=> 'URL_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'url',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'url',
		attribute_name	=> 'URL',
		pretty_name		=> 'URL',
		pretty_plural	=> 'URL',
		datatype		=> 'string'
	);
end;
/
show errors;

