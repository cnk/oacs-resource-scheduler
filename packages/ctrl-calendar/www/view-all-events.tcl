# /packages/ctrl-calendar/www/view-day.tcl

ad_page_contract {
    Daily View of Calendar

    @author jmhek@cs.ucla.edu
    @creation-date 1/31/2006
    @cvs-id $Id$
} {
    cal_id:naturalnum,notnull
    {julian_date:optional ""}
}

set admin_p [permission::permission_p -object_id $cal_id -privilege "admin"]

ctrl::cal::get -cal_id $cal_id -column_array cal_info
set object_id_list $cal_info(object_id)

set calendar_name [db_string get_calendar_name {} -default ""]
set page_title "Events for Calendar: $calendar_name"
set context [list "View All Events"]

### SET UP CALENDAR PARAMETERS ################################################################################################
if {![empty_string_p $julian_date]} {
    set current_date [dt_julian_to_ansi $julian_date]
} else {
    set current_date [dt_sysdate]
    set julian_date [dt_ansi_to_julian_single_arg $current_date]
}

set current_date [dt_sysdate]

db_multirow -extend {vcs_link ics_link edit_link delete_link} all_events get_all_events {} {
    set vcs_link  "<a href=\"vcs/${event_id}.vcs\">Download to Outlook</a>"
    set ics_link  "<a href=\"ics/${event_id}.ics\">Download to Other</a>"
    set edit_link "<a href=\"events/event-ae?[export_url_vars cal_id event_id]\">Edit</a>"
    set delete_link "<a href=\"events/event-delete?[export_url_vars cal_id event_id]\">Delete</a>"
}

set event_ae_link "<a href=\"events/event-ae?[export_url_vars cal_id]\">Add Event</a>"
