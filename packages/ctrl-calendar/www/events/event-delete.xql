<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_attendees">
		<querytext>
			select event_attendee_id
			from ctrl_events_attendees
			where rsvp_event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="delete_rsvps">
		<querytext>
			delete from ctrl_events_rsvps
			where rsvp_event_id = :event_id
		</querytext>
	</fullquery>


	<fullquery name="delete_attendees">
		<querytext>
			delete from ctrl_events_attendees
			where rsvp_event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="delete_roles">
		<querytext>
			delete from ctrl_events_attendees_roles
			where event_attendee_id = :event_attendee_id
		</querytext>
	</fullquery>

	<fullquery name="get_event_data">
		<querytext>
			select	e.event_id,
				acs_object.name(e.event_object_id) as event_object_id,
				c.name as category,
				e.repeat_template_id,
				e.repeat_template_p,
				e.title,
				to_char(e.start_date, 'Month DD, YYYY HH12:MI AM') as event_start_date,
				to_char(e.end_date, 'Month DD, YYYY HH12:MI AM') as event_end_date,
				e.all_day_p,
				e.location,
				e.notes,
				e.capacity
			from 	ctrl_events e, ctrl_categories c
			where event_id = :event_id and e.category_id = c.category_id(+)
		</querytext>
	</fullquery>

	<fullquery name="get_delete_date">
		<querytext>
			select to_char(start_date, 'YYYY/MM/DD HH12:MI AM') 
			       from ctrl_events 
			where event_id=:event_id
		</querytext>
	</fullquery>

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
