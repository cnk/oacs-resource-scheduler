# /ctrl-resource/www/image-delete.tcl

ad_page_contract {
    delete image
    @creation-date 12/16/06
    @cvs-id $Id:$
} {
    image_id:naturalnum,notnull
    {return_url [get_referrer]}
} 

crs::resource::delete_image -image_id $image_id

ad_returnredirect $return_url
