-- -*- tab-width: 4 -*- --
--
-- packages/ctrl-categories/sql/oracle/categories-oacsmd-create.sql
--
-- OpenACS MetaData for a simple category module (similar to the ACS 3.4.10
-- category module)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-07-17
-- @cvs-id			$Id: ctrl-categories-oacsmd-create.sql,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
--

-- Create an acs_object
begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'ctrl_category',
		pretty_name		=> 'CTRL Category',
		pretty_plural	=> 'CTRL Categories',
		table_name		=> 'ctrl_categories',
		id_column		=> 'category_id',
		name_method		=> 'ctrl_category.name'
	);
end;
/
show errors;

-- Register the attributes
declare
	attr_id acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'ctrl_category',
		attribute_name	=> 'name',
		pretty_name		=> 'Name',
		pretty_plural	=> 'Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'ctrl_category',
		attribute_name	=> 'plural',
		pretty_name		=> 'Plural',
		pretty_plural	=> 'Plurals',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'ctrl_category',
		attribute_name	=> 'description',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'ctrl_category',
		attribute_name	=> 'enabled_p',
		pretty_name		=> 'Enabled?',
		pretty_plural	=> 'Enabled?',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'ctrl_category',
		attribute_name	=> 'profiling_weight',
		pretty_name		=> 'Profiling Weight',
		pretty_plural	=> 'Profiling Weights',
		datatype		=> 'integer'
	);
end;
/
show errors;
