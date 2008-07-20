# /packages/ctrl-calendar/www/events/event-delete.tcl

ad_page_contract {
    Page for deleting a selected event

    @author kellie@ctrl.ucla.edu
    @creation-date 05/18/2005
    @cvs-id $Id
} {
    {event_id:naturalnum,notnull}
    {cal_id:naturalnum ""}
}

set title "Delete Event"
set context [list "Delete Event"]
set subsite_url [ad_conn package_url]

set selection [db_0or1row get_event_data {}]

if {$selection == 0} {
    ad_returnredirect "${subsite_url}view-all-events?[export_url cal_id]"
}

ctrl_event::get -event_id $event_id -array event_info
set repeat_template_p $event_info(repeat_template_p)
set repeat_template_id $event_info(repeat_template_id)

if [string equal $repeat_template_p "t"] {
    ad_return_complaint 1 "You have passed an event_id for a template event.  <br>This event can not be deleted from this page."
    return
}

if {[exists_and_not_null event_id]} {
    set event_image_display [ctrl_event::event_image_display -event_id $event_id]
} else {
    set event_image_display "<i>no image</i>"
}

set category_list [join [ctrl::cal::get_event_categories -event_id $event_id] ", "]

ad_form -name "delete_event" -method {-post} -form {
    event_id:key
    {cal_id:text(hidden) {value $cal_id}}
    {title:text(inform) {label "Event Title:"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_list:text(inform) {label "Category:"} optional {value $category_list}}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
    {event_delete_opt:text(radio) {label ""} {options {{"delete only this event" 0} {"delete this and all future occurrences of this event" 1}}} {value {0}}}
    {delete_btn:text(submit) {label "Delete"}}
} -on_request {

} -new_data {

} -edit_data {

} -on_submit {

# delete child records for the event (rsvps,attendees,roles)
    set error_p 0
    db_transaction {

	set attendees_list [list]
	db_multirow get_attendees get_attendees {} {
	    lappend attendees_list $event_attendee_id
	}
	
	if {![empty_string_p $attendees_list]} {
	    foreach event_attendee_id $attendees_list {
		db_dml delete_roles {}
	    }
	}
	db_dml delete_attendees {}
	db_dml delete_rsvps {}
        ctrl::cal::event::del -event_id $event_id
	
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	ad_return_error "Unable to delete related child records for this event" "System was unable to delete the event due to <p> <pre> $errmsg </pre>"
	ad_script_abort
    }

    set delete_date [db_string get_delete_date {}]

    if {[empty_string_p $repeat_template_id]} {
	set fail_p [catch {set event_id [ctrl_event::delete -event_id $event_id]} errmsg]
    } else {
	if {$event_delete_opt==0} {
	    set fail_p [catch {set event_id [ctrl_event::delete -event_id $event_id]} errmsg]
	} elseif {$event_delete_opt==1} {
	    set fail_p [catch {set event_id [ctrl_event::delete_recurrences -repeat_template_id $repeat_template_id -delete_date $delete_date]} errmsg]
	} else {
	    ad_return_complaint 1 "Please select delete this event or delete all future events"
	    ad_script_abort
	}
    }
    if {$fail_p != 0} {
	ad_return_error "Fail to delete event" $errmsg
	ad_script_abort
    }
} -select_query_name get_event_data -after_submit {
#    ad_returnredirect "${subsite_url}view-all-events?[export_url_vars cal_id]"
    ad_returnredirect "${subsite_url}events/event-list"
}

db_multirow -extend {} get_repeat_event_data get_repeat_event_data {} {
}
