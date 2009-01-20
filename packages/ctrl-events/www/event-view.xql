<?xml version="1.0"?>
<queryset> 

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
</queryset>
