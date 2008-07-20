set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

if ![info exists subdir] {
    set subdir ""
}

permission::require_permission -party_id $user_id -object_id $context_id -privilege read

#set resource_name [db_string get_resource_name {} -default ""]
set action edit

set images [db_list_of_lists list_images {}]
if {[llength $images] >= 1} {
    set image_id [lindex [lindex $images 0] 0] 
    set image "<img width=160px height=120px src=${subdir}image-display?[export_url_vars image_id] border=0></a>"
 } else {
    set image "<img width=160px height=120px src=not-available.jpg border=0></a>"    
}

ad_return_template 
  

