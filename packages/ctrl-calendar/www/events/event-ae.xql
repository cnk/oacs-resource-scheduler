<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="get_event_data">
		<querytext>
			select	event_id,
				event_object_id,
				category_id,
				repeat_template_id,
				repeat_template_p,
				title,
				speakers,
				to_char(start_date, 'YYYY MM DD HH24 MI') as start_date,
				to_char(end_date, 'YYYY MM DD HH24 MI') as end_date,
				all_day_p,
				location,
				notes,
				capacity,
				event_image_caption
			from 	ctrl_events
			where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="get_object_types">
		<querytext>
			select acs_object.name(object_id) as object_name, object_id  from acs_objects where rownum < 20 order by object_name asc
		</querytext>
	</fullquery>

	<fullquery name="today_date">
		<querytext>
		    select to_char(sysdate,'yyyy mm dd hh24') || ' 0' from dual
		</querytext>
	</fullquery>

	<fullquery name="today_date_end">
		<querytext>
		    select to_char(sysdate + 0.04167,'yyyy mm dd hh24') || ' 0' from dual
		</querytext>
	</fullquery>

        <fullquery name="category_values">
                <querytext>
	                select category_id from ctrl_calendar_event_categories where event_id=:event_id
                </querytext>
        </fullquery>

    <fullquery name="get_event_calendar_ids">
	<querytext>
		select 	cc.cal_id
		from 	ctrl_calendars cc, 
			ctrl_calendar_event_map ccem 
		where 	ccem.event_id 	= :event_id 
		and 	ccem.cal_id 	= cc.cal_id	
	</querytext>
    </fullquery>

</queryset>
