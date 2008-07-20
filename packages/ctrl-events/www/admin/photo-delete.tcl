# /packages/institution/www//personnel-new/photo-delete.tcl	-*- tab-width: 4 -*-
ad_page_contract {
	Display details about personnel.

	@author		   avni@avni.net
	@creation-date 2003-09-03
	@cvs-id$

	@param personnel_id	person's photo to delete
} {
	{event_id:integer,notnull}
	{return_url	[get_referrer]}
}

db_transaction {
	db_dml ctrl_events_photo_delete {
		update  ctrl_events
		   set	event_image_width = null,
				event_image_height = null,
				event_image_file_type = null,
		        event_image_caption = null,
				event_image	= empty_blob()
		 where	event_id	= :event_id
	}
}

if {[exists_and_not_null return_url]} {
	template::forward $return_url
} else {
	template::forward "event-ae?[export_url_vars event_id]"
}

