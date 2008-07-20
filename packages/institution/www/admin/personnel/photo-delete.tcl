# /packages/institution/www//personnel-new/photo-delete.tcl	-*- tab-width: 4 -*-
ad_page_contract {
	Display details about personnel.

	@author		   avni@avni.net
	@creation-date 2003-09-03
	@cvs-id$

	@param personnel_id	person's photo to delete
} {
	{personnel_id:integer,notnull}
	{return_url	[get_referrer]}
}


permission::require_permission -object_id $personnel_id -privilege write
db_transaction {
	db_dml inst_personnel_photo_delete {
		update	inst_personnel
		   set	photo_width		= null,
				photo_height	= null,
				photo_type		= null,
				photo			= empty_blob()
		 where	personnel_id	= :personnel_id
	}
}

if {[exists_and_not_null return_url]} {
	template::forward $return_url
} else {
	template::forward "personnel-ae?[export_url_vars personnel_id]"
}

