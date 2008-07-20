<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="get_event_data">
		<querytext>
			select	e.event_id,
				acs_object.name(e.event_object_id) as event_object_id1,
				ctrl_calendar.name(e.event_object_id) as event_object_id,
				ctrl_category.name(e.category_id) as category_id,
				e.repeat_template_id,
				e.repeat_template_p,
				e.title,
				to_char(e.start_date, 'Month DD, YYYY HH12:MI AM') as event_start_date,
				to_char(e.end_date, 'Month DD, YYYY HH12:MI AM') as event_end_date,
				e.all_day_p,
				e.location,
				e.notes,
				e.capacity
			from 	ctrl_events e
			where e.event_id = :event_id
		</querytext>
	</fullquery>
</queryset>
