<?xml version="1.0"?>
<queryset>

<fullquery name="get_calendar_name">
<querytext>
	select cal_name
	from   ctrl_calendars
	where  cal_id = :cal_id
</querytext>
</fullquery>

<fullquery name="get_all_events">
<querytext>
    select event_id, event_object_id,
           title, notes, location, capacity, all_day_p,
	   trim(to_char(start_date, 'mm/dd/yy hh12:mi am')) as start_date,
	   trim(to_char(end_date, 'mm/dd/yy hh12:mi am')) as end_date,
	   trim(to_char(start_date, 'hh24:mi')) as start_time,
           trim(to_char(end_date, 'hh24:mi')) as end_time
    from   ctrl_events
    where  event_object_id = :cal_id
           and to_char(end_date, 'yyyy-mm-dd') >= to_char(to_date(:current_date),'yyyy-mm-dd')
	   and repeat_template_p = 'f'
    order by start_date desc
</querytext>
</fullquery>
</queryset>
