<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="phones">
	 <querytext>
		select	distinct p.phone_id,
				nvl(p.description, '<i>(None)</i>')	as description,
				p.phone_number,
				p.phone_priority_number,
				decode(acs_permission.permission_p(p.phone_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(p.phone_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(p.phone_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(p.phone_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(p.phone_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_party_phones	p
		 where	phone_id			in ($items)
		   and	acs_permission.permission_p(p.phone_id, :user_id, 'read') = 't'
		 order	by phone_priority_number
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
