<?xml version="1.0"?>
<queryset> 

	<fullquery name="sql_total_items">
		<querytext>
			select 	count(*) as total_items
			from 	ctrl_events, acs_objects, apm_packages
			where 	1=1 $search_constraint and
				acs_objects.context_id = :context_id and 
				apm_packages.package_id = ctrl_events.package_id and
				ctrl_events.event_object_id = acs_objects.object_id and
                                ctrl_events.repeat_template_p = 'f'
		</querytext>
	</fullquery>

        <fullquery name="rsvp_count">
                <querytext>
                        select  count(*) as rsvp
                        from    ctrl_events, ctrl_events_attendees
                        where   ctrl_events.event_id = ctrl_events_attendees.rsvp_event_id
                </querytext>
        </fullquery>

        <fullquery name="rsvp_admin_count">
                <querytext>
                        select  rsvp_event_id as rsvp
                        from    ctrl_events_rsvps
                        where   rsvp_event_id = :event_id
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



</queryset>
