<?xml version="1.0"?>
<queryset> 
	<fullquery name="get_events">
		<querytext>
		select  v.event_id as event_id2,
			v.request_id as request_id2,
			v.status,
			to_char(v.date_reserved,'Mon DD, YYYY HH12:MI AM') as date_reserved,
			v.event_code,
			v.event_object_id,
			v.title,
			to_char(v.start_date,'Mon DD, YYYY HH12:MI AM') as sd,
			to_char(v.end_date,'Mon DD, YYYY HH12:MI AM') as ed,
			to_char(v.start_date,'YYYY MM DD HH24 MI') as s_d,
			to_char(v.end_date,'YYYY MM DD HH24 MI') as e_d,
			v.all_day_p,
			v.location,
			v.notes,
			v.capacity,
			r.name as request_name,
			r.description as request_description,
			(select name from crs_resv_resources_vw where resource_id=v.event_object_id) as object_name,
			(select first_names || ' ' || last_name from persons where person_id=v.reserved_by) as reserved_by
		from   crs_requests r,
		       crs_events_vw v
		where  r.request_id=:request_id and
		       r.request_id=v.request_id
		order by  r.request_id,event_id

		</querytext>
	</fullquery>

	<fullquery name="count">
		<querytext>
		select count(*) 
		from   crs_requests r,
		       crs_events_vw v
		where  r.request_id=:request_id2 and r.repeat_template_id=:repeat_template_id and
		       r.request_id=v.request_id
		order by  r.request_id,event_id
		</querytext>
	</fullquery>

	<fullquery name="get_repeating_events">
		<querytext>
		select  v.event_id as event_id2,
			v.request_id as request_id2,
			v.status,
			to_char(v.date_reserved,'Mon DD, YYYY HH12:MI AM') as date_reserved,
			v.event_code,
			v.event_object_id,
			v.title,
			to_char(v.start_date,'Mon DD, YYYY HH12:MI AM') as sd,
			to_char(v.end_date,'Mon DD, YYYY HH12:MI AM') as ed,
			v.all_day_p,
			v.location,
			v.notes,
			v.capacity,
			r.name as request_name,
			r.description as request_description,
			(select name from crs_resv_resources_vw where resource_id=v.event_object_id) as object_name,
			(select first_names || ' ' || last_name from persons where person_id=v.reserved_by) as reserved_by
		from   crs_requests r,
		       crs_events_vw v
		where  r.request_id<>:request_id and r.repeat_template_id=:repeat_template_id and
		       r.request_id=v.request_id
		order by  r.request_id,event_id

		</querytext>
	</fullquery>

	<fullquery name="get_event_dates">
		<querytext>
			select to_char(start_date, 'YYYY MM DD HH24 MI') start_date, 
			       to_char(end_date, 'YYYY MM DD HH24 MI') end_date,
			       to_char(start_date, 'YYYY MM DD HH12 MI am') sd_list,
			       to_char(end_date, 'YYYY MM DD HH12 MI am') ed_list
			from ctrl_events where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_request_ids">
		<querytext>
			select request_id 
			from crs_events_vw 
			where start_date >= $sd and repeat_template_p = 'f'
			group by request_id
		</querytext>
	</fullquery>
</queryset>
