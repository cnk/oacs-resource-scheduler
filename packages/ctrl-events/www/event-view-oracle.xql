<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8</version></rdbms>

	<fullquery name="get_repeat_event_data">
		<querytext>
			select ctrl_events.event_id, ctrl_events.title, acs_object.name(object_id) as object, 
				to_char(ctrl_events.start_date, 'Month DD, YYYY HH12:MI AM') as repeat_start_date,
				to_char(ctrl_events.end_date, 'Month DD, YYYY HH12:MI AM') as repeat_end_date 
			from ctrl_events, acs_objects 
			where ctrl_events.event_object_id = acs_objects.object_id and ctrl_events.repeat_template_p = 'f' 
				and repeat_template_id = :repeat_template_id and ctrl_events.event_id <> :event_id 
				and (to_char(ctrl_events.start_date, 'YYYY/MM/DD') > to_char(sysdate, 'YYYY/MM/DD')) 
			order by ctrl_events.title, ctrl_events.start_date
		</querytext>
	</fullquery>

</queryset>