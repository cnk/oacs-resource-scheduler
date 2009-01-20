<?xml version="1.0"?>
<queryset>
	<fullquery name="event_objects">
	<querytext>
	select * from 
		(select event_object_id, name, object_type, description, url, rownum as row_num $event_tag from 
			(select * from
				(select o.event_object_id, o.name || ' ' || o.last_name name, 
					c.name as object_type, o.description, o.url $event_tag
    				from 	ctrl_events_objects o, 
					acs_objects a, 
					categories c
					$event_table
				where 	a.object_id  = o.event_object_id 
				and 	a.context_id = :package_id
				and 	c.category_id = o.object_type_id
				$event_table_constraint
				$search_constraint
			)  inner_table
			order by $order_by $order_dir) table_name
		) outter_table
	where (row_num >= :lower_bound and row_num <= :upper_bound) 
	</querytext>
	</fullquery>

	<fullquery name="sql_total_items">
	<querytext>
			select 	count(*) as total_items
			from 	ctrl_events_objects o, 
				acs_objects a,
				categories c		
				$event_table		
			where 	a.object_id = o.event_object_id
			and 	a.context_id = :package_id
			and 	c.category_id = o.object_type_id
			$event_table_constraint			
			$search_constraint
	</querytext>
	</fullquery>

</queryset>
