<?xml version="1.0"?>
<queryset>
	<fullquery name="event_list_query">
	<querytext>
	select * from 
		(select event_id, title,start_date_sort, end_date_sort, start_date, end_date, all_day_p, location, capacity, category_name, rownum as row_num from 
			(select * from
				(select ce.event_id,
				ce.title,
				to_char(ce.start_date, 'YYYY/MM/DD HH12:MI AM') as start_date_sort, 
     				to_char(ce.end_date, 'YYYY/MM/DD HH12:MI AM') as end_date_sort, 
          			decode(ce.all_day_p,'t',to_char(ce.start_date,'Mon DD, YYYY'),to_char(ce.start_date,'Mon DD, YYYY HH12:MI am')) as start_date,
				decode(ce.all_day_p,'t',to_char(ce.end_date,'Mon DD, YYYY'),to_char(ce.end_date,'Mon DD, YYYY HH12:MI am')) as end_date,
           			ce.all_day_p,
				ce.location,
				ce.capacity,
				c.plural as category_name
    				from 	ctrl_events ce, 
					acs_objects a, 
					ctrl_categories c,
					apm_packages pkg 
				where 	a.object_id  = ce.event_id 
				and 	a.context_id = :context_id 
				and 	pkg.package_id = ce.package_id
				and	ce.repeat_template_p = 'f'
				and 	ce.category_id = c.category_id(+) $category_constraint_clause )  inner_table
			order by $order_by $order_dir) table_name
		) outter_table
	where (row_num >= :lower_bound and row_num <= :upper_bound) 
	</querytext>
	</fullquery>


	<fullquery name="event_rsvp_query">
	<querytext>
    		select *
    		from    ctrl_events_rsvps
		where   rsvp_event_id  = :event_id 
	</querytext>
	</fullquery>

	<fullquery name="sql_total_items">
	<querytext>
			select 	count(*) as total_items
			from 	ctrl_events ce, 
				acs_objects a,
				ctrl_categories c,
				apm_packages pkg
			where 	a.object_id = ce.event_id
			and 	a.context_id = :context_id
			and 	pkg.package_id = ce.package_id
			and	ce.repeat_template_p = 'f' 
			and     ce.category_id = c.category_id(+) $category_constraint_clause
	</querytext>
	</fullquery>

</queryset>
