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
# --------------
# Define the form
# ---------------
ad_form -name "form_ae" -form {
    {request_id:key             {label resource_id_label}} 
    {name:text(inform)          {label {Name}} {html {size 50 maxlength 1000}}} 
    {description:text(inform)   {label {Description}} {html {rows 4 cols 50}}} 
    {status:text(inform)        {label {Status}} {options { $status_type_options {Approved approved} {Denied denied} {Pending pending} {Cancelled, cancelled}}} {html {size 1}}}
    {requested_by:text(inform)  {label {Requested by}}}
    {reserved_by:text(hidden)   {value $user_id}}
    {delete_button:text(submit) {label {   Delete Request   }}}
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
    # Place code here to edit a record in a table with non-composite primary key
    # ---------------------------------------------------------
   permission::require_permission -party_id $user_id -object_id $request_id -privilege write
   set failed_p 0
   db_transaction {
       crs::request::delete -request_id $request_id

   } on_error {
       set failed_p 1
   }
   if $failed_p {
       ad_return_error "System failed to delete resource" "A system error ocurred while attempting to delete the request. Reason: <pre>$errmsg</pre>"
       ad_script_abort
   }
} -after_submit {
    # --------------------------------------------------------
    # Most common case is to have code that redirects to appropriate page
    # ---------------------------------------------------------
    ad_returnredirect index
} -export [list return_url]

set page_title "Delete Request"

set context [list [list index Resources] [list request-list "Request List"] $page_title]
ad_return_template

