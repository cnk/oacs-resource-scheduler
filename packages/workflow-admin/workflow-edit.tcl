ad_page_contract {

    Workflow Edit page

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: workflow-edit.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {return_url [get_referrer]}
    {workflow_id:integer,notnull}
}

set title "Workflow Edit"

workflow::get -workflow_id $workflow_id -array "wf_info"
set context [list "$wf_info(short_name)"]

db_multirow -extend {edit_url delete_url} get_states get_states {} {
    set edit_url "state-ae?[export_url_vars state_id workflow_id]"
    workflow::state::fsm::get \
	    -state_id $state_id \
	    -array "state_info"
    set msg "You are about to delete $state_info(pretty_name). Are you sure?"
    set delete_url "delete-confirm?[export_url_vars id=$state_id type=state msg]"
}

db_multirow -extend {edit_url delete_url} get_actions get_actions {} {
    set edit_url "action-ae?[export_url_vars action_id workflow_id]"
    workflow::action::fsm::get \
	    -action_id $action_id \
	    -array "action_info"
    set msg "You are about to delete $action_info(pretty_name). Are you sure?"
    set delete_url "delete-confirm?[export_url_vars id=$action_id type=action msg]"
}


db_multirow -extend {edit_url delete_url} get_roles get_roles {} {
    set edit_url "role-ae?[export_url_vars role_id workflow_id]"
    workflow::role::get \
	     -role_id $role_id \
	    -array "role_info"
    set msg "You are about to delete $role_info(pretty_name). Are you sure?"
    set delete_url "delete-confirm?[export_url_vars id=$role_id msg type=role]"
}

set wf_meta_edit "workflow-ae?[export_url_vars workflow_id]"
set add_role_url "role-ae?[export_url_vars workflow_id]"
set add_state_url "state-ae?[export_url_vars workflow_id]"
set add_action_url "action-ae?[export_url_vars workflow_id]"


