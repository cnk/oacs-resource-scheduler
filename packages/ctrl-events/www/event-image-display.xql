<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="event_image_file_type">
		<querytext>
			select	event_image_file_type
			from	ctrl_events
			where	event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="event_show_image">
		<querytext>
			select 	event_image
			from	ctrl_events
			where	event_id = $event_id
		</querytext>
	</fullquery>
</queryset>
