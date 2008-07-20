<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="search_result">
		<querytext>
			select	event_id,
				title,
				to_char(start_date, 'YYYY MM DD HH12 MI AM') as start_date,
				to_char(end_date, 'YYYY MM DD HH12 MI AM') as end_date,
				location,
				capacity
			from 	ctrl_events
			where event_object_id = :search_object
		</querytext>
	</fullquery>
</queryset>
