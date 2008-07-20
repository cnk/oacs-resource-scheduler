<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event_image::image.image_upload">
	<querytext>
		update	ctrl_events
		   set	event_image		= empty_blob(),
			event_image_file_type	= :event_image_file_type,
			event_image_width	= :event_image_width,
			event_image_height	= :event_image_height
		where	event_id		= :event_id
		returning event_image into :1
	</querytext>
</fullquery>

<fullquery name="ctrl_event_image::ctrl_event_object_image.image_upload">
	<querytext>
		update	ctrl_events_objects
		   set	image		= empty_blob(),
			image_file_type	= :image_file_type,
			image_width	= :image_width,
			image_height	= :image_height
		where	event_object_id	= :event_object_id
		returning image into :1
	</querytext>
</fullquery>

</queryset>
