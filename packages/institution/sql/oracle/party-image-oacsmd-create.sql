-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-image-oacsmd-create.sql
--
-- Package for holding images of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-05-18
-- @cvs-id $Id: party-image-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- PARTY IMAGE ---------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'inst_party_image',
		pretty_name		=> 'Party Image',
		pretty_plural	=> 'Party Images',
		table_name		=> 'INST_PARTY_IMAGES',
		id_column		=> 'IMAGE_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_party_image',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_party_image',
		attribute_name	=> 'IMAGE',
		pretty_name		=> 'Image',
		pretty_plural	=> 'Images',
		datatype		=> 'text'
	);
end;
/
show errors;

