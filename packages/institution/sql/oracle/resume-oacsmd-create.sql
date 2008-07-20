-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/resume-oacsmd-create.sql
--
-- Package for holding resumes of personnel.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-05
-- @cvs-id $Id: resume-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- RESUME -----------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'resume',
		pretty_name		=> 'Resume',
		pretty_plural	=> 'Resumes',
		table_name		=> 'INST_PERSONNEL_RESUMES',
		id_column		=> 'RESUME_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'resume',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'resume',
		attribute_name	=> 'FORMAT',
		pretty_name		=> 'Resume Format',
		pretty_plural	=> 'Resume Formats',
		datatype		=> 'string'
	);
end;
/
show errors;
