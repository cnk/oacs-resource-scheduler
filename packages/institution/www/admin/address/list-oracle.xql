<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="addresses">
	 <querytext>
		select	distinct a.address_id,
				nvl(a.description, a.address_line_1)	as descriptive_display,
				a.description,
				decode(acs_permission.permission_p(address_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(address_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(address_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(address_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(address_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p
		  from	inst_party_addresses	a
		 where 	a.address_id in ($items)
		   and	acs_permission.permission_p(a.address_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
