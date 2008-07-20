<?xml version="1.0"?>
<queryset>
<fullquery name="crs::event::get.get">
<querytext>
    select request_id,
	   status,
	   reserved_by,
	   date_reserved,
	   event_code,
	   event_object_id,
	   repeat_template_id,
	   repeat_template_p,
	   title,
	   to_char(start_date, $date_format) as start_date,
	   to_char(end_date, $date_format) as end_date,
	   all_day_p,
	   location,
	   notes,
	   capacity
    from   crs_events_vw
    where  event_id=:event_id
</querytext>
</fullquery>

<fullquery name="crs::event::new.check_code">
<querytext>
    select 1
    from   crs_events_vw
    where  event_code=:event_code
</querytext>
</fullquery>

<fullquery name="crs::event::list_event_timespan_in_a_month.get_timespan">
<querytext>
  select start_date, end_date, sum(timespan)
  from (
  	 select to_char(ce.start_date, 'dd') as start_date,
                to_char(ce.end_date, 'dd') as end_date,
	        decode(ce.all_day_p,
	        't', 24,
	        'f', (ce.end_date-ce.start_date)*24) as timespan
  	 from   ctrl_events ce, crs_events crs
  	 where  ce.event_object_id = :room_id and
                ce.event_id = crs.event_id and
		crs.status = 'approved' and
	  	to_char(ce.start_date, 'yyyy-mm') = to_char(to_date(:current_date), 'yyyy-mm')
  )
  group by start_date, end_date
</querytext>
</fullquery>

<fullquery name="crs::event::day_list.get_events">
<querytext>
    select ce.event_object_id, to_char(ce.start_date, 'hh24:mi') as start_time,
	   to_char(ce.end_date, 'hh24:mi') as end_time,
	   ce.event_id, ce.title,
	   to_char(ce.start_date, 'J') as start_date,
	   to_char(ce.end_date, 'J') as end_date,
	   cr.request_id, ce.event_object_id, start_date as sd, end_date as ed
    from   ctrl_events ce, crs_events cr
    where  ce.event_object_id in ($room_id) and
	   cr.event_id = ce.event_id and
	   cr.status = 'approved' and
	   to_char(ce.start_date, 'J') <= to_char(to_date(:current_date),'J') and
	   to_char(ce.end_date, 'J') >= to_char(to_date(:current_date),'J')
    order by ce.start_date
</querytext>
</fullquery>

<fullquery name="crs::event::month_list.get_events">
<querytext>
    select to_char(ce.start_date, 'J') as julian_start_date,
	   trim(to_char(ce.start_date, 'hh12:mi am')) as start_time,
	   ce.title,
   	   ce.event_id,
	   ce.event_object_id,
	   ce.start_date,
	   ce.end_date,
	   cr.request_id
    from   ctrl_events ce, crs_events cr
    where  ce.event_object_id in ($room_id) and
           cr.event_id = ce.event_id and
	   cr.status = 'approved' and
           to_char(ce.start_date, 'yyyy-mm') = to_char(to_date(:current_date),'yyyy-mm')
    order  by ce.start_date asc
</querytext>
</fullquery>

<fullquery name="crs::event::week_list.get_events">
<querytext>
   select  ce.event_id,
	   ce.event_object_id,
	   ce.title,
	   ce.start_date,
	   ce.end_date,
	   to_char(ce.start_date, 'J') as julian_start_date,
           trim(to_char(ce.start_date, 'hh12:mi am')) as start_time,
	   trim(to_char(ce.end_date, 'hh12:mi am')) as end_time,
	   cr.request_id
   from    ctrl_events ce, crs_events cr
   where   ce.event_object_id in ($room_id) and
	   cr.event_id = ce.event_id and
	   cr.status = 'approved' and
	   to_char(ce.start_date, 'yyyy-mm') = to_char(to_date(:current_date),'yyyy-mm')
   order by ce.start_date asc
</querytext>
</fullquery>

   <fullquery name="crs::event::get_repeat_template_id.get_repeat_template_id">
   	<querytext>
   		select e.repeat_template_id 
		from ctrl_events e
		where e.event_id = :event_id
        </querytext>
   </fullquery>
</queryset>
