ad_page_contract {
    View reservation details
    @author JW
    @cvs-id $Id$
    @creation-date 2005-12-20
} {
    {request_id:notnull}
    {event_id ""}
    {room_id ""}
    {update_status_p 0}
}

# Make sure request still exists
set exists_p [crs::request::exists_p -request_id $request_id]

set page_title "Reservation Details"
set context [list [list "view" "Reservation List"] "One"]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

set room_detail_link "<a href=[ad_conn package_url]room-details?[export_url_vars room_id]>Go to Room Details</a>"
set reservation_link "<a href=[ad_conn package_url]>Go to Room Reservation Index</a>"
