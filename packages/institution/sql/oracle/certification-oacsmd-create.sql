-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/certification-oacsmd-create.sql
--
-- Certification object package for recording various kinds of certifications:
--	Awards, Education, Degrees, Licenses, etc.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-18
-- @cvs-id $Id: certification-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

comment on column inst_certifications.start_date is '
This field describes when the party began acquiring this certification.
';

declare
	type_id				acs_objects.object_type%TYPE;
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ----------------------------------------------------------
	type_id := 'certification';
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> type_id,
		pretty_name		=> 'Certification',
		pretty_plural	=> 'Certifications',
		table_name		=> 'INST_CERTIFICATIONS',
		id_column		=> 'CERTIFICATION_ID'
	);

	-- create attributes -----------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'CERTIFYING_PARTY',
		pretty_name		=> 'Certifying Party',
		pretty_plural	=> 'Certifying Parties',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'CERTIFICATION_CREDENTIAL',
		pretty_name		=> 'Credential',
		pretty_plural	=> 'Credentials',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'START_DATE',
		pretty_name		=> 'Start Date',
		pretty_plural	=> 'Start Dates',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'CERTIFICATION_DATE',
		pretty_name		=> 'Certification Date',
		pretty_plural	=> 'Certification Dates',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> type_id,
		attribute_name	=> 'EXPIRATION_DATE',
		pretty_name		=> 'Expiration Date',
		pretty_plural	=> 'Expiration Dates',
		datatype		=> 'date'
	);
end;
/
show errors;

