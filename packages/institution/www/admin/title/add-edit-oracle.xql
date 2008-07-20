<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="title">
	 <querytext>
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				g.group_id,
				g.short_name							as group_name,
				gpm.title_id,
				ct.name									as title,
				gpm.pretty_title,
				nvl(gpm.pretty_title, ct.name)			as description,
				gpm.status_id,
				cs.name									as status,
				r.object_id_two							as personnel_id,
				person.name(r.object_id_two)			as owner_name,
				leader_p,
				start_date,
				end_date,
				title_priority_number,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read'),
						't', 1, 0)						as read_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'write'),
						't', 1, 0)						as write_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'create'),
						't', 1, 0)						as create_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'delete'),
						't', 1, 0)						as delete_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'admin'),
						't', 1, 0)						as admin_p
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				acs_objects					o,
				inst_groups					g,
				categories					ct,
				categories					cs,
				categories					gt
		 where	gpm.gpm_title_id			= :gpm_title_id
		   and	gpm.acs_rel_id				= r.rel_id
		   and	r.rel_id					= o.object_id
		   and	r.object_id_one				= g.group_id
		   and	g.group_type_id				= gt.category_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
	 </querytext>
	</fullquery>

	<fullquery name="email_name">
	 <querytext>
		select description
		  from inst_party_emails
		 where email_id = :email_id
	 </querytext>
	</fullquery>

	<fullquery name="title_new">
	 <querytext>
		declare
			acs_rel_id	integer;
		begin
			begin
				select  r.rel_id   into acs_rel_id
                  from  acs_rels    r,
                        membership_rels mr
                 where  r.rel_type      = 'membership_rel'
                   and  r.object_id_one = :group_id
                   and  r.object_id_two = :personnel_id
                   and  r.rel_id        = mr.rel_id;
                exception when no_data_found then
					acs_rel_id := membership_rel.new(
					object_id_one	=> :group_id,
					object_id_two	=> :personnel_id
					);
			end;

			:1 := inst_title.new(
				acs_rel_id				=> acs_rel_id,
				title_id				=> :title_id,
				status_id				=> :status_id,
				leader_p				=> nvl(:leader_p, 'f'),
				start_date				=> nvl(:start_date, sysdate),
				end_date				=> :end_date,
				title_priority_number	=> :title_priority_number,
				pretty_title			=> :pretty_title,
				context_id				=> acs_rel_id
			);
		end;
	 </querytext>
	</fullquery>

	<!-- //TODO// modify so that only titles with overlapping existence intervals
		will cause this to return true -->
	<fullquery name="title_exists_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	inst_group_personnel_map	gpm,
						acs_rels					r
				  where	gpm.acs_rel_id				= r.rel_id
					and	r.object_id_one				= :group_id
					and	r.object_id_two				= :personnel_id
					and	gpm.title_id				= :title_id
					and	gpm.gpm_title_id			<> nvl(:gpm_title_id,-1))
	 </querytext>
	</fullquery>

	<fullquery name="old_title_details">
	 <querytext>
		select	gpm.acs_rel_id				as old_rel_id,
				g.group_id					as old_group_id
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				inst_groups					g
		 where	gpm.gpm_title_id			= :gpm_title_id
		   and	gpm.acs_rel_id				= r.rel_id
		   and	r.object_id_one				= g.group_id
	 </querytext>
	</fullquery>

	<fullquery name="title_edit">
	 <querytext>
		declare
			old_group_id	integer;
			old_rel_id		integer;
			n_references	integer;
			new_rel_id		integer;
		begin
			-- Get old values and count number of times rel is used in a title
			select	distinct object_id_one,
					rel_id,
					count(*)
			  into	old_group_id,
					old_rel_id,
					n_references
			  from	inst_group_personnel_map	gpm,
					acs_rels					r
			 where	gpm.acs_rel_id		= r.rel_id
			   and	gpm.acs_rel_id		=
					(select	acs_rel_id
					   from	inst_group_personnel_map igpm
					  where	gpm_title_id	= :gpm_title_id)
			 group	by object_id_one, rel_id;

			-- Get (or create) the rel that should be used for the title
			if old_group_id <> :group_id then
				-- get or create new rel
				begin
					select	distinct r.rel_id	into new_rel_id
					  from	acs_rels	r
					 where	r.rel_type		= 'membership_rel'
					   and	r.object_id_one	= :group_id
					   and	r.object_id_two	= :personnel_id;
				exception when no_data_found then
					new_rel_id := membership_rel.new(
						object_id_one	=> :group_id,
						object_id_two	=> :personnel_id
					);
				end;
			else
				new_rel_id := old_rel_id;
			end if;

			-- The primary update of data occurs here
			update	inst_group_personnel_map
			   set	acs_rel_id				= new_rel_id,
					title_id				= :title_id,
					status_id				= :status_id,
					leader_p				= nvl(:leader_p, 'f'),
					start_date				= nvl(:start_date, sysdate),
					end_date				= :end_date,
					title_priority_number	= :title_priority_number,
					pretty_title			= :pretty_title
			 where	gpm_title_id			= :gpm_title_id;

			-- This must come before the membership-rel delete since the
			-- gpm_title is placed in the context of the rel, hence the rel
			-- cannot be deleted until the context of the gpm_title has been
			-- updated.
			update	acs_objects
			   set	context_id		= :group_id,
					last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :gpm_title_id;

			-- Delete the membership-rel if no more titles use it
			if old_group_id <> :group_id and n_references <= 1 then
				membership_rel.delete(old_rel_id);
			end if;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="modified">
	 <querytext>
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="title_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id,
				parent_category_id,
				name
		  from	categories
		 where	acs_permission.permission_p(category_id, :user_id, 'read') = 't'
		start	with parent_category_id	= category.lookup('//Personnel Title')
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="status_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		 where	acs_permission.permission_p(category_id, :user_id, 'read') = 't'
		start	with parent_category_id	= category.lookup('//Personnel Status')
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="groups">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || short_name as name,
				group_id,
				parent_group_id,
				short_name
		  from	inst_groups g
		 where	[subsite::parties_sql -root -groups -party_id {g.group_id}]
		   and	acs_permission.permission_p(g.group_id, :user_id, 'admin') = 't'
		connect	by prior group_id = parent_group_id
		 start	with [subsite::parties_sql -only -root -groups -party_id {g.group_id}]
	 </querytext>
	</fullquery>

	<fullquery name="group">
	 <querytext>
		select	group_id,
				short_name	as group_name
		  from	inst_groups	g
		 where	group_id	= :group_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
