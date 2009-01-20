<?xml version="1.0"?>
<queryset>

	<fullquery name="event_rsvp_query">
	<querytext>
    		select *
    		from    ctrl_events_rsvps
		where   rsvp_event_id  = :event_id 
	</querytext>
	</fullquery>

</queryset>
