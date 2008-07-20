ad_page_contract {

    Add A New Request into the DB

    @author jeff@ctrl.ucla.edu (JW)
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005-12-18
    @cvs-id $Id$

    @param request_id primary key

} {
    request_id:naturalnum,optional
    {return_url [get_referrer]}
} 

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set context_id $package_id

# --------------
# Initialize the list option list for selects and radios    
# ---------------
set yes_no_options [list [list "No" 0] [list "Yes" 1] ]
#set resource_type_options [list [list "Select One ..." -1]]
#set  resource_type_options [concat $resource_type_options [db_list_of_lists get_type_options {}]]
set js_code [crs::util::build_branch_js]
set status_type_options [list [list "Select One ..." -1]]

if {[exists_and_not_null request_id]} {
    set submit_btn "Edit Request"
} else {
    set submit_btn "Add Request"
}

# --------------
# Define the form
# ---------------
ad_form -name "form_ae" -form {
    {request_id:key                      {label resource_id_label}} 
    {name:text(text)                     {label {Name}} {html {size 50 maxlength 1000}}} 
    {description:text(textarea),optional {label {Description}} {html {rows 4 cols 50}}} 
    {status:text(select)                 {label {Status}} {options { $status_type_options {Approved approved} {Denied denied} {Pending pending} {Cancelled, cancelled}}} {html {size 1}}}
    {requested_by:text                   {label {Requested by}}}
    {reserved_by:text(hidden)            {value $user_id}}
    {submit_button:text(submit) {label {    $submit_btn     }}}
} -new_request {
    # --------------------------------------------------------
    # Place code here to populate form variables if adding a new
    # record in a single column primary key table
    # ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $context_id -privilege create
    set quantity 1

} -edit_request {
    # --------------------------------------------------------
    # Place code here to populate form variables if editing a
    # record in a single column primary key table
    # ---------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $request_id -privilege write
    set form_var_list [list name description status requested_by]
    crs::request::get -request_id $request_id -column_array request_info

    foreach var $form_var_list {
    	set $var [set request_info($var)]
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
	set request_id [crs::request::new -request_id $request_id -name $name -description $description -status $status -reserved_by $reserved_by -requested_by $requested_by]
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	ad_return_error "System failed to add request" "A system error ocurred while attempting to add new request. Reason: <pre>$errmsg</pre>"
	ad_script_abort
    }
} -edit_data {
    # --------------------------------------------------------
    # Place code here to edit a record in a table with non-composite primary key
    # ---------------------------------------------------------
   permission::require_permission -party_id $user_id -object_id $request_id -privilege write
   set failed_p 0
   db_transaction {
       crs::request::update -request_id $request_id -name $name -description $description -status $status -reserved_by $reserved_by -requested_by $requested_by

   } on_error {
       set failed_p 1
   }
   if $failed_p {
       ad_return_error "System failed to update resource" "A system error ocurred while attempting to update the request. Reason: <pre>$errmsg</pre>"
       ad_script_abort
   }
} -after_submit {
    # --------------------------------------------------------
    # Most common case is to have code that redirects to appropriate page
    # ---------------------------------------------------------
    ad_returnredirect index
} -export [list return_url]

if [ad_form_new_p -key request_id] {
    set page_title "New Request"
} else {
    set page_title "Edit Request"
}

set context [list [list index Resources] [list request-list "Request List"] $page_title]
ad_return_template

