ad_page_contract {
    Page is generated auto6matically

    @author H, Khy
    @creation-date 2005-12-13
    @cvs-id $Id$

    @param resource_id primary key

} {
    resource_id:naturalnum,optional
    parent_resource_id:naturalnum,optional
    {return_url "resource-list"}
} 


set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set resource_category_id__options [crs::resource::get_resource_categories]
set resource_list [concat [list [list {Select One ...} ""]] $resource_category_id__options]
set enabled_p__options [list {Yes t} {No f}]

#if {[exists_and_not_null resource_id]} {
#    set submit_btn "Edit"
#} else {
#    set submit_btn "Add"
#}

# --------------
# Define the form
# ---------------
ad_form -name form_ae -html {enctype multipart/form-data} -form {
    {resource_id:key {label resource_id_label}} 
    {name:text(text) {label {Name}} {html {size 50 maxlength 1000}}} 
    {description:text(textarea),optional {label {Description}} {html {rows 4 cols 50}}} 
    {resource_category_id:naturalnum(select),optional {label {Resource Type}} {options $resource_list}} 
    {enabled_p:text(radio) {label {Enabled}} {options $enabled_p__options}} 
    {services:text(text),optional {label {Services}} {html {size 50 maxlength 4000}}} 
    {property_tag:text(text),optional {label {Property Tag}} {html {size 50 maxlength 1000}}} 
    {quantity:naturalnum(text) {label {Quantity}} {html {size 3 maxsize 5}}}
    {submit_button:text(submit)}
} -new_request {
# --------------------------------------------------------
# Place code here to populate form variables if adding a new
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $parent_resource_id -privilege create
    set quantity 1

} -edit_request {
# --------------------------------------------------------
# Place code here to populate form variables if editing a
# record in a single column primary key table
# ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $parent_resource_id -privilege write
    set form_var_list [list name description resource_category_id enabled_p services property_tag quantity]
    crs::resource::get -resource_id $resource_id -column_array resource_info

    foreach var $form_var_list {
	set $var [set resource_info($var)]
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
	set resource_id [crs::resource::new -name $name -resource_category_id $resource_category_id \
			     -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag \
			     -quantity $quantity -parent_resource_id $parent_resource_id]
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new resource. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }
} -edit_data {
# --------------------------------------------------------
# Place code here to edit a record in a table with non-composite primary key
# ---------------------------------------------------------
   permission::require_permission -party_id $user_id -object_id $resource_id -privilege write
   set failed_p 0
   db_transaction {
       crs::resource::update -resource_id $resource_id -name $name -resource_category_id $resource_category_id \
	   -description $description -enabled_p $enabled_p -services $services -property_tag $property_tag -quantity $quantity
   } on_error {
       set failed_p 1
   }
   if $failed_p {
       ad_return_error "System failed to update resource" "A system error ocurred while attempting to add new resource. Reason: <pre>$errmsg</pre>"
       ad_script_abort
   }
} -after_submit {
# --------------------------------------------------------
# Most common case is to have code that redirects to appropriate page
# ---------------------------------------------------------
    ad_returnredirect $return_url
} -export [list parent_resource_id return_url]

if [ad_form_new_p -key resource_id] {
    set page_title "Add Fix Equipment"
    set submit_btn "Add"
} else {
    set page_title "Edit Fix Equipment"
    set submit_btn "Edit"
} 

set room_id $parent_resource_id
set context [list [list index Administration] [list [export_vars -base room room_id] "Room Detail"] $page_title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title -manage_p 1]




ad_return_template 
  

