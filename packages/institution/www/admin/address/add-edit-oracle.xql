<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="address">
	 <querytext>
		select	a.address_id,
				a.party_id,
				a.address_type_id,
				a.description,
				a.building_name,
				a.room_number,
				a.address_line_1,
				a.address_line_2,
				a.address_line_3,
				a.address_line_4,
				a.address_line_5,
				a.city,
				a.fips_state_code,
				a.zipcode,
				a.zipcode_ext,
				a.fips_country_code,
				acs_object.name(a.party_id) as owner_name,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_party_addresses a
		 where	a.address_id = :address_id
	 </querytext>
	</fullquery>

	<fullquery name="address_name">
	 <querytext>
		select description
		  from inst_party_addresses
		 where address_id = :address_id
	 </querytext>
	</fullquery>

	<fullquery name="address_new">
	 <querytext>
		begin
			:1 := inst_party_address.new(
				owner_id			=> :party_id,
				type_id				=> :address_type_id,
				description			=> :description,
				building_name		=> :building_name,
				room_number			=> :room_number,
				address_line_1		=> :address_line_1,
				address_line_2		=> :address_line_2,
				address_line_3		=> :address_line_3,
				address_line_4		=> :address_line_4,
				address_line_5		=> :address_line_5,
				city				=> :city,
				state_code			=> :fips_state_code,
				zipcode				=> :zipcode,
				zipcode_ext			=> :zipcode_ext,
				country_code		=> :fips_country_code,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="address_edit">
	 <querytext>
			update	inst_party_addresses
			   set	party_id			= :party_id,
					address_type_id		= :address_type_id,
					description			= :description,
					building_name		= :building_name,
					room_number			= :room_number,
					address_line_1		= :address_line_1,
					address_line_2		= :address_line_2,
					address_line_3		= :address_line_3,
					address_line_4		= :address_line_4,
					address_line_5		= :address_line_5,
					city				= :city,
					fips_state_code		= :fips_state_code,
					zipcode				= :zipcode,
					zipcode_ext			= :zipcode_ext,
					fips_country_code	= :fips_country_code
			 where	address_id			= :address_id
	 </querytext>
	</fullquery>


	<fullquery name="modified">
	 <querytext>
			update	acs_objects
			   set	last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :address_id
	 </querytext>
	</fullquery>

	<fullquery name="address_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		start	with parent_category_id = category.lookup('//Contact Information//Address')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>

	<fullquery name="states">
	 <querytext>
		select initcap(state_name), fips_state_code
		  from us_states
	 </querytext>
	</fullquery>

	<fullquery name="countries">
	 <querytext>
		select initcap(default_name), iso
		  from countries
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
