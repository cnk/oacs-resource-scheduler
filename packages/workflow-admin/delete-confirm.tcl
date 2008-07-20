ad_page_contract {

    State Add/Edit

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: delete-confirm.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $

    @param type The type to delete, either state, role,  action, or workflow
} {
    {return_url [get_referrer]}
    {id:notnull}
    {type:notnull}
    {msg:notnull}
}


set title "Delete"
set context [list [list $return_url "Workflow Edit"] "Delete"]


ad_form -name "confirm" -form {
    {warn:text(inform) {label {Confirm:}} {value  $msg}}
    {ok:text(submit) {label {Delete}}}
    {cancel:text(submit) {label {Cancel}}}
} -on_submit {

    if {![empty_string_p $ok]} {
	switch $type {
	    role {
		workflow::role::edit \
			-operation "delete" \
			-role_id $id
	    }
	    state {
		workflow::state::fsm::edit \
			-operation "delete" \
			-state_id $id
	    }
	    action {
		workflow::action::fsm::edit -action_id $id -operation "delete"
	    }
	    workflow {
		workflow::delete -workflow_id $id
	    }
	}
    }
    
} -after_submit {
    ad_returnredirect $return_url
} -export {id return_url type msg}
