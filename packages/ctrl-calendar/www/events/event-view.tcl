ad_page_contract {
    Page for viewing a selected event

    @author kellie@ctrl.ucla.edu
    @creation-date 05/18/2005
    @cvs-id $Id
} {
    {event_id:naturalnum,notnull}
    {cal_id:naturalnum,notnull}
    {user_info:optional 0}
    {rsvp:optional ""}
    {order_by:optional "name"}
    {order_dir:optional "asc"}
}

set selection [db_0or1row get_event_data {}]

if {$selection == 0} {
    ad_returnredirect "[ad_conn package_url]"
}

set page_title "View Event"
set context [list "View  Event"]

ctrl_event::get -event_id $event_id -array event_info
set repeat_template_p $event_info(repeat_template_p)
set repeat_template_id $event_info(repeat_template_id)

set package_id [ad_conn package_id]
set user_id [ad_verify_and_get_user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set event_edit_link "[ad_conn package_url]events/event-ae?[export_url_vars event_id]&[export_url_vars cal_id]"
set event_delete_link "[ad_conn package_url]events/event-delete?[export_url_vars event_id]&[export_url_vars cal_id]"

if [string equal $repeat_template_p "t"] {
    ad_return_complaint 1 "You have passed an event_id for a template event.  <br>This event can not be deleted from this page."
    return
}

set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set signup_url "event-rsvp-attendee-ae?[export_url_vars event_id admin_p user_info filter_by=1=1]"
set return_url "index?"
set SignUp ""

if {[exists_and_not_null event_id]} {
    set event_image_display [ctrl_event::event_image_display -event_id $event_id]
} else {
    set event_image_display "<i>no image</i>"
}

set category_list [join [ctrl::cal::get_event_categories -event_id $event_id] ", "]

ad_form -name "view_event" -method {-post} -form {
    {event_id:key}
    {title:text(inform) {label "Event Title:"} optional}
    {speakers:text(inform) {label "Speaker(s):"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_list:text(inform) {label "Category:"} optional {value $category_list}}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
    {SignUp:text(submit)}
} -after_submit {
    ad_returnredirect "index"
    ad_script_abort
} -on_submit {
    if {$SignUp == "SignUp"} {
    ad_returnredirect $signup_url
    ad_script_abort
    }
   if {[empty_string_p $repeat_template_id]} {
	set fail_p [catch {set event_id [ctrl_event::delete -event_id $event_id]} errmsg]
    } else {

	if {$event_delete_opt==0} {
	    set fail_p [catch {set event_id [ctrl_event::delete -event_id $event_id]} errmsg]
	} elseif {$event_delete_opt==1} {
	    set fail_p [catch {set event_id [ctrl_event::delete_recurrences -repeat_template_id $repeat_template_id]} errmsg]
	} else {
	    ad_return_complaint 1 "Please select delete this event or delete all future events"
	    ad_script_abort
	}
    } 
    if {$fail_p != 0} {
	ad_return_error "Fail to delete event" $errmsg
	ad_script_abort
	return
    }
} -select_query_name get_event_data

db_multirow -extend {} get_repeat_event_data get_repeat_event_data {} {}

ad_form -name "event_tasks" -form {
    {task_id:key}
} -select_query_name get_event_tasks

set task_new_ae_link "ctrl-tasks/event-rsvp-task-ae1?[export_url_vars event_id task_id category_id]"
db_multirow -extend {task_ae_link task_delete_link} event_tasks get_event_tasks {} {
    set task_ae_link "/ctrl-events/tasks/event-rsvp-task-ae1?[export_url_vars event_id task_id category_id]"
    set task_delete_link "/ctrl-events/tasks/event-rsvp-task-delete?[export_url_vars event_id task_id]"
}
