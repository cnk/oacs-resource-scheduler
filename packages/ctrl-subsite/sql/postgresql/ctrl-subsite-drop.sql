--
-- /packages/ctrl-subsite/sql/postgresql/subsite-for-object-rel-drop.sql
--
-- Drop script for dropping relation of subsites to objects
-- 
-- @author		avni@ctrl.ucla.edu (AK)
-- @creation-date	2007-03-09
-- @update-date		2008-08-02 (ported to postgres)
-- @cvs-id $Id$	
--

select drop_package('ctrl_subsite_for_object_rel');
drop view crs_subsite_resrc_map_vw;
drop table ctrl_subsite_for_object_rels;

create function inline_0 ()
returns integer as '
begin
	
	PERFORM acs_rel_type__drop_type(''ctrl_subsite_for_object_rel'',''f'');	

	begin
		-- these may fail if used by other relationship types:
		PERFORM acs_rel_type__drop_role(''ctrl_subsite'');
		PERFORM acs_rel_type__drop_role(''ctrl_object'');
	exception when dependent_objects_still_exist then
	
	end;
	
	return 0;	

end;' language 'plpgsql';

select inline_0();
drop function inline_0();




