<?xml version="1.0"?>
<queryset>
	<fullquery name="event_list">
		<querytext>
		select 	event_id,
			status,
			reserved_by,
			date_reserved,
			event_code,
			event_object_id,
			repeat_template_id,
			repeat_template_p,
			title,
			start_date,
			end_date,
			all_day_p,
			location,
			notes,
			capacity
		from   	crs_events_vw
		where  	request_id = :request_id
		</querytext>
	</fullquery>
</queryset>
