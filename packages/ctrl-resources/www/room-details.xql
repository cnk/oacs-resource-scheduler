<?xml version="1.0"?>
<queryset> 
	<fullquery name="default_equipment">
		<querytext>
                     select name || decode (quantity,1,'',' (Qty '||quantity||')') as display
                     from crs_room_default_resources_vw
                     where parent_resource_id = :room_id  
		</querytext>
	</fullquery>

	<fullquery name="room_resv_equipment">
		<querytext>
                     select  resource_id, name || decode (quantity,1,'',' (Qty '||quantity||')') as display, resource_category_id 
                     from crs_room_resv_resources_vw
                     where parent_resource_id = :room_id  
		</querytext>
	</fullquery>

	<fullquery name="general_resv_equipment">
		<querytext>
                     select  name || decode (quantity,1,'',' (Qty '||quantity||')') as display, resource_id
                     from crs_room_resv_resources_vw
                     where parent_resource_id is null
		</querytext>
	</fullquery>

	<fullquery name="get_event_data">
		<querytext>
			select	event_id,
				event_object_id,
				repeat_template_id,
				repeat_template_p,
				title,
				to_char(start_date, 'YYYY MM DD HH12 MI AM') as start_date,
				to_char(end_date, 'YYYY MM DD HH12 MI AM') as end_date,
				all_day_p,
				location,
				notes,
				capacity
			from 	ctrl_events
			where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_object_types">
		<querytext>
			select acs_object.name(object_id) as object_name, object_id  from acs_objects where rownum < 20 order by object_name asc
		</querytext>
	</fullquery>

	<fullquery name="get_repeat_end_date">
		<querytext>
			select to_char(add_months(to_date(:repeat_end_date_str, 'YYYY MM DD HH24 MI'), 300), 'YYYY MM DD HH24 MI PM') as new_date from dual
		</querytext>
	</fullquery>

    <fullquery name="get_type_options">
        <querytext>
       select  distinct c.name,
	       category_id
       from crs_resv_resources_vw v,
	    ctrl_categories c
       where v.resource_category_id=c.category_id
        </querytext>
    </fullquery>

    <fullquery name="get_available_resources">
        <querytext> 
       select  name, resource_id
       from crs_resv_resources_vw
       where resource_id NOT IN (select room_id from crs_rooms)
        </querytext>
    </fullquery>

      <fullquery name="get_room_id_for_request">
        <querytext> 
	select event_id
	from    crs_events_vw v,
		crs_rooms r
	where v.event_object_id=r.room_id and
		v.request_id=:request_id
        </querytext>
    </fullquery>

    <fullquery name="get_equipment_list">
        <querytext> 
	select event_object_id
	from    crs_events_vw v
	where v.event_object_id!=:room_id and
		v.request_id=:request_id
        </querytext>
    </fullquery>

    <fullquery name="get_repeat_template_id">
        <querytext>
        select repeat_template_id from crs_requests where request_id = :request_id and repeat_template_p = 'f'
        </querytext>
    </fullquery>

    <fullquery name="get_repeat_reservation">
        <querytext>
        select v.title, v.status, v.event_id as event_id1, v.request_id as request_id1,
               to_char(v.start_date, 'Mon DD, YYYY HH12:MI AM') as start_date,
               to_char(v.end_date, 'Mon DD, YYYY HH12:MI AM') as end_date
	from crs_events_vw v, crs_requests r
	where v.request_id=r.request_id and r.repeat_template_id = :repeat_template_id and r.repeat_template_p = 'f' 
		and r.request_id <> :request_id and v.event_object_id = :room_id
        </querytext>
    </fullquery>

</queryset>
