-- /packages/ctrl-subsite/sql/postgresql/subsite-for-party-rel-oacsmd-create.sql
--
-- Package for relating subsites to objects
--
-- @author          avni@ctrl.ucla.edu (AK)
-- @creation-date   2007-03-12
-- @update-date	    2008-07 (ported to postgres)
-- @cvs-id          $Id$
--   

create function inline_0 ()
returns integer as '
begin 	

    -- create role types -------------------------------------------------------                                                                                                                                 
    PERFORM acs_rel_type__create_role(''ctrl_subsite'', ''Subsite'', ''Subsites'');
    PERFORM acs_rel_type__create_role(''ctrl_object'', ''Object'', ''Objects'');

    -- create relationship type ------------------------------------------------                                                                                                                                 
    PERFORM acs_rel_type__create_type(
        ''ctrl_subsite_for_object_rel'', 	-- rel_type
        ''Subsite For Object'',	  		-- pretty_name
        ''Subsites For Object'',	  	-- pretty_plural
	''relationship'',			-- supertype
        ''ctrl_subsite_for_object_rels'',	-- table_name
        ''rel_id'',			  	-- id_column
        ''ctrl_subsite_for_object_rel'', 	-- package_name
        ''apm_package'',		  	-- object_type_one
        ''ctrl_subsite'',		  	-- role_one
        0,       			  	-- min_n_rels_one
	null,			  		-- max_n_rels_one
        ''acs_object'',		  		-- object_type_two
        ''ctrl_object'',		  	-- role_two
        0,      			  	-- min_n_rels_two
	null				  	-- max_n_rels_two
    	);

    return null;

end;' language 'plpgsql';

select inline_0();
drop function inline_0();

