ad_page_contract {

    List of requests
    If resource_id is passed in, only requests for that resource show up
    Otherwise show all requests

    @author avni@ctrl.ucla.edu (AK)
    @cvs-id $Id$
    @creation-date 2005-12-15
} {

}

set package_id [ad_conn package_id]

db_multirow -extend [list edit_link delete_link view_link] request_list request_list {**SQL**} {
    set edit_link_url [export_vars -base ae {request_id}]
    set edit_link "<a href='$edit_link_url'>Edit</a>"
    set delete_link_url [export_vars -base request-delete {request_id return_url}]
    set delete_link "<a href='$delete_link_url'>Delete</a>"
    set view_link "[export_vars -base request request_id]"
}

template::list::create -name request_list_display -multirow request_list \
    -key request_id \
    -actions [list "Add New Request" [export_vars -base ae] "Add New Request"] \
    -elements {
	name {
	    label "Request Name"
	    link_url_col view_link
	}
	description {
	    label "Description"
	} 
	status {
	    label "Status"
	}
	full_name {
	    label "Reserved By"
	} 
	requested_by {
	    label "Requested By"
	}
	actions {
	    label "Actions"
	    display_template "@request_list.edit_link;noquote@ @request_list.delete_link;noquote@"
	}
    }

set title "Request List"
lappend context $title

ad_return_template
