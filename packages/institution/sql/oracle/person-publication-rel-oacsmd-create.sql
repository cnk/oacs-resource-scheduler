-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/publication-map-oacsmd-create.sql
--
-- Package for relating persons to the publications they created/own.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-10-11
-- @cvs-id			$Id: person-publication-rel-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------- PERSON-PUBLICATION RELATIONSHIP ----------------------
-- -----------------------------------------------------------------------------

begin
	-- create role types -------------------------------------------------------
	acs_rel_type.create_role('person', 'Person', 'Persons');
	acs_rel_type.create_role('publication', 'Publication', 'Publications');

	-- create relationship type ------------------------------------------------
	acs_rel_type.create_type(
		rel_type		=> 'inst_person_publication_rel',
		pretty_name		=> 'Publication for Person',
		pretty_plural	=> 'Publications for Person',
		table_name		=> 'inst_person_publication_rels',
		id_column		=> 'rel_id',
		package_name	=> 'inst_person_publication_rel',
		object_type_one	=> 'inst_publication',
		role_one		=> 'publication',
		min_n_rels_one	=> 0,		max_n_rels_one	=> null,
		object_type_two	=> 'person',
		role_two		=> 'person',
		min_n_rels_two	=> 0,		max_n_rels_two	=> null
	);
end;
/
show errors;
