-- Fix improper acs_object.object_type for publications (used to be 'person')
exec acs_object_type.drop_type('inst_publications');

@../publication-oacsmd-create.sql
@../publication-pkg-create.sql

update acs_objects set object_type = 'inst_publication'
 where object_id in (select publication_id from inst_publications);

-- Add sensible defaults to PL/SQL package procs for certification objects
@../certification-pkg-create.sql

-- Make inst_person.delete remove any publications, mappings, and orphaned mappings:
@../personnel-pkg-create.sql

-- this was accidentally created due to a typo in the last release of 'required-categories-create.sql'
exec category.delete(category.lookup('//Personnel Status//Accepting Patients'));
@../required-categories-create.sql
