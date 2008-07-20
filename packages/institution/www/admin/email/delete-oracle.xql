<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="email">
	 <querytext>
		select	e.email_id,
				e.party_id,
				e.email_type_id,
				c.name									as email_type_name,
				e.description,
				e.email,
				acs_object.name(e.party_id)				as owner_name,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_party_emails		e,
				acs_objects				o,
				categories				c
		 where	e.email_id		= :email_id
		   and	e.email_id		= o.object_id
		   and	e.email_type_id	= c.category_id
	 </querytext>
	</fullquery>

	<fullquery name="email_delete">
	 <querytext>
		begin
			inst_party_email.delete(:email_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
