ad_page_contract {

    Actio Add/Edit

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: workflow-meta-edit.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {return_url [get_referrer]}
    {workflow_id:notnull}
}



set title "Edit"
set context [list [list $return_url "Workflow Edit"] "Edit Metadata"]

ad_form -name "add-edit" -form {
    workflow_id:key
    {short_name:text(text) {label {Short Name:}}}
    {pretty_name:text(text) {label {Pretty Name:}}}
    {callbacks:text(textarea),nospell,optional {label {Insert or remove callbacks. Put a new callback on a seperate line:}} {html {rows 6 cols 35}}}
} -new_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name
    
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }

    if {[llength $callback_list] != 0} {
	set update_array(callbacks) $callback_list
    }
    
    set error_p 0
    db_transaction {
	workflow::edit \
		-operation "insert"
		-workflow_id $workflow_id \
		-array update_array
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was an error creating the workflow: <br><br><br> $errmsg"
	ad_script_abort
    }


} -edit_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name

    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }

    if {[llength $callback_list] != 0} {
	set update_array(callbacks) $callback_list
    }
    
    set error_p 0
    db_transaction {
	workflow::edit \
		-workflow_id $workflow_id \
		-array update_array
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was an error updating the workflow: <br><br><br> $errmsg"
	ad_script_abort
    }

} -edit_request {
    workflow::get -workflow_id $workflow_id -array "wf_info"
    set short_name $wf_info(short_name)
    set pretty_name $wf_info(pretty_name)
    set callbacks $wf_info(callbacks)
    set callbacks [join $callbacks "\n"]
} -after_submit {
    ad_returnredirect $return_url
} -export {return_url}
