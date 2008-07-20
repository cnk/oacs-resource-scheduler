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
				e.description,
				e.email,
				acs_object.name(e.party_id)		as owner_name,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'read'),
						't', 1, 0)			as read_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'write'),
						't', 1, 0)			as write_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'create'),
						't', 1, 0)			as create_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'delete'),
						't', 1, 0)			as delete_p,
				decode(acs_permission.permission_p(e.email_id, :user_id, 'admin'),
						't', 1, 0)			as admin_p
		  from	inst_party_emails	e
		 where	e.email_id	= :email_id
	 </querytext>
	</fullquery>

	<fullquery name="email_name">
	 <querytext>
		select description
		  from inst_party_emails
		 where email_id = :email_id
	 </querytext>
	</fullquery>

	<fullquery name="email_new">
	 <querytext>
		begin
			:1 := inst_party_email.new(
				owner_id			=> :party_id,
				type_id				=> :email_type_id,
				description			=> :description,
				email				=> :email,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="email_edit">
	 <querytext>
		update	inst_party_emails
		   set	party_id			= :party_id,
				email_type_id		= :email_type_id,
				description			= :description,
				email				= :email
		 where	email_id			= :email_id
	 </querytext>
	</fullquery>


	<fullquery name="modified">
	 <querytext>
		update	acs_objects
		   set	last_modified	= sysdate,
				modifying_user	= :user_id,
				modifying_ip	= :peer_ip
		 where	object_id		= :email_id
	 </querytext>
	</fullquery>

	<fullquery name="email_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		start	with parent_category_id = category.lookup('//Contact Information//Email')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
