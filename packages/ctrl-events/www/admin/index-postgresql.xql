<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.4</version></rdbms>
	<fullquery name="event_list_query">
	<querytext>
	  select  ce.event_id,
		  ce.title,
		  to_char(ce.start_date, 'YYYY/MM/DD HH12:MI AM') as start_date_sort, 
		  to_char(ce.end_date, 'YYYY/MM/DD HH12:MI AM') as end_date_sort, 
		  case 
			when ce.all_day_p = 't' then to_char(ce.start_date,'Mon DD, YYYY')
		  	when ce.all_day_p = 'f' then to_char(ce.start_date,'Mon DD, YYYY HH12:MI am')
		  end as start_date,
		  case 
			when ce.all_day_p = 't' then to_char(ce.end_date,'Mon DD, YYYY')
		  	when ce.all_day_p = 'f' then to_char(ce.end_date,'Mon DD, YYYY HH12:MI am')
		  end as end_date,
		  ce.all_day_p,
		  ce.location,
		  ce.capacity,
		  c.plural as category_name
	  from	  acs_objects a, 
		  apm_packages pkg,
		  ctrl_events ce left outer join ctrl_categories c
	       on ce.category_id = c.category_id
	  where a.object_id  = ce.event_id 
	  and 	a.context_id = :context_id 
	  and 	pkg.package_id = ce.package_id
	  and	ce.repeat_template_p = 'f' $category_constraint_clause
	  order by $order_by $order_dir
	  LIMIT :row_limit OFFSET :row_offset
	</querytext>
	</fullquery>

	<fullquery name="sql_total_items">
	<querytext>
			select 	count(*) as total_items
			from 	acs_objects a,
				apm_packages pkg,
				ctrl_events ce left outer join ctrl_categories c
			     on ce.category_id = c.category_id
			where 	a.object_id = ce.event_id
			and 	a.context_id = :context_id
			and 	pkg.package_id = ce.package_id
			and	ce.repeat_template_p = 'f'  $category_constraint_clause
	</querytext>
	</fullquery>

</queryset>
