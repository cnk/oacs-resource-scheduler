<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.4</version></rdbms>
	<fullquery name="get_events_data">
	<querytext>
	  select ctrl_events.event_id,
		  ctrl_events.title,
		  ctrl_events.capacity,
		  acs_object__name(ctrl_events.event_object_id) as event_object, 
		  to_char(ctrl_events.start_date, 'YYYY/MM/DD HH12:MI AM') as start_date_sort, 
		  to_char(ctrl_events.end_date, 'YYYY/MM/DD HH12:MI AM') as end_date_sort, 
		  to_char(ctrl_events.start_date, 'Mon DD, YYYY HH12:MI AM') as start_date, 
		  to_char(ctrl_events.end_date, 'Mon DD, YYYY HH12:MI AM') as end_date
	  FROM  acs_objects, apm_packages, 
		ctrl_events LEFT OUTER JOIN ctrl_categories
		ON ctrl_events.category_id = ctrl_categories.category_id 
	  WHERE 1=1 $search_constraint AND 
		  apm_packages.package_id = ctrl_events.package_id AND
		  ctrl_events.event_id = acs_objects.object_id AND 
		  acs_objects.context_id = :context_id AND 
		  ctrl_events.repeat_template_p = 'f'
	  ORDER BY $order_by $order_dir
	  LIMIT :row_limit OFFSET :row_offset
	</querytext>
	</fullquery>
	
	<fullquery name="get_object_types">
		<querytext>
			select acs_object__name(object_id) as object_name, object_id  from acs_objects order by object_name asc
		</querytext>
	</fullquery>

</queryset>
