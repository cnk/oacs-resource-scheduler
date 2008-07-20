<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
        <fullquery name="find_attendee">
                <querytext>
			SELECT a.signin_id, a.first_name, a.last_name
			FROM ctrl_events_attendees a
			WHERE a.signin_id = :signin_id and a.rsvp_event_id = :event_id
                </querytext>
        </fullquery>

	<fullquery name="event_info">
		<querytext>
	 		select e.event_id, e.title as event_title, e.notes, decode(e.all_day_p,'t',to_char(e.start_date,'Mon DD, YYYY'),to_char(e.start_date,'Mon DD, YYYY HH12:MI am')) as start_date, decode(e.all_day_p,'t',to_char(e.end_date,'Mon DD, YYYY'),to_char(e.end_date,'Mon DD, YYYY HH12:MI am')) as end_date, e.all_day_p
    			from    ctrl_events e
		        where   e.event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_signin_count">
		<querytext>	
			select count(*) as signin_exist
			from ctrl_events_attendees 
			where event_id = :event_id and signin_id = :signin_id
		</querytext>
	</fullquery>

	<fullquery name="attendee_signin_update">
		<querytext>
			update ctrl_events_attendees set signin_date = sysdate 
			where rsvp_event_id = :event_id and signin_id = :signin_id
		</querytext>
	</fullquery>

</queryset>
