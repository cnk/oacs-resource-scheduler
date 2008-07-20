-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/publications-oacsmd-create.sql
--
-- Package for holding information directly related to publications.
--
-- @author nick@ucla.edu
-- @creation-date 2004-02-01
-- @cvs-id $Id: publication-oacsmd-create.sql,v 1.2 2007/01/26 02:02:30 andy Exp $
--

-- -----------------------------------------------------------------------------
-- --------------------------------- Publications ------------------------------
-- -----------------------------------------------------------------------------

declare
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ------------------------------------------------------
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'inst_publication',
		pretty_name		=> 'Publication',
		pretty_plural	=> 'publications',
		table_name		=> 'INST_PUBLICATIONS',
		id_column		=> 'PUBLICATION_ID'
	);

	-- create attributes -------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'TITLE',
		pretty_name		=> 'Title',
		pretty_plural	=> 'Titles',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBLICATION_NAME',
		pretty_name		=> 'Publication Name',
		pretty_plural	=> 'Publication Names',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'URL',
		pretty_name		=> 'URL',
		pretty_plural	=> 'URLS',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'AUTHORS',
		pretty_name		=> 'Author',
		pretty_plural	=> 'Authors',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'VOLUME',
		pretty_name		=> 'Volume',
		pretty_plural	=> 'Volumes',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'ISSUE',
		pretty_name		=> 'Issue',
		pretty_plural	=> 'Issues',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PAGE_RANGES',
		pretty_name		=> 'Page Range',
		pretty_plural	=> 'Page Ranges',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'YEAR',
		pretty_name		=> 'Year',
		pretty_plural	=> 'Years',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBLISH_DATE',
		pretty_name		=> 'Publish Date',
		pretty_plural	=> 'Publish Dates',
		datatype		=> 'date'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBLICATION',
		pretty_name		=> 'Publication',
		pretty_plural	=> 'Publications',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBLISHER',
		pretty_name		=> 'Publisher',
		pretty_plural	=> 'Publisher',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBLICATION_TYPE',
		pretty_name		=> 'Publication Type',
		pretty_plural	=> 'Publication Types',
		datatype		=> 'text'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PRIORITY_NUMBER',
		pretty_name		=> 'Priority Number',
		pretty_plural	=> 'Priority Numbers',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBMED_ID',
		pretty_name		=> 'Pubmed ID',
		pretty_plural	=> 'Pubmed ID',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_publication',
		attribute_name	=> 'PUBMED_XML',
		pretty_name		=> 'Pubmed XML',
		pretty_plural	=> 'Pubmed XML',
		datatype		=> 'text'
	);
	

end;
/
show errors;
