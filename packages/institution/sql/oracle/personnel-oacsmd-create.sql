-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-oacsmd-create.sql
--
-- Package for holding information directly related to personnel.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-14
-- @cvs-id $Id: personnel-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- --------------------------------- PERSONNEL ---------------------------------
-- -----------------------------------------------------------------------------

declare
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ------------------------------------------------------
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'inst_personnel',
		pretty_name		=> 'Employee',
		pretty_plural	=> 'Employees',
		table_name		=> 'INST_PERSONNEL',
		id_column		=> 'PERSONNEL_ID'
	);

	-- create attributes -------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_FIRST_NAME',
		pretty_name		=> 'Preferred First Name',
		pretty_plural	=> 'Preferred First Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_MIDDLE_NAME',
		pretty_name		=> 'Preferred Middle Name',
		pretty_plural	=> 'Preferred Middle Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'PREFERRED_LAST_NAME',
		pretty_name		=> 'Preferred Last Name',
		pretty_plural	=> 'Preferred Last Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'EMPLOYEE_NUMBER',
		pretty_name		=> 'Employee Number',
		pretty_plural	=> 'Employee Numbers',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'GENDER',
		pretty_name		=> 'Gender',
		pretty_plural	=> 'Genders',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'DATE_OF_BIRTH',
		pretty_name		=> 'Birthday',
		pretty_plural	=> 'Birthdays',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'START_DATE',
		pretty_name		=> 'Start of Employment',
		pretty_plural	=> 'Starts of Employment',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'END_DATE',
		pretty_name		=> 'End of Employment',
		pretty_plural	=> 'Ends of Employment',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'STATUS',
		pretty_name		=> 'Employment Status',
		pretty_plural	=> 'Employment States',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'BIO',
		pretty_name		=> 'Bio Sketch',
		pretty_plural	=> 'Bio Sketches',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'NOTES',
		pretty_name		=> 'Note',
		pretty_plural	=> 'Notes',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'PHOTO',
		pretty_name		=> 'Photo',
		pretty_plural	=> 'Photos',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_personnel',
		attribute_name	=> 'META_KEYWORDS',
		pretty_name		=> 'Meta Keyword',
		pretty_plural	=> 'Meta Keywords',
		datatype		=> 'string'
	);

end;
/
show errors;

