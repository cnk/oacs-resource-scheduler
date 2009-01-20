<?xml version="1.0"?>
<queryset>

	<fullquery name="rsvp_delete">
	<querytext>
	delete from ctrl_events_rsvps
        where rsvp_event_id = :rsvp_event_id
	</querytext>
	</fullquery>

	<fullquery name="get_event_info">
	<querytext>
		select  ce.title,
			ce.start_date,
			ce.end_date,
			ce.all_day_p,
			nvl(ce.capacity,0) as capacity,
			ce.location,
			category.name(ce.category_id) as category,
			nvl(cer.rsvp_admin_approval_required_p,'t') as approval_required_p,
			to_char(nvl(cer.rsvp_registration_start_date,ce.start_date-7),'YYYY MM DD') as registration_start,
			to_char(nvl(cer.rsvp_registration_end_date,ce.start_date),'YYYY MM  DD') as registration_end,
			nvl(cer.rsvp_capacity_consideration_p,'t') as capacity_consideration_p,
			decode(cer.rsvp_event_id,null,0,1) as rsvp_exists_p
		from    ctrl_events ce,
			ctrl_events_rsvps cer
		where   ce.event_id = :rsvp_event_id
		and     ce.event_id = cer.rsvp_event_id(+)
	</querytext>
	</fullquery>

	<fullquery name="rsvp_exists_p">
	<querytext>
		select 	count(*)
		from    ctrl_events_rsvps
		where   rsvp_event_id = :rsvp_event_id
	</querytext>
	</fullquery>

	<fullquery name="rsvp_update">
	<querytext>
	update ctrl_events_rsvps
	set rsvp_admin_approval_required_p = :approval_required_p,
	    rsvp_registration_start_date = $registration_start,
	    rsvp_registration_end_date = $registration_end,
	    rsvp_capacity_consideration_p = :capacity_consideration_p
        where rsvp_event_id = :rsvp_event_id
	</querytext>
	</fullquery>

	<fullquery name="rsvp_insert">
	<querytext>
        insert into ctrl_events_rsvps
	(rsvp_event_id,
	 rsvp_admin_approval_required_p,
	 rsvp_registration_start_date,
	 rsvp_registration_end_date,
	 rsvp_capacity_consideration_p)
        values (:rsvp_event_id,
		:approval_required_p,
		$registration_start,
		$registration_end,
		:capacity_consideration_p)
	</querytext>
	</fullquery>

	<fullquery name="event_capacity_update">
	<querytext>
	update ctrl_events
	set capacity = :capacity
        where event_id = :rsvp_event_id
	</querytext>
	</fullquery>

	<fullquery name="event_rsvp_attendees">
	<querytext>
	select last_name, first_name, email, response_status, to_char(signin_date,'Month DD, YYYY HH12:MI AM') as signin_date, signin_id
        from ctrl_events_attendees 
	where rsvp_event_id = :rsvp_event_id
	order by last_name, first_name
	</querytext>
	</fullquery>
</queryset>
