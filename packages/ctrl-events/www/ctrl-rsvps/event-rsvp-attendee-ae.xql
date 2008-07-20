<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="rsvp_attendee_exists_p">
	<querytext>
		select 	count(*)
		from    ctrl_events_attendees
		where rsvp_event_id = :event_id and $by_event_attendee_id and $by_email
	</querytext>
	</fullquery>

	<fullquery name="get_attendee">
	<querytext>
		select	event_attendee_id,
				rsvp_event_id,
				email,
				first_name,
				last_name,
				signin_id,
				to_char(signin_date, 'Month DD, YYYY HH12:MI AM') as signin_date,
				response_status,
				approval_status
		from 	ctrl_events_attendees
		where rsvp_event_id = :event_id and $by_event_attendee_id and $by_email

	</querytext>
	</fullquery>

	<fullquery name="rsvp_attendee_exists_p_by_userid">
	<querytext>
		select 	count(*)
		from 	ctrl_events_attendees c, parties p
		where p.party_id =:user_id and c.email = p.email and c.rsvp_event_id = :event_id
	</querytext>
	</fullquery>

	<fullquery name="get_attendee_by_userid">
	<querytext>
		select	c.event_attendee_id,
				c.rsvp_event_id,
				c.email as email,
				c.first_name,
				c.last_name,
				c.signin_id,
				to_char(c.signin_date, 'Month DD, YYYY HH12:MI AM') as signin_date,
				c.response_status,
				c.approval_status
		from 	ctrl_events_attendees c, parties p
		where p.party_id =:user_id and c.email = p.email and c.rsvp_event_id = :event_id
	</querytext>
	</fullquery>

	<fullquery name="get_user">
	<querytext>
		select	pt.email as user_email,
				ps.first_names as user_fname,
				ps.last_name as user_lname
		from 	persons ps, parties pt
		where ps.person_id = :user_id and pt.party_id =:user_id
	</querytext>
	</fullquery>

	<fullquery name="get_role">
	<querytext>
		select name,
		category_id
		from 	ctrl_categories
		where parent_category_id = 359147
		order by name
	</querytext>
	</fullquery>

	<fullquery name="attendee_role_exists_p">
	<querytext>
		select count(1)
		from 	ctrl_events_attendees_roles
		where event_attendee_id = :event_attendee_id 
	</querytext>
	</fullquery>


	<fullquery name="get_attendee_role_name">
	<querytext>
		select c.name,
		       r.role_id
		from 	ctrl_events_attendees_roles r, ctrl_categories c
		where r.event_attendee_id = :event_attendee_id and c.category_id = r.role_id 
	</querytext>
	</fullquery>

	<fullquery name="insert_attendee_role">
	<querytext>
        insert into ctrl_events_attendees_roles
        values (:event_attendee_id, :attendee_role)
	</querytext>
	</fullquery>

	<fullquery name="update_attendee_role">
	<querytext>
	update ctrl_events_attendees_roles
	set role_id = :attendee_role
	where event_attendee_id = :event_attendee_id
	</querytext>
	</fullquery>

	<fullquery name="delete_attendee_role">
	<querytext>
	delete from ctrl_events_attendees_roles
	where event_attendee_id = :event_attendee_id and role_id = :role_id
	</querytext>
	</fullquery>

	<fullquery name="rsvp_attendee_update">
	<querytext>
	update ctrl_events_attendees
	set email = :email,
	    first_name= :first_name,
	    last_name = :last_name,
	    response_status = :response_status,
	    approval_status = :approval_status
	where event_attendee_id = :event_attendee_id
	</querytext>
	</fullquery>

	<fullquery name="rsvp_attendee_insert">
	<querytext>
        insert into ctrl_events_attendees
		(event_attendee_id, rsvp_event_id, email, first_name, last_name, response_status, approval_status)
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

	<fullquery name="get_repeat_template_p">
	<querytext>
		select	repeat_template_p
		from 	ctrl_events
		where event_id = :event_id
	</querytext>
	</fullquery>

	<fullquery name="get_repeat_template_id">
	<querytext>
		select repeat_template_id, start_date
	      from ctrl_events
		where event_id = :event_id
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

