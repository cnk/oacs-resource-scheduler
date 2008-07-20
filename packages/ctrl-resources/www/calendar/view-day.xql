<?xml version="1.0"?>
<queryset>
<fullquery name="get_daily_events">
<querytext>
    select event_id, event_object_id,
           title, trim(to_char(start_date, 'hh24:mi')) as start_time,
           trim(to_char(end_date, 'hh24:mi')) as end_time
    from   ctrl_events
    where  event_object_id in ($object_id_list)
           and to_char(start_date, 'yyyy-mm-dd') = to_char(to_date(:current_date),'yyyy-mm-dd')
    order by start_time asc
</querytext>
</fullquery>
</queryset>
