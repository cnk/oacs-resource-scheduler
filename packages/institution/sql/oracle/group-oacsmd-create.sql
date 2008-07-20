-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/group-oacsmd-create.sql
--
-- Object package for Groups in the institution module.
--
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date 2003/08/24
-- @cvs-id $Id: group-oacsmd-create.sql,v 1.2 2007/03/02 23:56:52 andy Exp $
--

-- -----------------------------------------------------------------------------
-- ----------------------------------- GROUP -----------------------------------
-- -----------------------------------------------------------------------------
declare
	type_id				acs_objects.object_type%TYPE;
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ----------------------------------------------------------
	type_id := 'inst_group';
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> type_id,
		pretty_name		=> 'Institution Group',
		pretty_plural	=> 'Institution Groups',
		table_name		=> 'INST_GROUPS',
		id_column		=> 'GROUP_ID'
	);

	-- create attributes -----------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'QDB_ID',
		pretty_name		=> 'QDB ID',
		pretty_plural	=> 'QDB IDs',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'SHORT_NAME',
		pretty_name		=> 'Short Name',
		pretty_plural	=> 'Short Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_group',
		attribute_name	=> 'KEYWORDS',
		pretty_name		=> 'Keyword',
		pretty_plural	=> 'Keywords',
		datatype		=> 'string'
	);

end;
/
show errors;
