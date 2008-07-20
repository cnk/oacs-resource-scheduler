<?xml version="1.0"?>
<queryset>
   <fullquery name="crs::cnsi::filter_day_view.get_room_ids">
	<querytext>
		select distinct event_object_id, crd.name
		from ctrl_events ce, crs_events cr, crs_room_details crd
		where  ce.event_object_id = crd.room_id and
		       ce.event_object_id in ($room_ids) and
	   	       cr.event_id = ce.event_id and
	               cr.status = 'approved' and
        	       to_char(ce.start_date, 'J') <= to_char(to_date(:current_ansi_date),'J') and
	               to_char(ce.end_date, 'J') >= to_char(to_date(:current_ansi_date),'J')
		order by crd.name
        </querytext>
   </fullquery>

   <fullquery name="crs::cnsi::get_room_ids.get_cnsi_rooms">
	<querytext>
		select  crd.room_id
	        from    crs_room_details crd
        	where   package_id = :package_id
                	and crd.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v where v.subsite_id = :subsite_id)
	        order by crd.name
        </querytext>
   </fullquery>

   <fullquery name="crs::cnsi::color_code_legend.get_color_codes">
	<querytext>
	        select  crd.room_id, crd.name, crd.color
        	from    crs_room_details crd
	        where   package_id = :package_id
        	        and crd.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v where v.subsite_id = :subsite_id)
	        order by crd.name	
        </querytext>
   </fullquery>

</queryset>
