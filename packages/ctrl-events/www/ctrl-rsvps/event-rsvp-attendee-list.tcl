ad_page_contract {
    Page for deleting a selected event

    @author kellie@ctrl.ucla.edu
    @creation-date 05/18/2005
    @cvs-id $Id
} {
    {event_attendee_id:optional}
    {event_id:optional}
    {order_by:optional "first_name"}
    {order_dir:optional "asc"}
    {filter_by:optional "1=1"}
    {color_red:optional "fname"}
    {rsvp:optional ""}
    {user_info:optional 0}
}

set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]
ad_require_permission $package_id read
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set return_url "event-rsvp-attendee-list?[export_url_vars event_id]"
set return_url1 "index?[export_url_vars event_id]"
set selection [db_0or1row get_event_data {}]

if {[exists_and_not_null event_id]} {
    set event_image_display [ctrl_event::event_image_display -event_id $event_id]
} else {
    set event_image_display "<i>no image</i>"
}

ad_form -name "event_rsvp" -method {-post} -form {
    event_id:key
    {title:text(inform) {label "Event Title:"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_id:text(inform) {label "Category:"} optional}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
} -select_query_name get_event_data

ad_form -name event_rsvp1 -form {
    {event_attendee_id:key}
    {rsvp_event_id:text(hidden) {value $event_id}}
    {email:text(hidden) {label "E-mail:"} {html {maxlength 100}}}
    {first_name:text(hidden) {label "First Name:"} {html {maxlength 100}}}
    {last_name:text(hidden) {label "Last Name:"} {html {maxlength 100}}}
    {response_status:text(hidden) {label "Response :"}}
    {approval_status:text(hidden) {label "Approval :"}}
    {has_role:text(hidden) {label "Has Role :"}}
    {event_id:text(hidden) {value $event_id}}
} -select_query_name get_event_attendee


set ae_link "event-rsvp-attendee-ae?[export_url_vars event_attendee_id event_id user_info filter_by]"
set fnamea_link "event-rsvp-attendee-list?event_id=$event_id&order_by=first_name&order_dir=asc&color_red=fnamea"
set fnamed_link "event-rsvp-attendee-list?event_id=$event_id&order_by=first_name&order_dir=desc&color_red=fnamed"
set lnamea_link "event-rsvp-attendee-list?event_id=$event_id&order_by=last_name&order_dir=asc&color_red=lnamea"
set lnamed_link "event-rsvp-attendee-list?event_id=$event_id&order_by=last_name&order_dir=desc&color_red=lnamed"
set emaila_link "event-rsvp-attendee-list?event_id=$event_id&order_by=email&order_dir=asc&color_red=emaila"
set emaild_link "event-rsvp-attendee-list?event_id=$event_id&order_by=email&order_dir=desc&color_red=emaild"

db_multirow -extend {new_rsvp_role_link has_role role_link edit_link delete_link} get_event_attendee get_event_attendee {} {
    set edit_link "event-rsvp-attendee-ae?[export_url_vars event_attendee_id event_id user_info filter_by]"
    set delete_link "event-rsvp-attendee-delete?[export_url_vars event_attendee_id event_id user_info filter_by]"
    set role_link "event-rsvp-attendee-view?[export_url_vars event_attendee_id event_id user_info filter_by]"
    set new_rsvp_role_link "event-rsvp-new-role?[export_url_vars event_attendee_id event_id user_info filter_by]"
    set responsef_link "event-rsvp-attendee-list?event_id=$event_id&order_by=response&order_dir=asc&filter_by=response_status="
    set approvalf_link "event-rsvp-attendee-list?event_id=$event_id&order_by=approval&order_dir=asc&filter_by=approval_status="
    db_0or1row inquire_attendee_role {}
}
set page_title "Event RSVP Attendees"
set context_bar [ad_context_bar $page_title]

