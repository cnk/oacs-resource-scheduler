<?xml version="1.0"?>
<queryset>
	<fullquery name="inst_permissions::admin_p.inst_admin_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
			(select	1
			   from	acs_object_party_privilege_map
			  where	party_id = :user_id
				and	privilege = 'admin'
				and	(exists (select 1 from inst_personnel where personnel_id = object_id)		or
					 exists (select 1 from inst_groups where group_id = object_id)			or
					 exists (select 1 from inst_publications where publication_id = object_id)	or
					 exists (select 1 from inst_certifications where certification_id = object_id)	)
			 )
	 </querytext>
	</fullquery>

	<fullquery name="inst_permissions::group_admin_p.inst_group_admin_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
			(select	1
			   from	acs_object_party_privilege_map
			  where	party_id = :user_id
				and	privilege = 'admin'
				and	exists (select 1 from inst_groups where group_id = object_id)
			)
	 </querytext>		
	</fullquery>
</queryset>
