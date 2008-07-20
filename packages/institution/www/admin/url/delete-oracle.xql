<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="url">
	 <querytext>
		select	u.url_id,
				u.party_id,
				u.url_type_id,
				c.name						as url_type_name,
				u.description,
				u.url,
				acs_object.name(u.party_id)	as owner_name,
				decode(acs_permission.permission_p(u.url_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(u.url_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(u.url_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(u.url_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(u.url_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_party_urls	u,
				categories				c
		 where	u.url_id		= :url_id
		   and	u.url_type_id	= c.category_id
	 </querytext>
	</fullquery>

	<fullquery name="url_delete">
	 <querytext>
		begin
			inst_party_url.delete(:url_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
