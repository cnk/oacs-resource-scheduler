ad_page_contract {
    Page is generated auto6matically

    @author H, Khy
    @creation-date 2005-12-13
    @cvs-id $Id$

    @param resource_id primary key

} {
    resource_id:naturalnum,optional
    parent_resource_id:naturalnum,optional
    {return_url "resv-resource-list"}
} 

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set event_counter [db_string get_event_counter "" -default 0]
set approval_required_p__options [list {t t} {f f}]
set address_id__options [list {{**COMPLETE ME**} ""}]
set path3 "//Departments"
set department_id__options [crs::ctrl::category::option_list -path $path3 -package_id $package_id]
set path1 "//Equipment Types"
set resource_category_id__options [crs::ctrl::category::option_list -path $path1 -package_id $package_id]
set enabled_p__options [list {t t} {f f}]

# --------------
# Define the form
# ---------------
ad_form -name form_ae -form {
    {resource_id:key {label resource_id_label}} 
    {name:text(inform) {label {name}}}
    {description:text(inform) {label {description}}}
    {resource_category_id:text(inform)}
    {enabled_p:text(inform)}
    {services:text(inform) {label {services}}}
    {property_tag:text(inform) {label {property_tag}}}
    {how_to_reserve:text(inform) {label {How To Reserve}}}
    {approval_required_p:text(inform) {label {Is Approval Required}}}
    {address_id:text(inform) {label {address_id}}}
    {department_id:text(inform) {label {department_id}}}
    {floor:text(inform) {label {floor}}}
    {room:text(inform) {label {room}}}
    {quantity:text(inform) {label {Quantity}}}
    {return_url:text(hidden) {value $return_url}}
    {delete_button:text(submit),optional {label {   Delete Resource   }}}
    {cancel_button:text(submit) {label {   Cancel   }}}
} -edit_request {
# --------------------------------------------------------
# Place code here to populate form variables if editing a
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $resource_id -privilege write

    crs::reservable_resource::get -resource_id $resource_id 
    set form_var_list [list name description resource_category_id enabled_p services property_tag how_to_reserve \
			  approval_required_p address_id department_id floor room quantity]
    foreach var $form_var_list {
	set $var [set resv_resource_info($var)]
    }
    
} -on_submit {
# --------------------------------------------------------
# Place code here to edit a record in a table with non-composite primary key
# ---------------------------------------------------------
if {[empty_string_p $cancel_button]} {
    permission::require_permission -party_id $user_id -object_id $resource_id -privilege write
    set failed_p 0
    db_transaction {
	crs::reservable_resource::delete -resource_id $resource_id
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to delete reservable resource" "A system error ocurred while attempting to delete reservable resource. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }
}
} -after_submit {
# --------------------------------------------------------
# Most common case is to have code that redirects to appropriate page
# ---------------------------------------------------------
    ad_returnredirect $return_url
    ad_script_abort
}

set page_title "Delete a Reservable Resource"

set context [list [list index Administration] [list "$return_url" "Room Detail"] $page_title]

ad_return_template 
