ad_page_contract {
    Page to delete the resource

    @param resource_id
    @param return_url

    @author reye@mednet.ucla.edu
    @creation-date 12/15/2005
    @cvs-id $Id

} {
    {resource_id:naturalnum,notnull}
    {return_url ""}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set resource_category_id__options [crs::resource::get_resource_categories]
set enabled_p__options [list {t t} {f f}]

# --------------
# Define the form
# ---------------
ad_form -name form_ae -html {enctype multipart/form-data} -form {
    {resource_id:key {label resource_id_label}} 
    {name:text(inform) {label {Name}} {html {size 50 maxlength 1000}}} 
    {description:text(inform) {label {Description}}} 
    {resource_category_id:text(inform) {label {Resource Type}}} 
    {enabled_p:text(inform) {label {Enabled}}} 
    {services:text(inform) {label {Services}}} 
    {property_tag:text(inform) {label {Property Tag}}}
    {quantity:text(inform) {label {Quantity}}}
    {return_url:text(hidden) {value $return_url}}
    {delete_button:text(submit) {label {   Delete Resource   }}}
} -edit_request {
# --------------------------------------------------------
# Place code here to populate form variables if editing a
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $resource_id -privilege write
    set form_var_list [list name description resource_category_id enabled_p services property_tag quantity]
    crs::resource::get -resource_id $resource_id -column_array resource_info

    foreach var $form_var_list {
	set $var [set resource_info($var)]
    }

} -on_submit {
    permission::require_permission -party_id $user_id -object_id $resource_id -privilege write
   set failed_p 0
    db_transaction {
	crs::resource::delete -resource_id $resource_id
    } on_error {
	set failed_p 1
    }

    if {$failed_p} {
	ad_return_error "System failed to delete resource" "A system error ocurred while attempting to delete resource. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }

} -after_submit {
    ad_returnredirect $return_url
}


set page_title "Delete a Resource"

set context [list [list index Administration] [list "$return_url" "Room Detail"] $page_title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]



ad_return_template 
  

