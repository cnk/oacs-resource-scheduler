-- -*- tab-width: 4 -*- --
--
-- packages/ctrl-categories/sql/postgres/categories-oacsmd-create.sql
--
-- OpenACS MetaData for a simple category module (similar to the ACS 3.4.10
-- category module)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @author			cnk@caltech.edu (CNK) -- postgres port
-- @creation-date	2008-07-20
-- @cvs-id			$Id:$
--

-- Create an acs_object
select acs_object_type__create_type (
		'ctrl_category',
		'CTRL Category',
		'CTRL Categories',
		'acs_object',
		'ctrl_categories',
		'category_id',
		'ctrl_category.name',
        'f',
        null,
        null
);

begin;

-- Register the attributes
select acs_attribute__create_attribute (
		'ctrl_category',
		'name',
        'string',
		'Name',
		'Names',
        null,
        null,
        null,
        1,
        1,
        null,
        'type_specific',
        'f'
);

select acs_attribute__create_attribute (
		'ctrl_category',
		'plural',
        'string',
		'Plural',
		'Plurals',
        null,
        null,
        null,
        1,
        1,
        null,
        'type_specific',
        'f'
);

select acs_attribute__create_attribute (
		'ctrl_category',
		'description',
        'string',
		'Description',
		'Descriptions',
        null,
        null,
        null,
        1,
        1,
        null,
        'type_specific',
        'f'
);

select acs_attribute__create_attribute (
		'ctrl_category',
		'enabled_p',
        'integer',
		'Enabled?',
		'Enabled?',
        null,
        null,
        null,
        1,
        1,
        null,
        'type_specific',
        'f'
);

select acs_attribute__create_attribute (
		'ctrl_category',
		'profiling_weight',
        'integer',
		'Profiling Weight',
		'Profiling Weights',
        null,
        null,
        null,
        1,
        1,
        null,
        'type_specific',
        'f'
);

end;
