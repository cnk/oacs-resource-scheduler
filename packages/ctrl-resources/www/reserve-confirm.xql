<?xml version="1.0"?>
<queryset>
	 <fullquery name="check_dates">
             <querytext>
		select 1 from dual where $end_date_sql < $start_date_sql
	     </querytext>
        </fullquery>

	 <fullquery name="check_dates_past">
             <querytext>
		select 1 from dual where $start_date_sql < to_date(sysdate, 'YYYY MM DD HH24 MI')
	     </querytext>
        </fullquery>

	<fullquery name="get_conflicting_events">
             <querytext>
	     select event_id
	     from crs_events_vw	
	     where request_id=:conflicting_request_id
	     </querytext>
        </fullquery>

	<fullquery name="get_start_date_pretty">
             <querytext>
		select $start_date_sql from dual
	     </querytext>
        </fullquery>
	
	<fullquery name="get_repeat_end_date">
		<querytext>
			select to_char(add_months($repeat_end_date_sql, 300), 'YYYY MM DD HH24 MI PM') as new_date from dual
		</querytext>
	</fullquery>

	<fullquery name="check_exists">
		<querytext>
		select 1
		from crs_requests
		where request_id=:request_id
		</querytext>
	</fullquery>

	<fullquery name="check_exists_repeat">
		<querytext>
		select count(*)
		from crs_requests
		where repeat_template_id=:request_id
		</querytext>
	</fullquery>
	
        <fullquery name="get_event">
             <querytext>
		select event_id
		from crs_events_vw
		where request_id=:request_id and
			event_object_id=:eq_id
	     </querytext>
        </fullquery>

        <fullquery name="get_request_id_from_template_id">
             <querytext>
		select request_id
		from crs_requests
		where repeat_template_id = :template_id
	     </querytext>
        </fullquery>

        <fullquery name="get_event_start_dates">
             <querytext>
		select 'to_date(''' || to_char(e.start_date, 'YYYY MM DD HH24 MI') || ''', ''YYYY MM DD HH24 MI'')' as start_date
		from crs_requests cr, crs_events ce, ctrl_events e
		where cr.repeat_template_id = :template_id
		and cr.request_id = ce.request_id and ce.event_id = e.event_id
		group by e.start_date
	     </querytext>
        </fullquery>

        <fullquery name="get_event_end_dates">
             <querytext>
		select 'to_date(''' || to_char(e.end_date, 'YYYY MM DD HH24 MI') || ''', ''YYYY MM DD HH24 MI'')' as end_date
		from crs_requests cr, crs_events ce, ctrl_events e
		where cr.repeat_template_id = :template_id
		and cr.request_id = ce.request_id and ce.event_id = e.event_id
		group by e.end_date
	     </querytext>
        </fullquery>

	<fullquery name="get_future_event_id">
             <querytext>
		select event_id
		from ctrl_events 
		where repeat_template_id = :event_repeat_template_id
		and start_date >= $date_str
	     </querytext>
        </fullquery>

	<fullquery name="get_future_request_id">
             <querytext>
		select request_id
		from crs_events_vw 
		where repeat_template_id = :event_repeat_template_id
		and start_date >= $date_str
		group by request_id
	     </querytext>
        </fullquery>

	<fullquery name="get_current_event_start_date">
             <querytext>
		select to_char(start_date, 'YYYY MM DD HH24 MI') start_date
		from ctrl_events
		where event_id = :event_id
	     </querytext>
        </fullquery>

        <fullquery name="default_equipment">
                <querytext>
                     select resource_id
                     from crs_room_default_resources_vw
                     where parent_resource_id = :room_id
                </querytext>
        </fullquery>
</queryset>
