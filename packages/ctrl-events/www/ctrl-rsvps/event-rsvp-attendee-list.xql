<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_event_attendee">
	<querytext>
		select	event_attendee_id,
				rsvp_event_id,
				email,
				first_name,
				last_name,
				response_status as response,
				approval_status as approval
		from 	ctrl_events_attendees 
		where rsvp_event_id = :event_id and $filter_by
			order by $order_by $order_dir
	</querytext>
	</fullquery>

	<fullquery name="inquire_attendee_role">
	<querytext>
		select count(1) as has_role
		from 	ctrl_events_attendees_roles
		where event_attendee_id = :event_attendee_id 
	</querytext>
	</fullquery>


	<fullquery name="rsvp_attendee_update">
	<querytext>
	update ctrl_events_rsvps
	set email = :email,
	    first_name= :first_name,
	    last_name = :last_name,
	    response_status = :response_status,
	    approval_status = :approval_status
        where event_attendee_id = :event_attendee_id and rsvp_event_id = :rsvp_event_id
	</querytext>
	</fullquery>

	<fullquery name="rsvp_attendee_insert">
	<querytext>
        insert into ctrl_events_attendees
        values (:event_attendee_id, :rsvp_event_id, :email, :first_name, :last_name, :response_status, :approval_status)
	</querytext>
	</fullquery>


	<fullquery name="get_event_data">
	<querytext>
		select	e.event_id,
				acs_object.name(e.event_object_id) as event_object_id,
				c.name as category_id,
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
		where e.event_id = :event_id and e.category_id = c.category_id
	</querytext>
	</fullquery>

</queryset>

