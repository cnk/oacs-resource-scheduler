<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="group">
	 <querytext>
		select	ig.*,
				g.*,
				p.*,
				pg.short_name	as parent_group_name,
				c.name			as group_type_name,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_groups	ig,
				inst_groups	pg,
				groups		g,
				parties		p,
				categories	c
		 where	ig.group_id			= g.group_id
		   and	ig.group_id			= p.party_id
		   and	ig.group_id			= :group_id
		   and	ig.parent_group_id	= pg.group_id(+)
		   and	ig.group_type_id	= c.category_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="direct_subgroups_of">
	 <querytext>
		select	group_id
		  from	inst_groups
		 where	parent_group_id = :group_id
		   and	acs_permission.permission_p(group_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<fullquery name="touch_package_mtime">
	 <querytext>
		update	acs_objects
		   set	last_modified	= sysdate,
				modifying_user	= :user_id,
				modifying_ip	= :peer_ip
		 where	object_id		= :package_id
	 </querytext>
	</fullquery>

	<fullquery name="group_rels">
	 <querytext>
		select	rel_id
		  from	acs_rels
		 where	object_id_one = :group_id
			or	object_id_two = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="acs_rels_delete">
	 <querytext>
		begin
			for r in (select	rel_id
						from	acs_rels
					   where	:group_id in (object_id_one,object_id_two)) loop

				-- remove the titles associated with the rel (IF ANY)
				for t in (select	gpm.gpm_title_id
							from	inst_group_personnel_map gpm
						   where	acs_rel_id = r.rel_id) loop
					inst_title.delete(t.gpm_title_id);
				end loop;

				-- remove the rel
				acs_rel.delete(r.rel_id);
			end loop;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="jccc_group_delete">
	 <querytext>
		delete from jccc_groups
		 where group_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_delete">
	 <querytext>
		begin
			inst_group.delete(:group_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
