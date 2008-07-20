<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="party">
	 <querytext>
		select	acs_object.name(:party_id) as owner_name,
				decode(acs_permission.permission_p(:party_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(:party_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(:party_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(:party_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(:party_id, :user_id, 'admin'),
						't', 1, 0) admin_p,
				(select count(*)
				   from inst_party_phones p
				  where party_id = :party_id) as n_items
		  from	parties
		 where	party_id = :party_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="phones_of_party">
	 <querytext>
		select	phone_id
		  from	inst_party_phones
		 where	party_id = :party_id
		   and	acs_permission.permission_p(phone_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
