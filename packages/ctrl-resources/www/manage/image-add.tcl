ad_page_contract {
    Page is generated auto6matically

    @author jmhek@cs.ucla.edu
    @creation-date 2005-12-16
    @cvs-id $Id:$

    @param resource_id primary key
} {
    resource_id:naturalnum
    {return_url ""}
} 

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $resource_id -privilege write

set package_id [ad_conn package_id]
set context_id $package_id


set resource_name [db_string get_resource_name {} -default ""]
ad_form -name image_add -html {enctype multipart/form-data} -form {
    {resource_image:text(file),optional {label "Image for \"$resource_name\""} {html {size 50}}}
    {image_name:text(text),optional {label "Name"}}
    {submit_button:text(submit) {label {    Upload Image     }}}
} -validate {
    {resource_image {[string tolower [file extension $resource_image]] == ".gif" ||
                     [string tolower [file extension $resource_image]] == ".jpe" ||
                     [string tolower [file extension $resource_image]] == ".jpg" ||
                     [string tolower [file extension $resource_image]] == ".jpeg"} "Only gif and jpeg images supported"}
} -on_submit {
    permission::require_permission -party_id $user_id -object_id $context_id -privilege create
    set failed_p 0
    if {![empty_string_p $resource_image]} {
	db_transaction {
	    crs::resource::add_image -resource_id $resource_id -resource_image $resource_image -image_name $image_name
	} on_error {
	    set failed_p 1
	}
	if $failed_p {
	    ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new resource. Reason: <pre>$errmsg</pre>"
	    ad_script_abort
	}
    }
} -after_submit {
    if [empty_string_p $return_url] {
	ad_returnredirect image-add?[export_url_vars resource_id]
    } else {
	ad_returnredirect $return_url
    }
    ad_script_abort

} -export [list resource_id return_url]

set page_title "Add a Image"
set room_id $resource_id
set context [list [list index Administration] [list [export_vars -base room room_id] "Room Detail"] $page_title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]

ad_return_template 
  

