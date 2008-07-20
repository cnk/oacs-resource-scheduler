-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/faculty-oacsmd-create.sql
--
-- Package for holding information directly related to faculty.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-31
-- @cvs-id $Id: faculty-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- FACULTY-----------------------------------
-- -----------------------------------------------------------------------------

declare
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ------------------------------------------------------
	acs_object_type.create_type (
		supertype		=> 'inst_personnel',
		object_type		=> 'inst_faculty_member',
		pretty_name		=> 'Faculty',
		pretty_plural	=> 'Faculty',
		table_name		=> 'INST_FACULTY',
		id_column		=> 'FACULTY_ID'
	);

	-- create attributes -------------------------------------------------------
--	attr_id := acs_attribute.create_attribute (
--		object_type		=> 'inst_faculty_member',
--		attribute_name	=> '',
--		pretty_name		=> '',
--		pretty_plural	=> '',
--		datatype		=> 'text'
--	);
end;
/
show errors;

