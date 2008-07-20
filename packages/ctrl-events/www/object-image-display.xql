<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="image_file_type">
		<querytext>
			select	image_file_type
			from	ctrl_events_objects
			where	event_object_id = :event_object_id
		</querytext>
	</fullquery>

	<fullquery name="show_image">
		<querytext>
			select 	image
			from	ctrl_events_objects
			where	event_object_id = $event_object_id
		</querytext>
	</fullquery>
</queryset>
