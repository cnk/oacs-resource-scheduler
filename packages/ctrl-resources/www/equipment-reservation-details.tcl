ad_page_contract {
    View reservation details
    @author JW
    @cvs-id $Id$
    @creation-date 2005-12-20
} {
    {request_id:notnull}
    {update_status_p 0}
}

set page_title "Equipment Reservation"
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

set context [list [list "view" "Reservation List"] "One"]


