set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

if ![info exists subdir] {
    set subdir ""
}

if ![info exists manage_p] {
    set manage_p 0
}


permission::require_permission -party_id $user_id -object_id $context_id -privilege read

#set resource_name [db_string get_resource_name {} -default ""]
set action edit

db_multirow -extend {image delete_link} list_images list_images {} {
    if {![empty_string_p $image_height] && ![empty_string_p $image_width]} {
	if {$image_width > 250} {
	    set image_height [expr $image_height * 250]
	    set image_height [expr $image_height / $image_width]
	    set image_width 250
	}
	set image "<img width=[expr $image_width] height=[expr $image_height] \
					src=${subdir}image-display?[export_url_vars image_id] border=0></a>"
    } else {
	set image "Cannot display"
    }
    set delete_link "<a href = '${subdir}image-delete?[export_url_vars image_id]'>Delete</a>"
}

ad_return_template 
  

