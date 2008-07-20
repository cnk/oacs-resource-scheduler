<?xml version="1.0"?>
<queryset>
        <fullquery name="get_filter_data">
        <querytext>
		select filter_name, description, cal_id, filter_type
   		from ctrl_calendar_filters
   		where cal_filter_id=:cal_filter_id
        </querytext>
        </fullquery>

	<fullquery name="get_room_list">
	<querytext>
        	select  crd.name, crd.room_id
        	from    crs_room_details crd
        	where   crd.room_id in (select v.resource_id from crs_subsite_resrc_map_vw v where v.subsite_id = :subsite_id)
        	order by crd.name
	</querytext>
</fullquery>

</queryset>
