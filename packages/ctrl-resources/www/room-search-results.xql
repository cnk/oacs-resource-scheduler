<?xml version="1.0"?>
<queryset>

        <partialquery name="filter_room_name">
                <querytext>
                   lower(d.name) like lower('%$name%')
                 </querytext>
        </partialquery>

        <partialquery name="filter_capacity">
                <querytext>
                   d.capacity >= :capacity
                 </querytext>
        </partialquery>

        <partialquery name="filter_location">
                <querytext>
lower(d.floor) || lower(d.room) || lower(a.address_line_1) || 
lower(a.address_line_2) || lower(a.address_line_3) || 
lower(a.address_line_4) || lower(a.address_line_5) || lower(a.city) || lower(a.zipcode) || lower(s.abbrev) || lower(s.state_name)
like lower('%:location%')
                 </querytext>
        </partialquery>

       <!-- Finds the room that has the exact number of equipments -->
        <partialquery name="rooms_with_equipment">
                <querytext>
                   (select crd.*, eqm.match_level
                   from crs_room_details crd,
                        (select z.parent_resource_id room_id, count(distinct z.resource_category_id) match_level
                            from crs_resources z, crs_subsite_resrc_map_vw v
                            where v.subsite_id = :subsite_id
                            and   z.parent_resource_id = v.room_id
                            and   z.resource_category_id  in ($eq_list_csv) 
                            and   z.parent_resource_id is not null
                        group by z.parent_resource_id 
                        having count(distinct z.resource_category_id) = :eq_list_count) eqm
                   where crd.package_id = :package_id and eqm.room_id = crd.room_id) d,
                 </querytext>
        </partialquery>

        <partialquery name="rooms_with_some_equipment">
                <querytext>
                   (select crd.*, eqm.match_level
                   from crs_room_details crd,
                        (select z.parent_resource_id room_id, count(distinct z.resource_category_id) match_level
                            from crs_resources z, crs_subsite_resrc_map_vw v
                            where v.subsite_id = :subsite_id
                            and   z.parent_resource_id = v.room_id
                            and   z.resource_category_id  in ($eq_list_csv) 
                            and   z.parent_resource_id is not null
                        group by z.parent_resource_id 
                        having count(distinct z.resource_category_id) < :eq_list_count) eqm
                   where crd.package_id = :package_id and eqm.room_id = crd.room_id
                   union 
                   select b.*, 0 as match_level from crs_room_details b
                   ) d,
                 </querytext>
        </partialquery>

        <partialquery name="rooms_with_no_equipment">
                <querytext>
                   (select b.*, 0 as match_level 
                    from crs_room_details b, crs_subsite_resrc_map_vw v 
                    where  v.subsite_id = :subsite_id
                    and    b.room_id = v.room_id) d,
                 </querytext>
        </partialquery>


        <fullquery name="get_result_rooms">
                <querytext>
                select * from (select  d.*
                from    $table_sql
			ctrl_addresses a,
	 		us_states s 
		where  d.package_id=:package_id AND 
		       d.address_id=a.address_id(+) AND 
		       a.fips_state_code=s.fips_state_code(+) AND
   		       d.enabled_p='t'  $search_filter
                order by d.match_level desc, d.capacity asc) z where rownum < :max_dbrows
                 </querytext>
        </fullquery>

        <fullquery name="get_matching_room_list">
                <querytext>
                select room_id from (
                select z.parent_resource_id room_id, count(distinct z.resource_category_id) 
                from crs_resources z, crs_subsite_resrc_map_vw v
                where v.subsite_id = :subsite_id
                and   z.parent_resource_id = v.room_id
                and   z.resource_category_id  in ($eq_list_csv) 
                and   z.parent_resource_id is not null
                group by z.parent_resource_id 
                having count(distinct z.resource_category_id) >= :eq_list_count)
                </querytext>
        </fullquery>

</queryset>
