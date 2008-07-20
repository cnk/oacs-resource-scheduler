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
				c.name									as address_type_name,
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
				initcap(s.state_name)					as state_name,
				a.zipcode,
				a.zipcode_ext,
				a.fips_country_code,
				initcap(countries.default_name)			as country_name,
				acs_object.name(a.party_id)				as owner_name,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(a.address_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_party_addresses	a,
				categories				c,
				acs_objects				o,
				us_states				s,
				countries
		 where	a.address_id		= :address_id
		   and	a.address_type_id	= c.category_id
		   and	a.address_id		= o.object_id
		   and	a.fips_state_code	= s.fips_state_code	(+)
		   and	a.fips_country_code	= countries.iso		(+)
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
