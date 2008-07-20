-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/group-pkg-create.sql
--
-- Object package for Groups in the institution module.
--
-- @author			helsleya@cs.ucr.edu (AH)
--
-- @creation-date	2003/08/24
-- @cvs-id			$Id: group-pkg-create.sql,v 1.2 2007/03/02 23:56:52 andy Exp $
--

-- -----------------------------------------------------------------------------
-- ----------------------------------- GROUP -----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_group
as
	-- constructor --
	function new (
		group_id			in inst_groups.group_id%TYPE			default null,
		type_id				in categories.category_id%TYPE,
		name				in groups.group_name%TYPE,
		short_name			in inst_groups.short_name%TYPE			default null,
		description			in inst_groups.description%TYPE			default null,
		keywords			in inst_groups.keywords%TYPE			default null,

		parent_group_id		in inst_groups.parent_group_id%TYPE		default null,

		join_policy			in groups.join_policy%TYPE				default 'closed',
		email				in parties.email%TYPE					default null,
		url					in parties.url%TYPE						default null,

		object_type			in acs_objects.object_type%TYPE			default 'group',
		creation_date		in acs_objects.creation_date%TYPE		default sysdate,
		creation_user		in acs_objects.creation_user%TYPE		default null,
		creation_ip			in acs_objects.creation_ip%TYPE			default null,
		context_id			in acs_objects.context_id%TYPE			default null,

		qdb_id				in inst_groups.qdb_id%TYPE				default null,
		alias_for_group_id	in inst_groups.alias_for_group_id%TYPE  default null,
		group_priority_number in inst_groups.group_priority_number%TYPE default null
	) return inst_groups.group_id%TYPE;

	-- destructor --
	procedure delete (
		group_id			in inst_groups.group_id%TYPE
	);

	function lookup (
		path				in varchar2,
		root				in inst_groups.group_id%TYPE			default null
	) return inst_groups.group_id%TYPE;

	function pathto(
		v_group_id			in inst_groups.group_id%TYPE
	) return varchar2;

	procedure move (
		group_id			in inst_groups.group_id%TYPE,
		new_parent_group_id	in inst_groups.group_id%TYPE,
		user_id				in acs_objects.modifying_user%TYPE	default null,
		peer_ip				in acs_objects.modifying_ip%TYPE	default null
	);

	procedure move_subobjects (
		from_gid			in inst_groups.group_id%TYPE,
		to_gid				in inst_groups.group_id%TYPE,
		user_id				in acs_objects.modifying_user%TYPE	default null,
		peer_ip				in acs_objects.modifying_ip%TYPE	default null
	);
end inst_group;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_group
as
	-- constructor --
	function new (
		group_id			in inst_groups.group_id%TYPE			default null,
		type_id				in categories.category_id%TYPE,
		name				in groups.group_name%TYPE,
		short_name			in inst_groups.short_name%TYPE			default null,
		description			in inst_groups.description%TYPE			default null,
		keywords			in inst_groups.keywords%TYPE			default null,

		parent_group_id		in inst_groups.parent_group_id%TYPE		default null,

		join_policy			in groups.join_policy%TYPE				default 'closed',
		email				in parties.email%TYPE					default null,
		url					in parties.url%TYPE						default null,

		object_type			in acs_objects.object_type%TYPE			default 'group',
		creation_date		in acs_objects.creation_date%TYPE		default sysdate,
		creation_user		in acs_objects.creation_user%TYPE		default null,
		creation_ip			in acs_objects.creation_ip%TYPE			default null,
		context_id			in acs_objects.context_id%TYPE			default null,

		qdb_id				in inst_groups.qdb_id%TYPE				default null,
		alias_for_group_id	in inst_groups.alias_for_group_id%TYPE  default null,
		group_priority_number in inst_groups.group_priority_number%TYPE default null
	) return inst_groups.group_id%TYPE
	is
		v_group_id			integer := group_id;
		v_short_name		inst_groups.short_name%TYPE := short_name;
		v_parent_depth		integer;
		v_composition_rel	integer;
		v_context_id		integer;
	begin
		if parent_group_id is not null then
			select depth into v_parent_depth
			  from inst_groups
			 where group_id = inst_group.new.parent_group_id;
		else
			v_parent_depth := 0;
		end if;

		v_context_id := nvl(context_id, parent_group_id);

		v_group_id := acs_group.new (
			group_id		=> v_group_id,
			group_name		=> name,
			join_policy		=> join_policy,
			email			=> email,
			url				=> url,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> v_context_id
		);

		if v_short_name is null then v_short_name := name; end if;

		-- create acs_rel to parent group
		if parent_group_id is not null then
			v_composition_rel := composition_rel.new(
				object_id_one => parent_group_id,
				object_id_two => v_group_id
			);
		end if;

		insert into inst_groups (
				group_id,
				group_type_id,
				short_name,
				description,
				keywords,
				qdb_id,
				alias_for_group_id,
				parent_group_id,	-- //TODO//remove this workaround
				depth,				-- //TODO//remove this workaround
				group_priority_number
			) values (
				v_group_id,
				type_id,
				v_short_name,
				description,
				keywords,
				qdb_id,
				alias_for_group_id,
				parent_group_id,
				v_parent_depth + 1,
				group_priority_number
		);

		return v_group_id;
	end new;

	-- destructor --
	procedure delete (
		group_id			in inst_groups.group_id%TYPE
	) is
	begin
		-- inst_certifications
		for c in (select certification_id from inst_certifications where party_id = inst_group.delete.group_id) loop
			inst_certification.delete(c.certification_id);
		end loop;

		-- inst_party_emails
		for e in (select email_id from inst_party_emails where party_id = inst_group.delete.group_id) loop
			inst_party_email.delete(e.email_id);
		end loop;

		-- inst_party_urls
		for u in (select url_id from inst_party_urls where party_id = inst_group.delete.group_id) loop
			inst_party_url.delete(u.url_id);
		end loop;

		-- inst_party_addresses
		for a in (select address_id from inst_party_addresses where party_id = inst_group.delete.group_id) loop
			inst_party_address.delete(a.address_id);
		end loop;

		-- inst_party_phones
		for p in (select phone_id from inst_party_phones where party_id = inst_group.delete.group_id) loop
			inst_party_phone.delete(p.phone_id);
		end loop;

		-- Images
		for i in (select image_id
					from inst_party_images
				   where party_id = inst_group.delete.group_id) loop
			inst_party_image.delete(i.image_id);
		end loop;

		-- delete inst_party_category_map
		delete from inst_party_category_map
		 where party_id = inst_group.delete.group_id;

		-- inst_group_personnel_map/titles
		for t in (select	gpm_title_id
					from	inst_group_personnel_map	gpm,
							acs_rels					r
				   where	gpm.acs_rel_id	= r.rel_id
					 and	inst_group.delete.group_id in
								(r.object_id_one, r.object_id_two)) loop
			inst_title.delete(t.gpm_title_id);
		end loop;

		delete from group_element_index
		 where		inst_group.delete.group_id in (group_id, element_id, container_id);

		delete from party_approved_member_map
		 where		inst_group.delete.group_id in (party_id, member_id);

		for r in (select rel_id
					from acs_rels
				   where inst_group.delete.group_id in (object_id_one, object_id_two)) loop
			acs_rel.delete(r.rel_id);
		end loop;

		for o in (select object_id
					from acs_objects
				   where context_id = inst_group.delete.group_id) loop
			acs_object.delete(o.object_id);
		end loop;

		for g in (select group_id, parent_group_id
					from inst_groups
				  connect by prior group_id = parent_group_id
				  start with group_id = inst_group.delete.group_id
				   order by level desc) loop

			delete	from inst_groups
			 where	group_id = g.group_id;

			for r in (select	rel_id
						from	acs_rels
					   where	object_id_one	= g.parent_group_id
						 and	object_id_two	= g.group_id) loop
				acs_rel.delete(r.rel_id);
			end loop;

			acs_object.delete(g.group_id);
		end loop;
	end delete;

	function lookup (
		path				in varchar2,
		root				in inst_groups.group_id%TYPE			default null
	) return inst_groups.group_id%TYPE
	is
		ppos		integer						:= 1;
		next		integer						:= 1;
		nname		inst_groups.short_name%TYPE	:= '';
		found_id	inst_groups.group_id%TYPE	:= root;
	begin
		while next > 0 loop
			-- find end of name of subgroup
			next	:= instr(path, '//', ppos);

			-- extract name of subgroup
			if next <= 0 then
				nname := substr(path, ppos);
			else
				nname := substr(path, ppos, next - ppos);
			end if;

			-- only look for a subgroup if there is a name to look for
			if length(nname) > 0 then
				-- if next <= 0 then this is _not_ the 'tail' component
				begin
					-- get the group that has found_id as parent and nname as its name
					select	group_id into found_id
					  from	inst_groups
					 where	short_name					= nname
					   and	nvl(parent_group_id, -1)	= nvl(found_id, -1);
					exception when no_data_found then
						found_id := null;
				end;
				exit when found_id is null;
--DBG			dbms_output.put_line('"' || nname || '" <--> "' || found_id || '"');
			end if;

			ppos	:= next + 2;
		end loop;

		return found_id;
	end lookup;


	function pathto(
		v_group_id			in inst_groups.group_id%TYPE
	) return varchar2
	is
		path		varchar2(4000) := null;
	begin
		for g in (select	short_name
					from	inst_groups
				  connect	by prior parent_group_id = group_id
					start	with group_id = v_group_id
					order	by level desc) loop
			path := path || '//' || g.short_name;
		end loop;
		return path;
	end pathto;

	procedure move (
		group_id			in inst_groups.group_id%TYPE,
		new_parent_group_id	in inst_groups.group_id%TYPE,
		user_id				in acs_objects.modifying_user%TYPE	default null,
		peer_ip				in acs_objects.modifying_ip%TYPE	default null
	) is
		old_parent_group_id integer;
		new_rel_id			integer;
		new_depth			integer;
	begin
		-- get the id of the old parent group
		select	g.parent_group_id into old_parent_group_id
		  from	inst_groups g
		 where	g.group_id = inst_group.move.group_id;

		if	new_parent_group_id <> old_parent_group_id or
			(old_parent_group_id is null and new_parent_group_id is not null) or
			(old_parent_group_id is not null and new_parent_group_id is null) then

			-- drop, create composition_rel's
			if old_parent_group_id is not null then
				for r in (select	rel_id
							from	acs_rels
						   where	object_id_one	= old_parent_group_id
							 and	object_id_two	= group_id
							 and	rel_type		= 'composition_rel') loop
					composition_rel.delete(r.rel_id);
				end loop;
			end if;

			if new_parent_group_id is not null then
				new_rel_id := composition_rel.new (
					object_id_one	=> new_parent_group_id,
					object_id_two	=> group_id,
					creation_user	=> user_id,
					creation_ip		=> peer_ip
				);
			end if;

			-- update parent_group_id, depth
			begin
				select	g.depth+1 into new_depth
				  from	inst_groups g
				 where	group_id = new_parent_group_id;
				exception when no_data_found then
					new_depth := 0;
			end;

			update	inst_groups
			   set	parent_group_id	= new_parent_group_id,
					depth			= new_depth
			 where	group_id = inst_group.move.group_id;

			-- update OACS object metadata
			update	acs_objects
			   set	context_id		= new_parent_group_id,
					modifying_user	= user_id,
					modifying_ip	= peer_ip,
					last_modified	= sysdate
			 where	object_id		= group_id;
		end if;
	end move;

	procedure move_subobjects (
		from_gid			in inst_groups.group_id%TYPE,
		to_gid				in inst_groups.group_id%TYPE,
		--//TODO// add predicates to control which kinds of objects to copy
		user_id				in acs_objects.modifying_user%TYPE	default null,
		peer_ip				in acs_objects.modifying_ip%TYPE	default null
	) is
		personnel_p	boolean := TRUE;
		groups_p	boolean := TRUE;
		new_rel_id	integer;
	begin
		if from_gid = to_gid then
			return;
		end if;

		-- copy in personnel
		if personnel_p then
			for r in (select	rel_id,
								object_id_two	as personnel_id
						from	acs_rels
					   where	object_id_one	= from_gid
						 and	rel_type		= 'membership_rel') loop

				-- Delete the old membership rel
				delete	from	inst_group_personnel_map
					   where	acs_rel_id		= r.rel_id;
				acs_rel.delete(r.rel_id);

				-- Make a new one if need be
				begin
					select	rel_id	into new_rel_id
					  from	acs_rels
					 where	object_id_one	= to_gid
					   and	object_id_two	= r.personnel_id
					   and	rel_type		= 'membership_rel';
					exception when no_data_found then
					new_rel_id := membership_rel.new(
						object_id_one	=> to_gid,
						object_id_two	=> r.personnel_id,
						creation_user	=> user_id,
						creation_ip		=> peer_ip
					);
				end;
			end loop;
		end if;

		-- copy in sub-groups
		if groups_p then
			for r in (select	object_id_two	as subgroup_id
						from	acs_rels
					   where	object_id_one	= from_gid
						 and	rel_type		= 'composition_rel') loop
				inst_group.move(
					group_id			=> r.subgroup_id,
					new_parent_group_id	=> to_gid,
					user_id				=> user_id,
					peer_ip				=> peer_ip
				);
			end loop;
		end if;

		-- //TODO// more?

		-- update OACS object metadata
		update	acs_objects
		   set	modifying_user	= user_id,
				modifying_ip	= peer_ip,
				last_modified	= sysdate
		 where	object_id		= from_gid
			or	object_id		= to_gid;
	end move_subobjects;
end inst_group;
/
show errors;
