-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/group-create.sql
--
-- Data model for the groups part of the institution package
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @author buddy@ucla.edu (RD)
--
-- @creation-date 07/20/2003
-- @cvs-id $Id: group-create.sql,v 1.2 2007/03/02 23:56:52 andy Exp $
--

-- This table is used to categorize, name, and describe  groups of parties
-- within the institution package.
-- Possible group_types are organization, department, division, clinical_programs, etc..
-- The parent_group_id and depth attributes are used to speed up/make possible
-- queries that treat inst_groups as hierarchically structured data.

create table inst_groups (
	group_id				integer
		constraint			inst_grp_group_id_pk primary key,
		constraint			inst_grp_group_id_fk foreign key(group_id) references groups(group_id),
	parent_group_id			integer,
		constraint			inst_grp_parent_group_id_fk foreign key(parent_group_id) references groups(group_id),
	qdb_id					integer,
	depth					integer,
	group_type_id			integer			not null,
		constraint			inst_grp_group_type_id_fk foreign key(group_type_id) references categories(category_id),
	short_name				varchar2(300)	not null,
	description				clob,
	keywords				varchar2(4000),
	alias_for_group_id		integer,
		constraint			inst_grp_alias_group_id_fk foreign key(alias_for_group_id) references inst_groups(group_id),
	group_priority_number	integer,	
	constraint inst_grp_shrt_nm_prnt_un unique (parent_group_id, short_name)
);

-- These views are identical to standard OACS views except they use the standard
-- graph/tree terminology.
create or replace view vw_group_element_map as
select	rel_id,
		group_id		as ancestor_id,		--		<--- indirect element of this group (still might be a direct element though)
		container_id	as parent_id,		--		<--- direct element of this group
		element_id		as child_id			--		<--- the element (a party)
  from	group_element_map;

create or replace view vw_group_component_map as
select	rel_id,
		group_id		as ancestor_id,		--		<--- indirect component of this group (still might be a direct component though)
		container_id	as parent_id,		--		<--- direct component of this group
		element_id		as child_id			--		<--- the component (a group)
  from	group_element_map
 where	ancestor_rel_type = 'composition_rel';

create or replace view vw_group_member_map as
select	rel_id,
		group_id		as ancestor_id,		--		<--- indirect member of this group (still might be a direct member though)
		container_id	as parent_id,		--		<--- direct member of this group
		element_id		as child_id			--		<--- the member (a person)
  from	group_element_map
 where	ancestor_rel_type = 'membership_rel';
