-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/subsite-for-party-rel-oacsmd-create.sql
--
-- Package for relating subsites to parties that they are for
-- (though they are not necessarily administrated by those parties)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-06-14
-- @cvs-id			$Id: subsite-for-party-rel-oacsmd-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------- PERSON-PUBLICATION RELATIONSHIP ----------------------
-- -----------------------------------------------------------------------------

begin
	-- create role types -------------------------------------------------------
	acs_rel_type.create_role('subsite', 'Subsite', 'Subsites');
	acs_rel_type.create_role('party', 'Party', 'Parties');

	-- create relationship type ------------------------------------------------
	acs_rel_type.create_type(
		rel_type		=> 'subsite_for_party_rel',
		pretty_name		=> 'Subsite For Party',
		pretty_plural	=> 'Subsites For Party',
		table_name		=> 'inst_subsite_for_party_rels',
		id_column		=> 'rel_id',
		package_name	=> 'inst_subsite_for_party_rel',
		object_type_one	=> 'apm_package',
		role_one		=> 'subsite',
		min_n_rels_one	=> 0,		max_n_rels_one	=> null,
		object_type_two	=> 'party',
		role_two		=> 'party',
		min_n_rels_two	=> 0,		max_n_rels_two	=> null
	);
end;
/
show errors;
