<?xml version=1.0?>
<queryset>
	<fullquery name="ctrl::address::get.get">
		<querytext>
		select
			a.description as address_description,
			a.address_type_id,
			a.building_id as building_id,
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
			a.gis,
			a.floor,
			a.room,
			s.abbrev as state_name
		from   ctrl_addresses a,
		       us_states s
		where  address_id=:address_id and a.fips_state_code=s.fips_state_code(+)
		</querytext>
	</fullquery>

</queryset>
