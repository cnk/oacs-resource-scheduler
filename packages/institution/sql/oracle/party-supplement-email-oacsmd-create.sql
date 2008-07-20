-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-email-oacsmd-create.sql
--
-- Package for holding email addresses of parties.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-13
-- @cvs-id $Id: party-supplement-email-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ------------------------------- EMAIL ADDRESS --------------------------------
-- -----------------------------------------------------------------------------

-- create object type ----------------------------------------------------------
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'email_address',
		pretty_name		=> 'Email Address',
		pretty_plural	=> 'Email Addresses',
		table_name		=> 'INST_PARTY_EMAILS',
		id_column		=> 'EMAIL_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'email_address',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'email_address',
		attribute_name	=> 'EMAIL',
		pretty_name		=> 'Email Address',
		pretty_plural	=> 'Email Addresses',
		datatype		=> 'string'
	);
end;
/
show errors;

