ad_page_contract {

    Workflow index

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: index.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {context "Workflow"}
}

set title "Workflow Index"


#get a listing of all the workflow boiler plates
set where_clause "object_id is null"
db_multirow -extend {edit_url delete_url view_url}  get_bps get_wfs {} {
    set edit_url "workflow-edit?[export_url_vars workflow_id]"
    workflow::get -workflow_id $workflow_id -array "wf_info"
    set msg "You are about to delete $wf_info(short_name). Are you sure?"
    set delete_url "delete-confirm?[export_url_vars id=$workflow_id type=workflow msg]"
    set view_url "workflow-graph?[export_url_vars workflow_id]"
}


#get a listing of all the workflow instances
set where_clause "object_id is not null"
db_multirow -extend {edit_url delete_url view_url} get_instances  get_wfs {} {
    set edit_url "workflow-edit?[export_url_vars workflow_id]"
    workflow::get -workflow_id $workflow_id -array "wf_info"
    set msg "You are about to delete $wf_info(short_name). Are you sure?"
    set delete_url "delete-confirm?[export_url_vars id=$workflow_id type=workflow msg]"
    set view_url "workflow-graph?[export_url_vars workflow_id]"
}

set new_wf_url "workflow-ae"
set clone_url "workflow-clone"
