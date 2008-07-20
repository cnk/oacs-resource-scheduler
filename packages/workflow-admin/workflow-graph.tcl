ad_page_contract {
    to view workflow graph
    @author       jmhek@cs.ucla.edu
    @creation-date 4/5/2005
    @cvs-id  $Id: workflow-graph.tcl,v 1.2 2005/05/23 20:31:59 jwang1 Exp $
} {
    {workflow_id}
    {states_to_highlight ""}
}

set flag [workflow::graph::draw -workflow_id $workflow_id -highlight $states_to_highlight]
if {$flag==0} {
    ad_returnredirect graph/workflow_$workflow_id\.jpg
} else {
    ad_returnredirect [get_referrer]
}

