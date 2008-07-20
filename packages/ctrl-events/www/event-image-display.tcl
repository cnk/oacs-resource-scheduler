# /ctrl-events/www/event-image-display.tcl

ad_page_contract {
    Return 

    @creation-date 08/08/2005
    @cvs-id $Id
} {
    event_id:naturalnum,notnull
}

set file_type [db_string event_image_file_type {} -default ""]


if {[empty_string_p [string trim $file_type]]} {
    ad_return_error "Couldn't find image" "The image you selected is no longer in the db. Please
    contact <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you have
    any questions."
    return
}

ReturnHeaders $file_type

db_write_blob event_show_image {}

db_release_unused_handles
