ad_page_contract {
    Page is generated auto6matically

    @author H, Khy
    @creation-date 2005-12-13
    @cvs-id $Id$

    @param resource_id primary key

} {
    resource_id:naturalnum,optional
    {parent_resource_id:naturalnum,optional ""}
    {return_url "resv-resource-list"}
} 

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id
if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set approval_required_p__options [list {Yes t} {No f}]
set address_id__options [crs::resource::get_ctrl_addresses]
set address_list [concat [list [list {Select One ...} ""]] $address_id__options]
set path3 "//Departments"
set department_id__options [crs::ctrl::category::option_list -path $path3 -package_id $package_id]
set department_list [concat [list [list {Select One ...} ""]] $department_id__options]
set path1 "//Equipment Types"
set resource_category_id__options [crs::ctrl::category::option_list -path $path1 -package_id $package_id]
set resource_list [concat [list [list {Select One ...} ""]] $resource_category_id__options]
set enabled_p__options [list {Yes t} {No f}]

#if {[exists_and_not_null resource_id]} {
#    set submit_btn "Edit Reservable Resource"
#} else {
#    set submit_btn "Add Reservable Resource"
#}
# --------------
# Define the form
# ---------------
ad_form -name form_ae -form {
    {resource_id:key {label resource_id_label}} 
    {name:text(text) {label {name}} {html {size 50 maxlength 1000}}} 
    {description:text(textarea),optional {label {description}} {html {rows 4 cols 50}}} 
    {resource_category_id:naturalnum(select),optional {label {resource_category_id}} {options $resource_list}} 
    {enabled_p:text(radio),optional {label {enabled_p}} {options $enabled_p__options}} 
    {services:text(text),optional {label {services}} {html {size 50 maxlength 4000}}} 
    {property_tag:text(text),optional {label {property_tag}} {html {size 50 maxlength 1000}}} 
    {how_to_reserve:text(text),optional {label {How To Reserve}} {html {size 50 maxlength 4000}}} 
    {approval_required_p:text(radio) {label {Is Approval Required}} {options $approval_required_p__options}} 
    {address_id:naturalnum(select),optional {label {address_id}} {options $address_list}} 
    {department_id:naturalnum(select),optional {label {department_id}} {options $department_list}} 
    {floor:text(text) {label {floor}} {html {size 5 maxlength 100}}} 
    {room:text(text) {label {room}} {html {size 5 maxlength 100}}} 
    {quantity:text(text) {label {Quantity}} {html {size 5 maxsize 5}}}
    {submit_button:text(submit) }
} -validate {
    {quantity {([string is integer -strict $quantity]) || ($quantity=="multiple")} "Please enter a valid number or multiple"}
} -new_request {
# --------------------------------------------------------
# Place code here to populate form variables if adding a new
# record in a single column primary key table
# ---------------------------------------------------------
    if [empty_string_p $parent_resource_id] {
	permission::require_permission -party_id $user_id -object_id $package_id -privilege create
    } 
    set quantity 1
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
# Place code here to
# 1. Work with tables that have composite keys 
# 2. Massage data before processing occurrs in the -new_data or edit_data section
# 3. validate form elements and throw validations errors
# (i.e. template::form::set_error add_edit_form form_widget "widget error unable to process"
#	break 
# )
# ---------------------------------------------------------

} -new_data {
# --------------------------------------------------------
# Place code here to to add a record in a table with non-composite primary key
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $context_id -privilege create
    
    set failed_p 0
    db_transaction {
	set resource_id [crs::reservable_resource::new -name $name -resource_category_id $resource_category_id \
			     -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag \
			     -how_to_reserve $how_to_reserve -approval_required_p $approval_required_p \
			     -address_id $address_id -department_id $department_id -floor $floor -room $room \
			     -quantity $quantity -parent_resource_id $parent_resource_id]
        crs::resource::rel_add -subsite_id $subsite_id -object_id $resource_id
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new reservable resource. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }

} -edit_data {
# --------------------------------------------------------
# Place code here to edit a record in a table with non-composite primary key
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $resource_id -privilege admin
    set failed_p 0
    db_transaction {
	set resource_id [crs::reservable_resource::update -resource_id $resource_id -name $name -resource_category_id $resource_category_id \
			     -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag \
			     -how_to_reserve $how_to_reserve -approval_required_p $approval_required_p \
			     -address_id $address_id -department_id $department_id -floor $floor -room $room  \
			     -quantity $quantity]
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new reservable resource. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }

} -after_submit {
# --------------------------------------------------------
# Most common case is to have code that redirects to appropriate page
# ---------------------------------------------------------
    ad_returnredirect $return_url
    ad_script_abort
}  -export [list parent_resource_id return_url]


if [ad_form_new_p -key resource_id] {
    set page_title "Add Reservable Equipment"
    set submit_btn "Add Reservable Resource"
} else {
    set page_title "Edit Reservable Equipment"
    set submit_btn "Edit Reservable Resource"
}   

set room_id $parent_resource_id
set context [list $page_title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]

ad_return_template 
  

