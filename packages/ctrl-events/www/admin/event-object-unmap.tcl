# /packages/ctrl-events/www/admin/event-object-unmap.tcl

ad_page_contract {
    Unmap event object to events
    
    @author kellie@ctrl.ucla.edu
    @creation-date 11/29/2006
    @cvs-id $Id
} {
    {event_id:naturalnum,optional}
    {event_object_id:naturalnum,optional}
}

set error_p [catch {
    if {![exists_and_not_null event_id] && ![exists_and_not_null event_object_id]} {
	ad_return_error "Error" "Missing parameters"
	ad_script_abort
    }

    set page_title "Unmap Event Object and Events"
    set context_bar "[ad_context_bar ""][ad_context_bar_html [list [list "event-object-list?[export_vars event_id]" "Event Objects"] $page_title]]"
    
    if {[exists_and_not_null event_object_id]} {
	set mapped_events_options [db_list_of_lists mapped_events_for_event_object_id {}]
	set message "Select events you wish to remove association with this object"
    } else {
	set mapped_events_options [db_list_of_lists mapped_events_for_event_id {}]
	set message "Select event objects you wish to remove association with this event"
	set event_object_id ""
    }
    
} errmsg ]

if {$error_p} {
    ad_return_error "Error" "$errmsg"
    ad_script_abort
}

ad_form -name "event_object_unmap" -method post -html {enctype multipart/form-date} -form {
    {event_id:text(hidden) {value $event_id}}
    {event_object_id:text(hidden) {value $event_object_id}}
    {mapped_events:text(checkbox),optional,multiple {options $mapped_events_options} {label "Mapped Events"}}
    {submit:text(submit) {label "Unmap Event Object and Events"}}
} -on_request {
    set mapped_events $event_id
} -on_submit {
    foreach id $mapped_events {
	if {[exists_and_not_null event_object_id]} {
	    ctrl_event::object::unmap -event_object_id $event_object_id -event_id $id
	} else {
	    ctrl_event::object::unmap -event_object_id $id -event_id $event_id
	}
    }
} -after_submit {
    ad_returnredirect "[ad_conn package_url]admin/event-object-list?[export_url_vars event_id]"
}

