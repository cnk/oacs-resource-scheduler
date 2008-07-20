-- -*- tab-width: 4 -*-
--
-- /packages/institution/sql/oracle/title-create.sql
--
-- Data model for the personnel titles
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @author			avni@avni.net (AK)
-- @creation-date	2005-02-16
-- @cvs-id			$Id: title-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- The acs_rels (object to object mapping) table will store the mapping between groups (orgs,depts,divisions,cp) and personnel table
-- This will be a membership relationship.
-- The inst_group_personnel_map table exists to store the position, start_date, and end_date of the personnel within the group
create table inst_group_personnel_map (
	gpm_title_id			integer
		constraint			inst_gpm_gpm_title_id_pk primary key,
		constraint			inst_gpm_gpm_title_id_fk foreign key (gpm_title_id) references acs_objects(object_id),
	acs_rel_id				integer,
		constraint			inst_gpm_acs_rel_id_fk foreign key(acs_rel_id) references acs_rels(rel_id),
	title_id				integer,
		constraint			inst_gpm_title_id_fk foreign key(title_id) references categories(category_id),
	status_id				integer,
		constraint			inst_gpm_status_id_fk foreign key(status_id) references categories(category_id),
	pretty_title			varchar2(1000),
	start_date				date		default sysdate,
	end_date				date,
	leader_p				char(1) default 'f'
		constraint			inst_gpm_leader_p_ck check (leader_p in ('t','f')),
	title_priority_number	integer,
	constraint inst_gpm_un unique (title_id, acs_rel_id)
);

create index inst_gpm_acs_rel_id_idx on inst_group_personnel_map(acs_rel_id);
create index inst_gpm_title_id_idx on inst_group_personnel_map(title_id);

-- -----------------------------------------------------------------------------
-- This maintains the field in inst_personnel that is an aggregate of all of the
-- degree certifications of all personnel
-- -----------------------------------------------------------------------------
/*
create or replace trigger inst_phys_accptng_ptnts_updt
after update on inst_group_personnel_map
begin
	null;
end;
/
show errors;

create or replace trigger inst_phys_accptng_ptnts_ins_del
after insert or delete on inst_group_personnel_map
begin
	null;
end;
/
show errors;

//TODO// incorporate these into the triggers above
update	inst_physicians phys
   set	accepting_patients_p = 't'
 where	(accepting_patients_p = 'f'
	or	accepting_patients_p is null)
   and	exists
		(select	1
		   from	inst_group_personnel_map	gpm,
				acs_rels					rel
		  where	gpm.acs_rel_id = rel.rel_id
			and	rel.object_id_two	= phys.physician_id
			and	status_id			is not null)
--------------------------------------------------------------------------------
update	inst_physicians phys
   set	accepting_patients_p = 'f'
 where	(accepting_patients_p = 't'
	or	accepting_patients_p is null)
   and	not exists
		(select	1
		   from	inst_group_personnel_map	gpm,
				acs_rels					rel
		  where	gpm.acs_rel_id = rel.rel_id
			and	rel.object_id_two	= phys.physician_id
			and	status_id			is not null)
*/

