# /packages/ctrl-calendar/www/events/event-cancel.tcl

ad_page_contract {
    This page confirms cancellation of an event and send emails to users that downloaded the event to ical/outlook
    @author: kellie@ctrl.ucla.edu
    @creation-date: 01/16/2007
    @cvs-id $Id:
} {
    {event_id:naturalnum,notnull}
    {status:notnull}
}

if {$status == "cancelled"} {
    set submit_label "Cancel the Event"
} elseif {$status == "scheduled"} {
    set submit_label "Scheduled the Event"
} elseif {$status == "pending"} {
    set submit_label "Pending"
} else {
    ad_return_complaint 1 "Invalid Status"
    ad_script_abort
}

ad_form -name "event_status" -method post -form {
    {event_id:key}
    {status:text(hidden) {value $status}}
    {title:text(inform) {label "Event Title:"} optional}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {submit:text(submit) {label $submit_label}}
} -on_submit {
    ctrl_event::update_event_status -event_id $event_id -status $status
    ctrl_calendar::vcalendar::notify_cancelled_event -cal_event_id $event_id
} -after_submit {
    ad_returnredirect "event-list"
} -select_query_name get_event_data
