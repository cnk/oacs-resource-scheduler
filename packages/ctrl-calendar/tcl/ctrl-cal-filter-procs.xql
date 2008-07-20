<?xml version=1.0?>
  <queryset>
	 
<!-- START ctrl::cal::get.get -->
<fullquery name="ctrl::cal::filter::get.get">
  <querytext>
   select cal_filter_id, filter_name, description, cal_id, filter_type
   from ctrl_calendar_filters
   where cal_filter_id=:cal_filter_id
  </querytext>
</fullquery>
<!-- END ctrl::cal::get.get -->

<fullquery name="ctrl::cal::filter::update.update">
  <querytext>
	update ctrl_calendar_filters 
	set filter_name=:filter_name, description=:description,cal_id=:cal_id, filter_type=:filter_type
	where cal_filter_id=:cal_filter_id
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::name_unique_p.name_unique_p">
  <querytext>
	select count(*)
	from dual
	where not exists (
		select 1
		from ctrl_calendar_filters 
		where filter_name=:filter_name and cal_id=:cal_id and cal_filter_id <> :cal_filter_id)
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::map.delete">
  <querytext>
	delete from ctrl_cal_filter_object_map
	where cal_filter_id = :cal_filter_id
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::map.new">
  <querytext>
	insert into ctrl_cal_filter_object_map (cal_filter_id, object_id, color)
	values (:cal_filter_id, :object_id, :color)
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::get_mapped_object_id.get">
  <querytext>
	select object_id
	from ctrl_cal_filter_object_map
	where cal_filter_id = :cal_filter_id
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::get_mapped_color.get">
  <querytext>
	select object_id, color
	from ctrl_cal_filter_object_map
	where cal_filter_id = :cal_filter_id
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::day_view.get_filter_type">
  <querytext>
	select filter_type 
	from ctrl_calendar_filters
	where cal_filter_id = :cal_filter_id
  </querytext>
</fullquery>

<fullquery name="ctrl::cal::filter::day_view.get_category_events">
  <querytext>
	 select ce.event_object_id, to_char(ce.start_date, 'hh24:mi') as start_time,
           to_char(ce.end_date, 'hh24:mi') as end_time,
           ce.event_id, ce.title,
           to_char(ce.start_date, 'J') as start_date,
           to_char(ce.end_date, 'J') as end_date
    from   ctrl_events ce, ctrl_calendar_event_categories cc
    where  ce.event_id = cc.event_id and
	   cc.category_id = :object_id and 
           to_char(ce.start_date, 'J') <= to_char(to_date(:current_date),'J') and
           to_char(ce.end_date, 'J') >= to_char(to_date(:current_date),'J')
    order by ce.start_date
  </querytext>
</fullquery>






<fullquery name="ctrl::cal::option_list.calendars">
  <querytext>
      select cal_id, cal_name
      from   ctrl_calendars
      where  cal_id = object_id
      and    owner_id is null
      order by cal_name
  </querytext>
</fullquery>
   
  <fullquery name="ctrl::cal::event_categories_upd.event_categories_del">
	<querytext>
		delete from ctrl_calendar_event_categories where event_id = :event_id
	</querytext>
  </fullquery>

  <fullquery name="ctrl::cal::event_categories_upd.event_categories_create">
	<querytext>
		insert into ctrl_calendar_event_categories values(:event_id, :category_id)
	</querytext>
  </fullquery>

<fullquery name="ctrl::cal::event_categories_recurrence_upd.get_event_id">
 <querytext>
        select  event_id
          from  ctrl_events
         where  repeat_template_id = :repeat_template_id and start_date >= $start_date
 </querytext>
</fullquery>

<fullquery name="ctrl::cal::get_event_categories.get_event_categories">
 <querytext>
        select  c.name
          from  ctrl_calendar_event_categories ccec,
		ctrl_categories c
         where  ccec.event_id = :event_id
	   and  ccec.category_id = c.category_id
	 order  by c.name
 </querytext>
</fullquery>

<fullquery name="ctrl::cal::get_calendar_list.get_calendar_list">
 <querytext>
	select 	cc.cal_name, 
		cc.cal_id
	from 	ctrl_calendars cc $table_constraint
	where 	cc.owner_id is null
	and 	cc.cal_id = cc.object_id $and_filter_by
 </querytext>
</fullquery>

<fullquery name="ctrl::cal::get_admin_calendar_list.get_admin_calendar_list">
 <querytext>
      select   a.cal_name, a.cal_id
      from     ctrl_calendars a
      where    a.cal_id = a.object_id
      and      a.owner_id is null
      and      acs_permission.permission_p(cal_id,:user_id,'admin') = 't'
      order by lower(a.cal_name)
 </querytext>
</fullquery>

<fullquery name="ctrl::cal::get_main_calendar.get_main_calendar">
 <querytext>
      select   a.cal_name, a.cal_id
      from     ctrl_calendars a
      where    a.cal_id = a.object_id
      and      a.owner_id is null
      and      a.cal_name = 'Main Calendar'
 </querytext>
</fullquery>

 </queryset>
