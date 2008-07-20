# /packages/ctrl-events/www/index.tcl

ad_page_contract {
    index page for events

    @author kellie@ctrl.ucla.edu
    @creation-date 05/13/2005
    @cvs-id $Id

} {
    {search_title:trim ""}
    {search_object:trim ""}
    {search_start_date:trim ""}
    {search_year:trim ""}
    {search_month:trim ""}
    {search_date_sql:trim ""}
    {search_location:trim ""}
    {search_constraint:trim ""}
    {row_num:naturalnum 15}
    {current_page:naturalnum 0}
    {order_by:optional}
    {order_dir:optional}
    {color_red:optional "sdatea"}}

set page_title "Event Listing"
set context_bar [ad_context_bar $page_title]
set context_id [ad_conn package_id]
set package_id [ad_conn package_id]
ad_require_permission $package_id read
set user_id [ad_verify_and_get_user_id]
set delete_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege delete]
set edit_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege edit]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set event_add_link "<a href=\"[ad_conn package_url]admin/event-ae\">Add An Event</a>"
 
if {![exists_and_not_null order_by] } {
    set order_by "start_date_sort, title"
}
if {![exists_and_not_null order_dir] } {
    set order_dir asc
}

#Pagination
db_1row sql_total_items {}

set page_list [ctrl_procs::util::pagination -total_items $total_items -current_page $current_page -row_num $row_num -path "index?order_by=$order_by&order_dir=$order_dir"]
set lower_bound [lindex $page_list 0]
set upper_bound [lindex $page_list 1]
set pagination_nav_bar [lindex $page_list 2]

ad_form -name search_form -form {
    {search_title:text,optional {label "Title"} {html {size 40}}}
    {search_object:text,optional {label "Object"} {html {size 40}}}
    {search_start_date:date,optional {label "Start Date"} {format "Month YYYY"}}
    {search_location:text,optional {label "Location"} {html {size 40}}}
    {submit:text(submit) {label "Search"}}
} -on_request {
    if {![empty_string_p $search_start_date]} {
	set search_year [lindex $search_start_date 0]
	set search_month [lindex $search_start_date 1]
	if {![empty_string_p $search_month] && ![empty_string_p $search_year]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'YYYY MM') = '$search_year [ctrl_event::date_util::format_month_to_number -month_param $search_month]'"
	} elseif {![empty_string_p $search_month]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'MM') = '[ctrl_event::date_util::format_month_to_number -month_param $search_month]'"
	} elseif {![empty_string_p $search_year]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'YYYY') = '$search_year'"
	} else {
	    set search_date_sql ""
	}
    }
} -on_submit {
    if {![empty_string_p $search_start_date]} {
	set search_year [lindex $search_start_date 0]
	set search_month [lindex $search_start_date 1]

	if {![empty_string_p $search_month] && ![empty_string_p $search_year]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'YYYY MM') = '$search_year [ctrl_event::date_util::format_month_to_number -month_param $search_month]'"
	} elseif {![empty_string_p $search_month]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'MM') = '[ctrl_event::date_util::format_month_to_number -month_param $search_month]'"
	} elseif {![empty_string_p $search_year]} {
	    set search_date_sql " and to_char(ctrl_events.start_date, 'YYYY') = '$search_year'"
	} else {
	    set search_date_sql ""
	}
    }
}

set search_constraint ""

if {![empty_string_p $search_title]} {
    append search_constraint " and lower(ctrl_events.title) like '%[string tolower $search_title]%'"
}

if {![empty_string_p $search_object]} {
    append search_constraint " and lower(acs_object.name(ctrl_events.event_object_id)) like '%[string tolower $search_object]%'"
}

if {![empty_string_p $search_date_sql]} {
    append search_constraint $search_date_sql
}

if {![empty_string_p $search_location]} {
    append search_constraint " and lower(ctrl_events.location) like '%[string tolower $search_location]%'"
}

db_multirow -extend {view_link edit_link delete_link rsvp_link rsvp} get_events_data get_events_data {} {
    set edit_link "[ad_conn package_url]admin/event-ae?[export_url_vars event_id]"
    set delete_link "[ad_conn package_url]admin/event-delete?[export_url_vars event_id]"
    set view_link "event-view?[export_url_vars event_id]"
    set user_info [db_0or1row get_user {}]
    db_0or1row rsvp_admin_count {}
    if {[empty_string_p $capacity] || $capacity == 0 || [empty_string_p $rsvp]} {
        set rsvp "N/A"
    } else {
	db_0or1row rsvp_count {}
	if [empty_string_p $rsvp] {
	    set rsvp 0
	}
	if {$rsvp >= $capacity} {
	    set rsvp "Full"
	} else {
	    set rsvp "SignUp"
	}
    }
    if {$admin_p} {	
	set rsvp_link "/ctrl-events/rsvps/event-rsvp-attendee-list?[export_url_vars event_id rsvp user_info]"
    } elseif {$rsvp == "SignUp"} {
	set rsvp_link "/ctrl-events/rsvps/event-rsvp-attendee-ae?[export_url_vars event_id rsvp user_info]"
    }
}

