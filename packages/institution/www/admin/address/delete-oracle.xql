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
				c.name							as address_type_name,
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
				initcap(s.state_name)			as state_name,
				a.zipcode,
				a.zipcode_ext,
				a.fips_country_code,
				initcap(countries.default_name)	as country_name,
				acs_object.name(a.party_id)		as owner_name,
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
		  from	inst_party_addresses	a,
				categories				c,
				us_states				s,
				countries
		 where	a.address_id		= :address_id
		   and	a.address_type_id	= c.category_id
		   and	a.fips_state_code	= s.fips_state_code	(+)
		   and	a.fips_country_code	= countries.iso		(+)
	 </querytext>
	</fullquery>

	<fullquery name="address_delete">
	 <querytext>
		begin
			inst_party_address.delete(:address_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
