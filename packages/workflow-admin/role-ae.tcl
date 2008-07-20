ad_page_contract {

    State Add/Edit

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: role-ae.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {return_url [get_referrer]}
    {role_id:optional}
    {workflow_id:notnull}
}

set title "State Add or Edit"
set context [list [list $return_url "Workflow Edit"] "Role AE"]


ad_form -name "add-edit" -form {
    role_id:key
    {short_name:text(text) {label {Short Name:}}}
    {pretty_name:text(text) {label {Pretty Name:}}}
    {callbacks:text(textarea),optional,nospell {label {Insert or remove callbacks. Put a new callback on a seperate line:}} {html {rows 6 cols 35}}}
    {sub:text(submit) {label {Submit}}}
} -new_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name

    #callbacks
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }
    
    set update_array(callbacks) $callback_list
    
    workflow::role::edit \
	    -operation "insert" \
	    -workflow_id $workflow_id \
	    -array "update_array"

} -edit_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name

    #callbacks
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }
    
    set update_array(callbacks) $callback_list
    workflow::role::edit \
	    -role_id $role_id \
	    -array "update_array"
    
} -edit_request {

    workflow::role::get \
	    -role_id $role_id \
	    -array "role_info"

    set short_name       $role_info(short_name)
    set pretty_name      $role_info(pretty_name)
    set callbacks              [join $role_info(callbacks) "\n"]

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -export {return_url workflow_id} 
