<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_event_tasks">
	<querytext>
		select t.task_id,
			t.event_id,
			t.title,
			t.assigned_by,
			t.due_date,
			t.priority,
			t.status,
			t.category_id,
			t.start_date,
			t.end_date,
			t.percent_completed,
			t.notes,
			c.name as task_name,
			rtrim(p.first_names) || ' ' || rtrim(p.last_name) as name
		from 	ctrl_events_tasks t, persons p, ctrl_categories c
		where	t.event_id = :event_id and t.assigned_by = p.person_id and t.category_id = c.category_id
		order by $order_by $order_dir
	</querytext>
	</fullquery>

	<fullquery name="get_event_data">
		<querytext>
			select	e.event_id,
				acs_object.name(e.event_object_id) as event_object_id1,
				ctrl_calendar.name(e.event_object_id) as event_object_id,
				ctrl_category.name(e.category_id) as category_id,
				e.repeat_template_id,
				e.repeat_template_p,
				e.title,
				e.speakers,
				to_char(e.start_date, 'Month DD, YYYY HH12:MI AM') as event_start_date,
				to_char(e.end_date, 'Month DD, YYYY HH12:MI AM') as event_end_date,
				e.all_day_p,
				e.location,
				e.notes,
				e.capacity
			from 	ctrl_events e
			where e.event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_repeat_event_data">
		<querytext>
			select ctrl_events.event_id, ctrl_events.title, ctrl_events.speakers, ctrl_calendar.name(object_id) as object, 
				to_char(ctrl_events.start_date, 'Month DD, YYYY HH12:MI AM') as repeat_start_date,
				to_char(ctrl_events.end_date, 'Month DD, YYYY HH12:MI AM') as repeat_end_date 
			from ctrl_events, acs_objects 
			where ctrl_events.event_object_id = acs_objects.object_id and ctrl_events.repeat_template_p = 'f' 
				and repeat_template_id = :repeat_template_id and ctrl_events.event_id <> :event_id 
				and (to_char(ctrl_events.start_date, 'YYYY/MM/DD') > to_char(sysdate, 'YYYY/MM/DD')) 
			order by ctrl_events.title, ctrl_events.start_date
		</querytext>
	</fullquery>
</queryset>
