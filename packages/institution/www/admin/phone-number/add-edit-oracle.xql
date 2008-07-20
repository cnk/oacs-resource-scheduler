<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="phone">
	 <querytext>
		select	p.phone_id,
				p.party_id,
				p.phone_type_id,
				p.description,
				p.phone_number,
				p.phone_priority_number,
				acs_object.name(p.party_id) as owner_name,
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
		  from	inst_party_phones p
		 where	p.phone_id = :phone_id
	 </querytext>
	</fullquery>

	<fullquery name="phone_name">
	 <querytext>
		select description
		  from inst_party_phones
		 where phone_id = :phone_id
	 </querytext>
	</fullquery>

	<fullquery name="phone_new">
	 <querytext>
		begin
			:1 := inst_party_phone.new(
				owner_id			=> :party_id,
				type_id				=> :phone_type_id,
				description			=> :description,
				phone_number		=> :phone_number,
				priority_number		=> :phone_priority_number,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="phone_edit">
	 <querytext>
			update	inst_party_phones
			   set	party_id				= :party_id,
					phone_type_id			= :phone_type_id,
					description				= :description,
					phone_number			= :phone_number,
					phone_priority_number	= :phone_priority_number
			 where	phone_id				= :phone_id
	 </querytext>
	</fullquery>


	<fullquery name="modified">
	 <querytext>
			update	acs_objects
			   set	last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :phone_id
	 </querytext>
	</fullquery>

	<fullquery name="phone_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		start	with parent_category_id = category.lookup('//Contact Information//Phone')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
