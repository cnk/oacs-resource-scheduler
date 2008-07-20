<?xml version="1.0"?>
<queryset>

<!-- START event::get.get -->
<fullquery name="ctrl_event::get.get">
 <querytext>
	select	event_object_id,
		repeat_template_id,
		repeat_template_p,
		title,
		speakers,
		to_char(start_date,$date_format) as start_date,
                to_char(end_date,$date_format) as end_date,
		to_char(start_date, 'Mon DD, YYYY ') || to_char(start_date,'FMHH12') || to_char(start_date,':MI AM') as pretty_start_date,
                to_char(end_date, 'Mon DD, YYYY ') || to_char(end_date,'FMHH12') || to_char(end_date,':MI AM') as pretty_end_date,
		all_day_p,
		location,
		notes,
		capacity,
		event_image_caption,
		event_image,
		ctrl_category.name(category_id) as category_name,
		acs_object.name(event_object_id) as event_object_name
	  from	ctrl_events
	 where	event_id = :event_id
 </querytext>
</fullquery>
<!-- END event::get.get -->

<fullquery name="ctrl_event::update_recurrences.get_event_id">
 <querytext>
	select	event_id
	  from	ctrl_events
	 where	repeat_template_id = :repeat_template_id and to_char(start_date, 'YYYY/MM/DD HH12:MI AM') >= :update_date
 </querytext>
</fullquery>

<fullquery name="ctrl_event::get_approved_events_by_day.get_events">
<querytext>
    select ce.event_object_id, to_char(ce.start_date, 'hh24:mi') as start_time,
           to_char(ce.end_date, 'hh24:mi') as end_time,
           ce.event_id, ce.title, ce.speakers,
           to_char(ce.start_date, 'J') as start_date,
           to_char(ce.end_date, 'J') as end_date,
	   ce.all_day_p
    from   ctrl_events ce, ctrl_calendar_event_map ccem
    where  ce.event_id = ccem.event_id 
      and  ccem.cal_id in ($object_id_list)
      and  (to_char(ce.start_date,'yyyy-mm-dd') = to_char(to_date(:current_date),'yyyy-mm-dd')
	or to_char(ce.end_date,'yyyy-mm-dd') = to_char(to_date(:current_date),'yyyy-mm-dd')
	or (to_char(ce.start_date, 'yyyy-mm-dd') < to_char(to_date(:current_date),'yyyy-mm-dd')
	and to_char(ce.end_date, 'yyyy-mm-dd') > to_char(to_date(:current_date),'yyyy-mm-dd')))
      and  repeat_template_p = 'f'
    order by ce.start_date
</querytext>
</fullquery>

<fullquery name="ctrl_event::update_event_status.update_status">
 <querytext>
	update	ctrl_events set status = :status
	where 	event_id = :event_id
 </querytext>
</fullquery>

</queryset>
