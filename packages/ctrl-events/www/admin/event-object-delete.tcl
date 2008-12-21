ad_page_contract {
    Page for deleting a selected event object

    @author kellie@ctrl.ucla.edu
    @creation-date 11/14/2006
    @cvs-id $Id
} {
    {event_object_id:naturalnum,notnull}
    {event_id:naturalnum,optional}
}

if {![exists_and_not_null event_id]} {set event_id ""}

set page_title "Delete Event Object"
set context_bar "[ad_context_bar ""][ad_context_bar_html [list [list "event-object-list?[export_vars event_id]" "Event Objects"] $page_title]]"
set package_id [ad_conn package_id]
set subsite_url [ad_conn package_url]

set image_display ""
if {[exists_and_not_null event_object_id]} {
    set image_display [ctrl_event::object::image_display -event_object_id $event_object_id]
} else {
    set image_display "<i>no image</i>"
}

ad_form -name "delete_event_object" -method {-post} -form {
    event_object_id:key
    {event_id:text(hidden) {value $event_id}}
    {name:text(inform) {label "Name:"}}
    {object_type:text(inform) {label "Object Type:"}}
    {description:text(inform) {label "Description:"} optional}
    {url:text(inform) {label "URL: "} optional}
    {image:text(inform) {label "Image: "} {value "$image_display"}}
    {delete_btn:text(submit) {label "Delete"}}
} -on_request {

} -on_submit {
    set fail_p [catch {

	ctrl_event::object::delete -event_object_id $event_object_id

    } errmsg]

    if {$fail_p} {
	ad_return_error "Fail" $errmsg
	return
    }
} -select_query_name get_event_object -after_submit {
    ad_returnredirect "${subsite_url}admin/event-object-list?[export_url_vars event_id]"
}

db_multirow -extend {} get_mapped_events get_mapped_events {} {}
