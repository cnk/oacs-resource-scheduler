<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::exists_p.exists_p">
	<querytext>
		select count(*)
		from   ctrl_events
		where  event_id = :event_id
	</querytext>
</fullquery>

<fullquery name="ctrl_event::new.update_item_id">
 <querytext>
	update 	ctrl_events
	set 	image_item_id = :item_id
	where	event_id = :event_id
 </querytext>
</fullquery>

<fullquery name="ctrl_event::update_recurrences.get_event_id">
 <querytext>
	select	event_id
	  from	ctrl_events
	 where	repeat_template_id = :repeat_template_id and to_char(start_date, 'YYYY/MM/DD HH12:MI AM') >= :update_date
 </querytext>
</fullquery>

<fullquery name="ctrl_event::update_recurrences.get_update_date">
                <querytext>
                        select to_char(start_date, 'YYYY/MM/DD HH12:MI AM')
                               from ctrl_events
                        where event_id=:event_id
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
        update  ctrl_events set status = :status
        where   event_id = :event_id
 </querytext>
</fullquery>

<!-- START UPDATING EVENT -->
<fullquery name= "ctrl_event::update.update">
  <querytext>
        update  ctrl_events
          set   event_id                        = :event_id,
                event_object_id                 = :event_object_id,
                repeat_template_p               = :repeat_template_p,
                title                           = :title,
                speakers                        = :speakers,
                start_date                      = $start_date,
                end_date                        = $end_date,
                all_day_p                       = :all_day_p,
                location                        = :location,
                capacity                        = :capacity,
                category_id                     = :category_id
	where	event_id	= :event_id
	</querytext>
</fullquery>

<fullquery name="ctrl_event::update.update_item_id">
 <querytext>
	update 	ctrl_events
	set 	image_item_id = :item_id
	where	event_id = :event_id
 </querytext>
</fullquery>


<!-- END UPDATING EVENT -->

</queryset>
