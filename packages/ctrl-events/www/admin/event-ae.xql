<?xml version="1.0"?>
<queryset> 

	<fullquery name="get_event_data">
		<querytext>
			select	event_id,
				event_object_id,
				category_id,
				repeat_template_id,
				repeat_template_p,
				title,
				to_char(start_date, 'YYYY MM DD HH24 MI') as start_date,
				to_char(end_date, 'YYYY MM DD HH24 MI') as end_date,
				all_day_p,
				location,
				notes,
				capacity
			from 	ctrl_events
			where event_id = :event_id
		</querytext>
	</fullquery>

</queryset>
