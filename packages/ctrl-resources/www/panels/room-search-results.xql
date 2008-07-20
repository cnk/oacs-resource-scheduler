<?xml version="1.0"?>
<queryset>

        <partialquery name="filter_subsite_d">
                <querytext>
                   d.subsite_id = :subsite_id and 
                 </querytext>
        </partialquery>

        <partialquery name="filter_subsite_v">
                <querytext>
                   v.subsite_id = :subsite_id and
                 </querytext>
        </partialquery>

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
                   (select crd.*, eqm.match_level, eqm.subsite_id
                   from crs_room_details crd,
                        (select z.parent_resource_id room_id, count(distinct z.resource_category_id) match_level, v.subsite_id
                            from crs_resources z, crs_subsite_resrc_map_vw v
                            where $filter_subsite_v 
                                  z.parent_resource_id = v.resource_id
                            and   z.resource_category_id  in ($eq_list_csv) 
                            and   z.parent_resource_id is not null
                        group by z.parent_resource_id, v.subsite_id 
                        having count(distinct z.resource_category_id) = :eq_list_count) eqm
                   where eqm.room_id = crd.room_id) d,
                 </querytext>
        </partialquery>

        <partialquery name="rooms_with_some_equipment">
                <querytext>
                   (select crd.*, eqm.match_level, eqm.subsite_id
                   from crs_room_details crd,
                        (select z.parent_resource_id room_id, count(distinct z.resource_category_id) match_level, v.subsite_id
                            from crs_resources z, crs_subsite_resrc_map_vw v
                            where $filter_subsite_v
                                  z.parent_resource_id = v.resource_id
                            and   z.resource_category_id  in ($eq_list_csv) 
                            and   z.parent_resource_id is not null
                        group by z.parent_resource_id, v.subsite_id
                        having count(distinct z.resource_category_id) < :eq_list_count) eqm
                   where eqm.room_id = crd.room_id
                   union 
                   select b.*, 0 as match_level, mv.subsite_id from crs_room_details b, crs_subsite_resrc_map_vw mv
                   where  mv.resource_id = b.room_id
                   ) d,
                 </querytext>
        </partialquery>

        <partialquery name="rooms_with_no_equipment">
                <querytext>
                   (select b.*, v.subsite_id, 0 as match_level 
                    from crs_room_details b, crs_subsite_resrc_map_vw v
                    where $filter_subsite_v
                          b.room_id = v.resource_id) d,
                 </querytext>
        </partialquery>


        <fullquery name="get_result_rooms">
                <querytext>
                select * from (select  d.*
                from    $table_sql
			ctrl_addresses a,
	 		us_states s 
		where  $filter_subsite_d
		       d.address_id=a.address_id(+) and 
		       a.fips_state_code=s.fips_state_code(+) and
   		       d.enabled_p='t'  $search_filter
                order by d.match_level desc, d.capacity asc) z where rownum < :max_dbrows
                 </querytext>
        </fullquery>

        <fullquery name="get_matching_room_list">
                <querytext>
                select room_id from (
                select z.parent_resource_id room_id, count(distinct z.resource_category_id) 
                from crs_resources z, crs_subsite_resrc_map_vw v
                where $filter_subsite_v
                      z.parent_resource_id = v.resource_id
                and   z.resource_category_id  in ($eq_list_csv) 
                and   z.parent_resource_id is not null
                group by z.parent_resource_id 
                having count(distinct z.resource_category_id) >= :eq_list_count)
                </querytext>
        </fullquery>

</queryset>
