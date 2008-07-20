ad_page_contract {
    Page to delete the room

    @param room_id
    @param return_url

    @author jmhek@cs.ucla.edu
    @creation-date 12/15/2005
    @cvs-id $Id:$
} {
    {room_id:naturalnum,notnull}
    {return_url [get_referrer]}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

permission::require_permission -party_id $user_id -object_id $room_id -privilege write

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set resource_category_id__options [crs::resource::get_resource_categories]
set enabled_p__options [list {t t} {f f}]
set flag 0

# --------------
# Define the form
# ---------------
ad_form -name form_ae -html {enctype multipart/form-data} -form {
    {room_id:key {label room_id_label}} 
    {name:text(inform) {label {Name}} {html {size 50 maxlength 1000}}} 
    {description:text(inform) {label {Description}}} 
    {resource_category_id:text(inform) {label {Resource Type}}} 
    {enabled_p:text(inform) {label {Enabled}}} 
    {services:text(inform) {label {Services}}} 
    {property_tag:text(inform) {label {Property Tag}}}
    {quantity:text(inform) {label {Quantity}}}
    {no_resources:text(inform) {label {# of Resources}}}
    {no_requests:text(inform) {label {# of Requests}}}
    {no_images:text(inform) {label {# of Images}}}
    {return_url:text(hidden) {value $return_url}}
    {delete_button:text(submit) {label {Delete}}}
    {cancel_button:text(submit) {label {Cancel}}}
} -edit_request {
# --------------------------------------------------------
# Place code here to populate form variables if editing a
# record in a single column primary key table
# ---------------------------------------------------------
    set form_var_list [list name description resource_category_id enabled_p services property_tag quantity]
    crs::resource::get -resource_id $room_id -column_array resource_info

    set no_resources [db_string resources_in_room {} -default 0]
    set no_requests [db_string requests_in_room {} -default 0]
    set no_images [db_string images_in_room {} -default 0]

    set warning ""
    if {$no_requests != 0} {
	set warning "Please delete room requests from this room first."
	set flag 1
    } elseif {$no_resources != 0 || $no_images != 0} {
	set warning "If you delete this room, the resources and images in this room will also be deleted. Are you sure?"
    }

    foreach var $form_var_list {
	set $var [set resource_info($var)]
    }

} -on_submit {
    set failed_p 0

    if {[empty_string_p $cancel_button] && ($no_requests==0)} {
	db_transaction {
	    crs::room::delete -room_id $room_id
	} on_error {
	    set failed_p 1
	}

	if {$failed_p} {
	    ad_return_error "System failed to delete resource" "A system error ocurred while attempting to delete the resource. Reason: <pre>$errmsg</pre>"
	    ad_script_abort
	}

	set return_url ""
    }

} -after_submit {
    ad_returnredirect $return_url
}

set page_title "Delete a Room"

set context [list [list index Administration] [list [export_vars -base room room_id] "Room Detail"] "Delete"] 
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]

ad_return_template 
