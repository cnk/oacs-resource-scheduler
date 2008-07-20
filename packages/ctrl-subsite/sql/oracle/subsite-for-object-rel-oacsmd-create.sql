-- /packages/ctrl-subsite/sql/oracle/subsite-for-party-rel-oacsmd-create.sql
--
-- Package for relating subsites to objects
--
-- @author          avni@ctrl.ucla.edu (AK)
-- @creation-date   2007-03-12
-- @cvs-id          $Id$
--                                                                                                                                                                                                               
begin
    -- create role types -------------------------------------------------------                                                                                                                                 
    acs_rel_type.create_role('ctrl_subsite', 'Subsite', 'Subsites');
    acs_rel_type.create_role('ctrl_object', 'Object', 'Objects');

    -- create relationship type ------------------------------------------------                                                                                                                                 
    acs_rel_type.create_type(
        rel_type        => 'ctrl_subsite_for_object_rel',
        pretty_name     => 'Subsite For Object',
        pretty_plural   => 'Subsites For Object',
        table_name      => 'ctrl_subsite_for_object_rels',
        id_column       => 'rel_id',
        package_name    => 'ctrl_subsite_for_object_rel',
        object_type_one => 'apm_package',
        role_one        => 'ctrl_subsite',
        min_n_rels_one  => 0,       
	max_n_rels_one  => null,
        object_type_two => 'acs_object',
        role_two        => 'ctrl_object',
        min_n_rels_two  => 0,      
	max_n_rels_two  => null
    );
end;
/
show errors;

