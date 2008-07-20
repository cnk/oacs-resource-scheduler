<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="get_event_data">
		<querytext>
			select	event_id,
				event_object_id,
				repeat_template_id,
				repeat_template_p,
				title,
				to_char(start_date, 'YYYY MM DD HH12 MI AM') as start_date,
				to_char(end_date, 'YYYY MM DD HH12 MI AM') as end_date,
				all_day_p,
				location,
				notes,
				capacity
			from 	ctrl_events
			where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_object_types">
		<querytext>
			select acs_object.name(object_id) as object_name, object_id  from acs_objects where rownum < 20 order by object_name asc
		</querytext>
	</fullquery>

	<fullquery name="get_repeat_end_date">
		<querytext>
			select to_char(add_months(to_date(:repeat_end_date_str, 'YYYY MM DD HH24 MI'), 300), 'YYYY MM DD HH24 MI PM') as new_date from dual
		</querytext>
	</fullquery>

    <fullquery name="get_type_options">
        <querytext>
       select  distinct c.name,
	       category_id
       from crs_resv_resources_vw v,
	    ctrl_categories c
       where v.resource_category_id=c.category_id
        </querytext>
    </fullquery>
</queryset>
