ad_page_contract {
    Page for deleting a selected event

    @author kellie@ctrl.ucla.edu
    @creation-date 05/18/2005
    @cvs-id $Id
} {
    {event_attendee_id:optional}
    {event_id:optional}
    {user_info:optional}
    {filter_by:optional}
}

set title "View Event"
set context [list "View  Event"]
set return_url "event-rsvp-attendee-list?[export_url_vars event_id admin_p edit_p user_info filter_by]"


set selection [db_0or1row get_event_data {}]

if {$selection} {
    if {[db_string get_repeat_template_p {}] == "t"} {
	ad_return_complaint 1 "You have passed an event_id for a template event.  <br>This event can not be deleted from this page."
	return
    }
} else {
    ad_return_complaint 1 "You have passed an event_id that no longer exists in the database"
    return
}

set repeat_template_id [db_string get_repeat_template_id {}]

if {[exists_and_not_null event_id]} {
    set event_image_display [ctrl_event::event_image_display -event_id $event_id]
} else {
    set event_image_display "<i>no image</i>"
}

ad_form -name event_rsvp -method {"post"} -form {
    {event_id:key {value $event_id}}
    {title:text(inform) {value $title} {label "Event Title:"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_id:text(inform) {label "Category:"} optional}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
} -select_query_name get_event_data

set found_sw [db_0or1row get_attendee {}]

ad_form -name event_rsvp1 -method {"post"} -form {
    {event_attendee_id:key}
    {rsvp_event_id:text(hidden) {value $event_id}}
    {email:text(inform) {label "E-mail:"}}
    {first_name:text(inform) {label "First Name:"}}
    {last_name:text(inform) {label "Last Name:"}}
    {response_status:text(inform) {label "Response:"}}
    {approval_status:text(inform) {label "Approval:"}}
    {event_id:text(hidden) {value $event_id}}
    {user_info:text(hidden) {value $user_info}}
    {filter_by:text(hidden) {value $filter_by}}
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -on_submit {
  if $found_sw {
 	set failed_p 0
	db_transaction {
		db_dml delete_attendee_role {}
		db_dml rsvp_attendee_delete {}
	} on_error {
	set failed_p 1
	}
	if $failed_p {
	ad_return_error "Unable to delete event RSVP Attendee" "System was unable to delete event RSVP Attendee due to <p> <pre> $errmsg </pre>"
	}
  }
} -select_query_name get_attendee

set page_title "Delete Event Rsvp Attendee Confirmation"
set context_bar [ad_context_bar $page_title]

