<?xml version="1.0"?>
<queryset>
	<fullquery name="event_objects">
	<querytext>
		select distinct o.name || ' ' || o.last_name || ' (' || c.name  || ')' name, o.event_object_id, c.name, o.name
    		from 	ctrl_events_objects o, 
			acs_objects a, 
			categories c
			$event_table
		where 	a.object_id  = o.event_object_id 
		and 	a.context_id = :package_id
		and 	c.category_id = o.object_type_id
		$event_table_constraint
		$search_constraint
	        order by c.name, o.name
	</querytext>
	</fullquery>
</queryset>
