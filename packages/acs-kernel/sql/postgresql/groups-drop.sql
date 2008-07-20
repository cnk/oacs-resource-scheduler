-
-- packages/acs-kernel/sql/groups-drop.sql
--
-- @author rhs@mit.edu
-- @creation-date 2000-08-22
-- @cvs-id $Id: groups-drop.sql,v 1.2 2004-06-18 18:21:57 jeffd Exp $
--
\t
select drop_package('acs_group');
drop function group_contains_p(integer,integer,integer);
drop view group_distinct_member_map;
drop view group_approved_member_map;
drop view group_member_index;
drop view group_component_index;
drop view group_member_map;
drop view group_component_map;
drop view group_element_map;
drop table group_element_index;
drop table group_type_rels;
drop table group_rels;
drop table groups;
select drop_package('composition_rel');
select drop_package('membership_rel');
drop table composition_rels;
drop table membership_rels;
drop table group_types;
\t
