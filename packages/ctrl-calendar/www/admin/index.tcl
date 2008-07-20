# /packages/ctrl-calendar/www/index.tcl

ad_page_contract {
    
    Calendar index page
    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @author        Avni Khatri (avni@ctrl.ucla.edu)
    @creation-date 12/15/2005
    @cvs-id  $Id$

} {
}



set title "Calendar Options"
set context "Calendar"

set user_id [ad_maybe_redirect_for_registration]
set package_id [ad_conn package_id]
set subsite_id [ad_conn subsite_id]

set filter_by [parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance]

if {[string equal $filter_by "subsite"]} {
    set and_filter_by "and subsite_id = :subsite_id"
} else {
    set and_filter_by "and package_id = :package_id"
}

set event_ae_link "href=events/event-ae?cal_id=0"

db_multirow -extend {edit_link delete_link view_link view_week view_day view_events rss_feed add_event_link add_filter_link view_filter_link} private_cals get_private_cals {} {
    set edit_link   "ae?[export_url_vars cal_id]"
    set delete_link "delete-confirm?[export_url_vars cal_id]"
    set view_link   "../view-month?[export_url_vars cal_id]"
    set view_week   "../view-week?[export_url_vars cal_id]"
    set view_day    "../view-day?[export_url_vars cal_id]"
    set view_events "../events/event-list?calendar=$cal_id&calendar_p=t"
    set rss_feed    "../rss/cal_$cal_id\.xml"    
    set add_event_link "../events/event-ae?[export_url_vars cal_id]"
    set add_filter_link "../filter/filter-ae?[export_url_vars cal_id]"
    set view_filter_link "../filter/index?[export_url_vars cal_id]"
}

db_multirow -extend {edit_link delete_link permission_link view_link view_week view_day view_events rss_feed add_event_link add_filter_link view_filter_link} public_cals get_public_cals {} {
    set edit_link   "ae?[export_url_vars cal_id]"
    set delete_link "delete-confirm?[export_url_vars cal_id]"
    set permission_link "/permissions/one?object_id=$cal_id"
    set view_link "../view-month?[export_url_vars cal_id]"
    set view_week "../view-week?[export_url_vars cal_id]"
    set view_day "../view-day?[export_url_vars cal_id]"
    set view_events "../events/event-list?calendar=$cal_id&calendar_p=t"
    set rss_feed "../rss/cal_$cal_id\.xml"
    set add_event_link "../events/event-ae?[export_url_vars cal_id]"
    set add_filter_link "../filter/filter-ae?[export_url_vars cal_id]"
    set view_filter_link "../filter/index?[export_url_vars cal_id]"
}

set create_p [permission::permission_p -object_id $package_id -privilege "create"] 

set add_public_link "ae"
set add_private_link "ae?cal_type=private"

