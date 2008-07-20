<?xml version=1.0?>
  <queryset>
	 
 <!-- START ctrl::cal::get.get -->
<fullquery name="ctrl::cal::get.get">
  <querytext>
   select cal_name,description,owner_id,object_id
   from ctrl_calendars
   where cal_id=:cal_id
  </querytext>
</fullquery>
<!-- END ctrl::cal::get.get -->

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
		cc.cal_id,
		substr(cc.cal_name,1,:truncate_length) as truncated_cal_name
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
