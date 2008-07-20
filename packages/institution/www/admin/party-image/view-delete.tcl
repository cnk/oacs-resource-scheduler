# /packages/institution/www//personnel-new/photo-delete.tcl
ad_page_contract {

    Deletes a party image

    @author        avni@avni.net
    @creation-date 2003-09-03
    @cvs-id$

    @param personnel_id	person's photo to delete
} {
    {personnel_id:integer,notnull}
}

db_transaction {
    db_dml inst_personnel_photo_delete {
	update inst_personnel
	set    photo_width  = null,
	       photo_height = null,
               photo_type   = null,
               photo        = empty_blob()
	where  personnel_id = :personnel_id
    }
}

db_release_unused_handles
ad_returnredirect "personnel-ae?[export_url_vars personnel_id]"
