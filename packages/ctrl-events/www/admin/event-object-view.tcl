ad_page_contract {
    Page for deleting a selected event object

    @author kellie@ctrl.ucla.edu
    @creation-date 11/14/2006
    @cvs-id $Id
} {
    {event_object_id:naturalnum,notnull}
    {event_id:naturalnum,optional}
}

set error_p [catch {

set page_title "View Event Object"
set context_bar "[ad_context_bar ""][ad_context_bar_html [list [list "event-object-list?[export_vars event_id]" "Event Objects"] $page_title]]"
set subsite_url [ad_conn package_url]
set package_id [ad_conn package_id]

set edit_link "${subsite_url}admin/event-object-ae?[export_url_vars event_object_id event_id]"
set delete_link "${subsite_url}admin/event-object-delete?[export_vars event_object_id]"

set image_display ""
if {[exists_and_not_null event_object_id]} {
    set image_display [ctrl_event::object::image_display -event_object_id $event_object_id]
} else {
    set image_display "<i>no image</i>"
}
} errmsg]

if {$error_p} {
    ad_return_complaint 1 $errmsg
    ad_script_abort
}

ad_form -name "delete_event_object" -method {-post} -form {
    event_object_id:key
    {name:text(inform) {label "Name:"}}
    {object_type:text(inform) {label "Object Type:"}}
    {description:text(inform) {label "Description:"} optional}
    {url:text(inform) {label "URL: "} optional}
    {image:text(inform) {label "Image: "} {value "$image_display"}}
    {submit:text(submit) {label "Ok"}}
} -on_request {

} -select_query_name get_event_object -after_submit {
    ad_returnredirect "${subsite_url}admin/event-object-list"
}

db_multirow -extend {} get_mapped_events get_mapped_events {} {}
