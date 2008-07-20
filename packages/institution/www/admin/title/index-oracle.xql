<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="personnel">
	 <querytext>
		select	acs_object.name(:personnel_id) as owner_name,
				decode(acs_permission.permission_p(:personnel_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(:personnel_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(:personnel_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(:personnel_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(:personnel_id, :user_id, 'admin'),
						't', 1, 0) admin_p,
				(select count(*)
				   from inst_group_personnel_map	igpm,
						acs_rels					r
				  where	igpm.acs_rel_id				= r.rel_id
					and	r.object_id_two				= :personnel_id) as n_items
		  from	inst_personnel
		 where	personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="titles_of_party">
	 <querytext>
		select	gpm0.gpm_title_id
		  from	inst_group_personnel_map	gpm0,
				acs_rels					r0
		 where	gpm0.acs_rel_id		= r0.rel_id
		   and	r0.object_id_two	= :personnel_id
		   and	acs_permission.permission_p(gpm0.gpm_title_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
