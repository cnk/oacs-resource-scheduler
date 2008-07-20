-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/sttp-oacsmd-create.sql
--
-- Package for holding short-term training program information.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004/10/25
-- @cvs-id			$Id: sttp-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ----------------------------------- STTP ------------------------------------
-- -----------------------------------------------------------------------------

@@sttp-create

declare
	attr_id				acs_attributes.attribute_id%TYPE;
begin
	-- create object type ------------------------------------------------------
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'inst_short_term_trnng_prog',
		pretty_name		=> 'Short Term Training Program',
		pretty_plural	=> 'Short Term Training Programs',
		table_name		=> 'INST_SHORT_TERM_TRNNG_PROGS',
		id_column		=> 'REQUEST_ID'
	);

	-- create attributes -------------------------------------------------------
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'N_GRADS_CURRENTLY_EMPLOYED',
		pretty_name		=> 'Number of Graduates Currenlty Employed',
		pretty_plural	=> 'Numbers of Graduates Currenlty Employed',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'N_REQUESTED',
		pretty_name		=> 'Number of Graduates Requested',
		pretty_plural	=> 'Numbers of Graduates Requested',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'N_RECEIVED',
		pretty_name		=> 'Number of Graduates Received',
		pretty_plural	=> 'Numbers of Graduates Received',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'LAST_MD_CANDIDATE',
		pretty_name		=> 'Last MD Candidate',
		pretty_plural	=> 'Last MD Candidates',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'LAST_MD_YEAR',
		pretty_name		=> 'Year of Last MD Candidate',
		pretty_plural	=> 'Years of Last MD Candidate',
		datatype		=> 'integer'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'ATTEND_POSTER_SESSION_P',
		pretty_name		=> 'Can Attend Poster Session',
		pretty_plural	=> 'Can Attend Poster Session',
		datatype		=> 'boolean'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'EXPERIENCE_REQUIRED_P',
		pretty_name		=> 'Is Research Experience Required',
		pretty_plural	=> 'Is Research Experience Required',
		datatype		=> 'boolean'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'SKILL_REQUIRED_P',
		pretty_name		=> 'Is a Skill Required',
		pretty_plural	=> 'Are Skills Required',
		datatype		=> 'boolean'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'SKILL',
		pretty_name		=> 'Skill',
		pretty_plural	=> 'Skills',
		datatype		=> 'boolean'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'inst_short_term_trnng_prog',
		attribute_name	=> 'DEPARTMENT_CHAIR_NAME',
		pretty_name		=> 'Name of Department Chair',
		pretty_plural	=> 'Names of Department Chairs',
		datatype		=> 'string'
	);
end;
/
show errors;

@@sttp-pkg-create
