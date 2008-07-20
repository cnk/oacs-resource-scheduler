<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_monthly_events">
	 <querytext>
		select	distinct
				ce.event_id,
				ce.title										as event_title,
				ce.speakers,
				dbms_lob.substr(ce.notes,3000)					as event_notes,
				ce.location										as event_location,
				ce.start_date,
				to_char(ce.start_date,		'Month DD, YYYY ')
				|| to_char(ce.start_date,	'FMHH12')
				|| to_char(ce.start_date,	':MI AM')			as event_start_date,
				to_char(ce.start_date,		'Month DD, YYYY')	as event_start_date_no_time,
				to_char(ce.end_date,		'Month DD, YYYY ')
				|| to_char(ce.end_date,		'FMHH12')
				|| to_char(ce.end_date,		':MI AM')			as event_end_date,
				to_char(ce.end_date,		'Month DD, YYYY')	as event_end_date_no_time,
				ce.all_day_p,
				ce.capacity,
				ce.event_image_width,
				ce.event_image_height,
				ce.event_image_caption,
				ce.status as current_status
		  from	ctrl_events				ce,
				ctrl_calendars			cc,
				ctrl_calendar_event_map	ccem
				$table_constraint
		 where	ce.repeat_template_p	= 'f'
		   and	cc.cal_id				= ccem.cal_id
		   and	cc.cal_id				= cc.object_id
		   and	cc.owner_id				is null
		   and	ccem.event_id			= ce.event_id
				$year_month_constraint
				$search_constraint
				$filter_constraint
		 order	by ce.start_date
	 </querytext>
	</fullquery>

	<fullquery name="get_event_calendar_names">
	 <querytext>
		select	cc.cal_name
		  from	ctrl_calendars			cc,
				ctrl_calendar_event_map	ccem
		 where	ccem.event_id	= :event_id
		   and	ccem.cal_id		= cc.cal_id
	 </querytext>
	</fullquery>
</queryset>
