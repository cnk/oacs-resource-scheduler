-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/title-oacsmd-create.sql
--
-- Package for holding personnel-title information.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2005-02-16
-- @cvs-id			$Id: title-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ----------------------------------- TITLE -----------------------------------
-- -----------------------------------------------------------------------------
declare
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ------------------------------------------------------
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'inst_title',
		pretty_name		=> 'Title',
		pretty_plural	=> 'Titles',
		table_name		=> 'INST_GROUP_PERSONNEL_MAP',
		id_column		=> 'GPM_TITLE_ID'
	);

	-- create attributes -------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_title',
		attribute_name	=> 'PRETTY_TITLE',
		pretty_name		=> 'Title',
		pretty_plural	=> 'Titles',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_title',
		attribute_name	=> 'START_DATE',
		pretty_name		=> 'Start Date',
		pretty_plural	=> 'Start Dates',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_title',
		attribute_name	=> 'END_DATE',
		pretty_name		=> 'End Date',
		pretty_plural	=> 'End Dates',
		datatype		=> 'date'
	);
end;
/
show errors;

