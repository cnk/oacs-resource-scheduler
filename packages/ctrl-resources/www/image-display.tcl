# /ctrl-resource/www/image-display.tcl
ad_page_contract {
    display image
    @creation-date 12/16/06
    @cvs-id $Id:$
} {
    image_id:naturalnum,notnull
} 

set image_file_type [db_string get_image_file_type {} -default ""]
if {[empty_string_p [string trim $image_file_type]]} {
    ad_return_error "Couldn't find image" "The image you selected is no longer in the db. Please
    contact <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you have
    any questions."
    return
}

ReturnHeaders $image_file_type
db_write_blob show_image {}
db_release_unused_handles
