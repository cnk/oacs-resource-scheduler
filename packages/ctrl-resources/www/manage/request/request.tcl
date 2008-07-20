# /packages/ctrl-resources/www/request/request.tcl

ad_page_contract {
    Display the information and events for the request

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005-12-18
    @cvs-id $Id$
} {
    request_id:naturalnum,notnull
    {toggle_status:naturalnum 0}
}

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $request_id -privilege read
crs::request::get -request_id $request_id -column_array request_info

set return_url [export_vars -base request request_id]

if {$toggle_status==1} {
    set mode edit
} else {
    set mode display
    set toggle_status_url "<a href='request?[export_url_vars request_id toggle_status=1]'>Change Status</a>"
}

ad_form -name "request_form" -form {
    {name:text(text),optional {mode display} {label Name} {value $request_info(name)}}
    {description:text(text),optional {mode display} {label Description} {value $request_info(description)}}
    {status:text(select),optional {mode $mode} {label {Status}} {options { {Approved approved} {Denied denied} {Pending pending} {Cancelled cancelled}}} {html {size 1}} {value $request_info(status)}}
    {requested_by:text(text),optional {mode display} {label "Requested By"} {value $request_info(requested_by)}}    
    {reserved_by:text(text),optional {mode display} {label "Reserved By"} {value $request_info(reserved_by)}}
    {ok_btn:text(submit),optional {mode $mode} {label "Ok"} {html {style "width: 55px"}}}
} -on_submit {
    crs::request::update_status -request_id $request_id -status $status
} -after_submit {
    ad_returnredirect request?[export_url_vars request_id]
} -export {request_id toggle_status}



db_multirow -extend [list sync_link edit_link delete_link] event_list event_list {**SQL**} {
    set edit_link [export_vars -base event-ae [list return_url request_id event_id]]
    set delete_link [export_vars -base event-delete [list return_url event_id]]
    set sync_link [export_vars -base "ics/${event_id}.ics" [list return_url event_id]]
}

template::list::create -name event_list_display -multirow event_list \
    -key event_id \
    -actions [list "Add Event" [export_vars -base event-ae [list request_id return_url]] "Add Event"] \
    -no_data "No Events in this Request" \
    -elements {
	title {
	    label "Event Name"
	}
	all_day_p {
	    label "All Day?"
	}
	start_date {
	    label "Start Date"
	}
	end_date {
	    label "End Date"
	}
	reserved_by {
	    label "Reserved By"
	}
	event_code {
	    label "Event Code"
	}
	status {
	    label "Status"
	}
	action {
	    label "Action"
	    display_template "<a href='@event_list.edit_link;noquote@'>Edit</a>\
<a href='@event_list.delete_link;noquote@'>Delete</a>\
<a href='@event_list.sync_link@'> Sync with Outlook </a>"
	}
    }

set context [list [list ../index Resources] [list "../request" "Request List"] "One Request"]
set title "$request_info(name) Request"

ad_return_template


