-- -*- tab-width: 4 -*-
--
-- packages/institution/sql/oracle/title-pkg-create.sql
--
-- Package for holding personnel-title information.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2005-02-16
-- @cvs-id			$Id: title-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ----------------------------------- TITLE -----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_title
as
	-- constructor --
	function new (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE	default null,
		acs_rel_id				in inst_group_personnel_map.acs_rel_id%TYPE,
		title_id				in inst_group_personnel_map.title_id%TYPE,
		status_id				in inst_group_personnel_map.status_id%TYPE		default null,
		pretty_title			in inst_group_personnel_map.pretty_title%TYPE	default null,
		start_date				in inst_group_personnel_map.start_date%TYPE		default sysdate,
		end_date				in inst_group_personnel_map.end_date%TYPE		default null,
		leader_p				in inst_group_personnel_map.leader_p%TYPE		default 'f',
		title_priority_number	in inst_group_personnel_map.title_priority_number%TYPE	default 0,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE	default 'inst_title',
		creation_date			in acs_objects.creation_date%TYPE		default sysdate,
		creation_user			in acs_objects.creation_user%TYPE		default null,
		creation_ip				in acs_objects.creation_ip%TYPE			default null,
		context_id				in acs_objects.context_id%TYPE			default null
	) return inst_group_personnel_map.gpm_title_id%TYPE;

	-- constructor --
	function new (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE	default null,
		group_id				in inst_groups.group_id%TYPE,
		personnel_id			in inst_personnel.personnel_id%TYPE,
		title_id				in inst_group_personnel_map.title_id%TYPE,
		status_id				in inst_group_personnel_map.status_id%TYPE		default null,
		pretty_title			in inst_group_personnel_map.pretty_title%TYPE	default null,
		start_date				in inst_group_personnel_map.start_date%TYPE		default sysdate,
		end_date				in inst_group_personnel_map.end_date%TYPE		default null,
		leader_p				in inst_group_personnel_map.leader_p%TYPE		default 'f',
		title_priority_number	in inst_group_personnel_map.title_priority_number%TYPE	default 0,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE	default 'inst_title',
		creation_date			in acs_objects.creation_date%TYPE		default sysdate,
		creation_user			in acs_objects.creation_user%TYPE		default null,
		creation_ip				in acs_objects.creation_ip%TYPE			default null,
		context_id				in acs_objects.context_id%TYPE			default null
	) return inst_group_personnel_map.gpm_title_id%TYPE;

	function is_valid_at (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE,
		date					in inst_group_personnel_map.start_date%TYPE
	) return inst_group_personnel_map.leader_p%TYPE;

	-- destructor --
	procedure delete (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE
	);
end inst_title;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_title
as
	----------------------------------------------------------------------------
	-- constructor --
	function new (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE	default null,
		acs_rel_id				in inst_group_personnel_map.acs_rel_id%TYPE,
		title_id				in inst_group_personnel_map.title_id%TYPE,
		status_id				in inst_group_personnel_map.status_id%TYPE		default null,
		pretty_title			in inst_group_personnel_map.pretty_title%TYPE	default null,
		start_date				in inst_group_personnel_map.start_date%TYPE		default sysdate,
		end_date				in inst_group_personnel_map.end_date%TYPE		default null,
		leader_p				in inst_group_personnel_map.leader_p%TYPE		default 'f',
		title_priority_number	in inst_group_personnel_map.title_priority_number%TYPE	default 0,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE	default 'inst_title',
		creation_date			in acs_objects.creation_date%TYPE		default sysdate,
		creation_user			in acs_objects.creation_user%TYPE		default null,
		creation_ip				in acs_objects.creation_ip%TYPE			default null,
		context_id				in acs_objects.context_id%TYPE			default null
	) return inst_group_personnel_map.gpm_title_id%TYPE
	is
		v_gpm_title_id	integer;
	begin
		v_gpm_title_id := acs_object.new(
			object_id		=> gpm_title_id,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		insert into inst_group_personnel_map (
				gpm_title_id,
				acs_rel_id,
				title_id,
				status_id,
				pretty_title,
				start_date,
				end_date,
				leader_p,
				title_priority_number
			) values (
				v_gpm_title_id,
				acs_rel_id,
				title_id,
				status_id,
				pretty_title,
				start_date,
				end_date,
				leader_p,
				title_priority_number
		);

		return v_gpm_title_id;
	end new;

	----------------------------------------------------------------------------
	-- constructor --
	function new (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE	default null,
		group_id				in inst_groups.group_id%TYPE,
		personnel_id			in inst_personnel.personnel_id%TYPE,
		title_id				in inst_group_personnel_map.title_id%TYPE,
		status_id				in inst_group_personnel_map.status_id%TYPE		default null,
		pretty_title			in inst_group_personnel_map.pretty_title%TYPE	default null,
		start_date				in inst_group_personnel_map.start_date%TYPE		default sysdate,
		end_date				in inst_group_personnel_map.end_date%TYPE		default null,
		leader_p				in inst_group_personnel_map.leader_p%TYPE		default 'f',
		title_priority_number	in inst_group_personnel_map.title_priority_number%TYPE	default 0,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE	default 'inst_title',
		creation_date			in acs_objects.creation_date%TYPE		default sysdate,
		creation_user			in acs_objects.creation_user%TYPE		default null,
		creation_ip				in acs_objects.creation_ip%TYPE			default null,
		context_id				in acs_objects.context_id%TYPE			default null
	) return inst_group_personnel_map.gpm_title_id%TYPE
	is
		v_acs_rel_id	integer;
		v_gpm_title_id	integer := null;
	begin
		begin
			select	r.rel_id into v_acs_rel_id
			  from	acs_rels		r
			 where	rel_type 		= 'membership_rel'
			   and	r.object_id_one	= group_id
			   and	r.object_id_two	= personnel_id;
			exception when no_data_found then
			begin
				v_acs_rel_id	:= membership_rel.new(
					object_id_one	=> group_id,
					object_id_two	=> personnel_id
				);
			end;
		end;

		return inst_title.new(
			gpm_title_id			=> gpm_title_id,
			acs_rel_id				=> v_acs_rel_id,
			title_id				=> title_id,
			status_id				=> status_id,
			pretty_title			=> pretty_title,
			start_date				=> start_date,
			end_date				=> end_date,
			leader_p				=> leader_p,
			title_priority_number	=> title_priority_number,
			object_type				=> object_type,
			creation_date			=> creation_date,
			creation_user			=> creation_user,
			creation_ip				=> creation_ip,
			context_id				=> context_id
		);
		return v_gpm_title_id;
	end new;

	----------------------------------------------------------------------------
	function is_valid_at (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE,
		date					in inst_group_personnel_map.start_date%TYPE
	) return inst_group_personnel_map.leader_p%TYPE
	is
		v_gpm_title_id	integer := gpm_title_id;
		result_p		inst_group_personnel_map.leader_p%TYPE;
	begin
		begin
			select	't' into result_p
			  from	inst_group_personnel_map gpm
			 where	gpm.gpm_title_id	= v_gpm_title_id
			   and	gpm.start_date		< date
			   and	(gpm.end_date		is null
					or gpm.end_date		> date);
		exception when no_data_found then
			result_p := 'f';
		end;
		return result_p;
	end is_valid_at;

	----------------------------------------------------------------------------
	-- destructor --
	procedure delete (
		gpm_title_id			in inst_group_personnel_map.gpm_title_id%TYPE
	) is
		v_rel_id		integer;
		n_acs_rel_refs	integer;
	begin
---		select	acs_rel_id into v_rel_id
---		  from	inst_group_personnel_map	gpm
---		 where	gpm.acs_rel_id = inst_title.delete.gpm_title_id;

		delete from inst_subsite_psnl_obj_lists
		 where object_id	= inst_title.delete.gpm_title_id;

		delete from inst_group_personnel_map
		 where gpm_title_id	= inst_title.delete.gpm_title_id;

		acs_object.delete(gpm_title_id);

---		select	count(*) into n_acs_rel_refs
---		  from	inst_group_personnel_map	gpm
---		 where	gpm.acs_rel_id = v_rel_id;

---		if n_acs_rel_refs = 0 then
---			membership_rel.delete(v_rel_id);
---		end if;
	end delete;
end inst_title;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
