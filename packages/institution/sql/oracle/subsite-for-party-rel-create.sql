-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/subsite-for-party-rel-create.sql
--
-- Package for relating subsites to parties that they are for
-- (though they are not necessarily administrated by those parties)
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-09-15
-- @cvs-id			$Id: subsite-for-party-rel-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_subsite_for_party_rels (
	rel_id
		constraint		inst_ssite_for_party_rel_id_fk references acs_rels(rel_id)
		constraint		inst_ssite_for_party_rel_id_pk primary key
);

-- This trigger will update inst_personnel when a certain status is applied to
-- any of a personnel's titles
create or replace trigger inst_grp_prsnnl_map_status_tr
	after insert or update of status_id on inst_group_personnel_map
	referencing new as new old as old
	for each row when (new.status_id <> old.status_id)
declare
	v_group_id		integer	:= null;
	v_personnel_id	integer := null;
	v_deceased_id	integer := category.lookup('//Personnel Status//Deceased');
begin
	select	object_id_one,	object_id_two
	  into	v_group_id,		v_personnel_id
	  from	acs_rels	rel
	 where	rel.rel_id	= :new.acs_rel_id;

	for s in (select	category_id as status_id
				from	categories c
			   where	category_id	in
						(category.lookup('//Personnel Status//Deceased'),
						 category.lookup('//Personnel Status//Fired'),
						 category.lookup('//Personnel Status//Quit'),
						 category.lookup('//Personnel Status//Retired'))) loop
		if s.status_id in (:new.status_id, :old.status_id) then
			update	inst_personnel	ip
			   set	ip.status_id	= :new.status_id
			 where	ip.personnel_id	= v_personnel_id;
		end if;
	end loop;

	--	//TODO// ---------------------------------------------------------------
	--if :new.status_id = inactive and :old.status_id = active then
	--	null;
	--	get-or-create inactive_membership_rel
	--elsif :new.status_id = active and :old.status_id = inactive then
	--	null;
	--	get-or-create membership_rel
	--end if;

	--update	inst_group_personnel_map	gpm
	--   set	acs_rel_id		= v_new_rel_id
	-- where	gpm_title_id	= :new.gpm_title_id;

	--	if no rows use :old.acs_rel_id, drop the rel
end;
/


-- view invariants:
--	group_id and container_id are either group-ids or null
--	all parties for a subsite will have at least 1 row (even the roots)
--	roots can be identified by party_id in rows where:	ancestor_id	 = parent_id  = party_id
--	trunks can be identified by party_id in rows where:	ancestor_id	 = parent_id != party_id
--	others can be identified by party_id in rows where:	ancestor_id	!= parent_id != party_id
create view vw_subsite_parties as
select	sspr.object_id_one	as subsite_id,
		gem.rel_id,
		gem.group_id		as ancestor_id,
		gem.container_id	as parent_id,
		gem.element_id		as party_id,
		nvl((select	1
			   from	dual
			  where	exists	-- the person has a title the group (for now)
					(select	1
					   from	inst_group_personnel_map	gpm
					  where	rel.rel_id		= gpm.acs_rel_id
						and	gpm.start_date	< sysdate
						and	(gpm.end_date	is null
							or gpm.end_date	> sysdate)
						and	(gpm.status_id	is null
							or gpm.status_id	not in
							(category.lookup('//Personnel Status//Deceased'),
							 category.lookup('//Personnel Status//Fired'),
							 category.lookup('//Personnel Status//Inactive'),
							 category.lookup('//Personnel Status//On Leave'),
							 category.lookup('//Personnel Status//Quit'),
							 category.lookup('//Personnel Status//Retired')))
					)
				 and not exists	-- they are not marked deceased in _any_ title at _any_ time
					(select	1
					   from	inst_group_personnel_map	gpm
					  where	gpm.status_id	= category.lookup('//Personnel Status//Deceased')
					)
				 and not exists	-- they are not marked deceased in their personnel record
					(select	1
					   from	inst_personnel	psnl
					  where	psnl.status_id	= category.lookup('//Personnel Status//Deceased')
					)
			)
		, 1) as valid_title_exists_p
  from	group_element_map			gem,
		inst_subsite_for_party_rels	ssp,
		acs_rels					sspr,
		acs_rels					rel
 where	ssp.rel_id			= sspr.rel_id
   and	sspr.object_id_two	= gem.group_id
   and	gem.rel_id			= rel.rel_id
union all	-- select subsite root-groups (we dont put in subsite-root persons -- this seems unnecessary)
select	distinct
		sspr.object_id_one	as subsite_id,
		to_number(null)		as rel_id,
		gem.group_id		as ancestor_id,
		gem.container_id	as parent_id,
		gem.container_id	as party_id,
		0					as valid_title_exists_p
  from	group_element_map			gem,
		inst_subsite_for_party_rels	ssp,
		acs_rels					sspr
 where	gem.group_id		= gem.container_id
   and	ssp.rel_id			= sspr.rel_id
   and	sspr.object_id_two	= gem.group_id
;

-- view invariants:
--	group_id and container_id are either group-ids or null
--	all parties for a subsite will have at least 1 row (even the roots)
--	roots can be identified by party_id in rows where:	ancestor_id	 = parent_id  = party_id
--	trunks can be identified by party_id in rows where:	ancestor_id	 = parent_id  = party_id
--	others can be identified by party_id in rows where:	ancestor_id	!= parent_id != party_id
create or replace view vw_default_subsite_parties as
select	to_number(null)		as subsite_id,
		gem.rel_id			as rel_id,
		gem.group_id		as ancestor_id,
		gem.container_id	as parent_id,
		gem.element_id		as party_id,
		nvl((select	1
			   from	dual
			  where	exists	-- the person has a title the group (for now)
					(select	1
					   from	inst_group_personnel_map	gpm
					  where	rel.rel_id		= gpm.acs_rel_id
						and	gpm.start_date	< sysdate
						and	(gpm.end_date	is null
							or gpm.end_date	> sysdate)
						and	gpm.status_id	not in
							(category.lookup('//Personnel Status//Deceased'),
							 category.lookup('//Personnel Status//Fired'),
							 category.lookup('//Personnel Status//Inactive'),
							 category.lookup('//Personnel Status//On Leave'),
							 category.lookup('//Personnel Status//Quit'),
							 category.lookup('//Personnel Status//Retired'))
					)
				 and not exists	-- they are not marked deceased in _any_ title at _any_ time
					(select	1
					   from	inst_group_personnel_map	gpm
					  where	gpm.status_id	= category.lookup('//Personnel Status//Deceased')
					)
				 and not exists	-- they are not marked deceased in their personnel record
					(select	1
					   from	inst_personnel	psnl
					  where	psnl.status_id	= category.lookup('//Personnel Status//Deceased')
					)
			)
		, 1) as valid_title_exists_p
  from	group_element_map	gem,
		inst_groups			grp,
		acs_rels			rel
 where	gem.group_id		= grp.group_id
   and	gem.rel_id			= rel.rel_id
   and	grp.parent_group_id	is null
union all	-- select default subsite root-groups (we dont put in subsite-root persons -- this seems unnecessary)
select	to_number(null)		as subsite_id,
		gem.rel_id			as rel_id,
		gem.group_id		as ancestor_id,
		gem.container_id	as parent_id,
		gem.container_id	as party_id,
		0					as valid_title_exists_p
  from	group_element_map	gem,
		inst_groups			grp,
		acs_rels			rel
 where	gem.group_id		= gem.container_id
   and	gem.group_id		= grp.group_id
   and	gem.rel_id			= rel.rel_id
   and	grp.parent_group_id	is null
;

-- //TODO// account for default subsite:
--	the complicated part is making sure to include persons and still maintain the view invariants
--	roots == trunks for default subsite (though it violates the invariants)

col grp format a65
col prsn format a35
col ttl format a20
col stt format a20
select	object_id_one					as grp_id,
		acs_object.name(object_id_one)	as grp,
		object_id_two					as prsn_id,
		acs_object.name(object_id_two)	as prsn,
		acs_object.name(title_id)		as ttl,
		acs_object.name(status_id)		as stt,
		start_date,
		end_date
  from	inst_group_personnel_map,
		acs_rels
 where	acs_rel_id = rel_id
   and	status_id between 106190 and 106195;