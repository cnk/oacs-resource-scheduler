ad_page_contract {

    Actio nAdd/Edit

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: action-ae.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {return_url [get_referrer]}
    {action_id:optional}
    {workflow_id:notnull}
}


set title "Action Add or Edit"

set context [list [list $return_url "Workflow Edit"] "Action AE"]
set yes_no_options [list [list "Yes" t] [list "No" f]]
set state_options [db_list_of_lists get_states {}]

set trigger_options [list \
	[list "user" "user"] \
	[list "auto" "auto"] \
	[list "init" "init"] \
	[list "time" "time"] \
	[list "message" "message"] \
	[list "workflow" "workflow"] \
	[list "dynamic" "dynamic"] \
	[list "parallel" "parallel"] \
]

ad_form -name "add_edit" -form {
    action_id:key
    {short_name:text(text) {label {Short Name:}}}
    {pretty_name:text(text) {label {Pretty Name:}}}
    {pretty_past_tense:text(text),optional {label {Pretty Past Tense:}}}
    {new_state_id:text(select),optional {options $state_options}}
    {description:text(text),optional {label {Description:}}}
    {trigger_type:text(select),optional {options $trigger_options }}
    {timeout_seconds:text(text),optional }
    {callbacks:text(textarea),optional,nospell {label {Insert or remove callbacks. Put a new callback on a seperate line:}} {html {rows 6 cols 35}}}
    {always_enabled_p:text(radio) {label {Always Enabled?}} {options $yes_no_options}}
    {enabled_states:text(checkbox),multiple,optional {label {Enabled States:}} {options $state_options}}
    {assigned_states:text(checkbox),multiple,optional {label {Assigned States:}} {options $state_options}}
    {sub:text(submit) {label {Submit}}}
} -new_data {

    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name
    set update_array(pretty_past_tense) $pretty_past_tense
    set update_array(description) $description
    set update_array(always_enabled_p) $always_enabled_p
    set update_array(trigger_type) $trigger_type
    set update_array(timeout_seconds) $timeout_seconds
    

    set update_array(enabled_state_ids) $enabled_states
    set update_array(assigned_state_ids) $assigned_states
    set update_array(new_state_id) $new_state_id

    #callbacks
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }

    set update_array(callbacks) $callback_list
    
    set error_p 0
    db_transaction {
	workflow::action::fsm::edit \
		-operation "insert" \
		-action_id $action_id \
		-workflow_id $workflow_id \
		-array "update_array"
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was an error creating the action: <br><br><br> $errmsg"
	ad_script_abort
    }
    
} -edit_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name
    set update_array(pretty_past_tense) $pretty_past_tense
    set update_array(description) $description
    set update_array(always_enabled_p) $always_enabled_p
    set update_array(trigger_type) $trigger_type
    set update_array(timeout_seconds) $timeout_seconds

    set update_array(enabled_state_ids) $enabled_states
    set update_array(assigned_state_ids) $assigned_states
    set update_array(new_state_id) $new_state_id

    #callbacks
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }

    set update_array(callbacks) $callback_list

    set error_p 0

    db_transaction {
	workflow::action::fsm::edit \
		-action_id $action_id \
		-array "update_array"
    } on_error {
	set error_p 1
    }
    
    if {$error_p} {
	ad_return_complaint 1 "There was an error updating the action: <br><br><br> $errmsg"
	ad_script_abort
    }


} -edit_request {
     workflow::action::get \
	    -action_id $action_id \
	    -array "action_info"

    set short_name             $action_info(short_name)
    set pretty_name            $action_info(pretty_name)
    set pretty_past_tense      $action_info(pretty_past_tense)
    set description            $action_info(description)
    set always_enabled_p       $action_info(always_enabled_p)
    set trigger_type           $action_info(trigger_type)
    set timeout_seconds        $action_info(timeout_seconds)

    set enabled_states         $action_info(enabled_state_ids)
    set assigned_states        $action_info(assigned_state_ids)
    set new_state              $action_info(new_state)
    set new_state_id           $action_info(new_state_id)
    set callbacks              [join $action_info(callbacks) "\n"]

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -export {return_url workflow_id} 
