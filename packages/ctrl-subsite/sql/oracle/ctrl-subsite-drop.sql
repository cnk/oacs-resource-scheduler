--
-- /packages/ctrl-subsite/sql/oracle/subsite-for-object-rel-drop.sql
--
-- Drop script for dropping relation of subsites to objects
-- 
-- @author		avni@ctrl.ucla.edu (AK)
-- @creation-date	2007-03-09
-- @cvs-id $Id$	
--

drop view crs_subsite_resrc_map_vw;
drop package ctrl_subsite_for_object_rel;
drop table ctrl_subsite_for_object_rels;

begin 
	acs_rel_type.drop_type('ctrl_subsite_for_object_rel');
	
	begin
		-- these may fail if used by other relationship types:
		acs_rel_type.drop_role('ctrl_subsite');
		acs_rel_type.drop_role('ctrl_object');
		exception when others then null;
	end;
end;
/
show errors

