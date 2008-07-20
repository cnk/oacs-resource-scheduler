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
				u.description,
				u.url,
				acs_object.name(u.party_id) as owner_name,
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
		  from	inst_party_urls u
		 where	u.url_id = :url_id
	 </querytext>
	</fullquery>

	<fullquery name="url_name">
	 <querytext>
		select description
		  from inst_party_urls
		 where url_id = :url_id
	 </querytext>
	</fullquery>

	<fullquery name="url_new">
	 <querytext>
		begin
			:1 := inst_party_url.new(
				owner_id			=> :party_id,
				type_id				=> :url_type_id,
				description			=> :description,
				url					=> :url,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="url_edit">
	 <querytext>
			update	inst_party_urls
			   set	party_id			= :party_id,
					url_type_id		= :url_type_id,
					description			= :description,
					url				= :url
			 where	url_id			= :url_id
	 </querytext>
	</fullquery>


	<fullquery name="modified">
	 <querytext>
			update	acs_objects
			   set	last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :url_id
	 </querytext>
	</fullquery>

	<fullquery name="url_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		start	with parent_category_id = category.lookup('//Contact Information//URL')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
