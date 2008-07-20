<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="sql_total_items">
		<querytext>
			select 	count(*) as total_items
			from 	ctrl_events, acs_objects, apm_packages
			where 	1=1 $search_constraint and
				acs_objects.context_id = :context_id and 
				apm_packages.package_id = ctrl_events.package_id and
				ctrl_events.event_object_id = acs_objects.object_id and
                                ctrl_events.repeat_template_p = 'f'
		</querytext>
	</fullquery>

        <fullquery name="rsvp_count">
                <querytext>
                        select  count(*) as rsvp
                        from    ctrl_events, ctrl_events_attendees
                        where   ctrl_events.event_id = ctrl_events_attendees.rsvp_event_id
                </querytext>
        </fullquery>

        <fullquery name="rsvp_admin_count">
                <querytext>
                        select  rsvp_event_id as rsvp
                        from    ctrl_events_rsvps
                        where   rsvp_event_id = :event_id
                </querytext>
        </fullquery>


	<fullquery name="get_user">
	<querytext>
		select	pt.email as user_email,
				ps.first_names as user_fname,
				ps.last_name as user_lname
		from 	persons ps, parties pt
		where ps.person_id = :user_id and pt.party_id =:user_id
	</querytext>
	</fullquery>

	<fullquery name="get_events_data">
	<querytext>
	select * from 
		(select event_id, title, capacity, event_object, start_date_sort,
		 end_date_sort, start_date, end_date, rownum as row_num from 
			(select * from
				(select ctrl_events.event_id,
					ctrl_events.title,
					ctrl_events.capacity,
					acs_object.name(ctrl_events.event_object_id) as event_object, 
					to_char(ctrl_events.start_date, 'YYYY/MM/DD HH12:MI AM') as start_date_sort, 
      				to_char(ctrl_events.end_date, 'YYYY/MM/DD HH12:MI AM') as end_date_sort, 
					to_char(ctrl_events.start_date, 'Mon DD, YYYY HH12:MI AM') as start_date, 
					to_char(ctrl_events.end_date, 'Mon DD, YYYY HH12:MI AM') as end_date
				FROM  ctrl_events, acs_objects, apm_packages, ctrl_categories
				where 1=1 $search_constraint and 
					apm_packages.package_id = ctrl_events.package_id and
					ctrl_events.event_id = acs_objects.object_id and 
					acs_objects.context_id = :context_id and 
					ctrl_events.category_id = ctrl_categories.category_id(+) and
					ctrl_events.repeat_template_p = 'f') inner_table 
			order by $order_by $order_dir) table_name
		) outter_table
	where (row_num >= :lower_bound and row_num <= :upper_bound) 
	</querytext>
	</fullquery>
	
	<fullquery name="get_object_types">
		<querytext>
			select acs_object.name(object_id) as object_name, object_id  from acs_objects order by object_name asc
		</querytext>
	</fullquery>


</queryset>
