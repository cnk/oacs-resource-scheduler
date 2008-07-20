-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/group-drop.sql
--
-- Drop Script for the groups part of the institution package
--
-- @author helsleya@cs.ucr.edu (AH)
-- @author avni@avni.net (AK)
-- @author buddy@ucla.edu (RD)
--
-- @creation-date 07/20/2003
-- @cvs-id $Id: group-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

declare
	gid integer;
begin
	for g in (select group_id from inst_groups) loop
		begin
			inst_group.delete(g.group_id);
			exception when others then null;
		end;
	end loop;
end;
/
show errors;

drop package inst_group;
drop table inst_groups;
drop view vw_group_component_map;
exec acs_object_type.drop_type('inst_group');