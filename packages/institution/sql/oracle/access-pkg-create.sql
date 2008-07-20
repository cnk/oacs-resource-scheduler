-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/access-pkg-create.sql
--
-- Package for holding ACCESS personnel.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004-03-05
-- @cvs-id			$Id: access-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- ACCESS -----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package access_person
as
	procedure set_affinity_group_id (
		personnel_id		in access_personnel.personnel_id%TYPE,
		affinity_group_id	in access_personnel.affinity_group_id%TYPE
	);
end access_person;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body access_person
as
	procedure set_affinity_group_id (
		personnel_id		in access_personnel.personnel_id%TYPE,
		affinity_group_id	in access_personnel.affinity_group_id%TYPE
	) is
		new_membership_group_id		integer := :affinity_group_id;
		new_rel_id					integer := null;
		old_membership_group_id		integer := null;
		old_rel_id					integer := null;
	begin
		select	parent_id, rel_id into old_membership_group_id, old_rel_id
		  from	vw_group_member_map	gmm,
				acs_rels			rel
		 where	gmm.ancestor_id		= inst_group.lookup('//ACCESS//ACCESS Research Affinity Groups')
		   and	gmm.child_id		= personnel_id
		   and	gmm.rel_id			= rel.rel_id
		   and	rel.object_id_one	= gmm.parent_id
		   and	rel.object_id_two	= personnel_id
		   and	rel.rel_type		= 'membership_rel';

		if new_membership_group_id <> old_membership_group_id then
			if old_membership_group_id is not null then
				-- delete old membership
				membership_rel.delete(old_rel_id);
			end if;

			if new_membership_group_id is not null then
				-- create new membership
				new_rel_id := membership_rel.new(
					object_id_one	=> new_membership_group_id,
					object_id_two	=> personnel_id
				);
			end if;
		end if;
	end set_affinity_group_id;
end access_person;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
