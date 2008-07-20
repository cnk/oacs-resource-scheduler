ad_page_contract {

    A page to display rooms

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$

    @ max_dbrows - the number of db rows to evaluate for the best and some separately
    @ max_returnresults - the combine number of rows to display at once
} {
    {name:trim ""}
    {capacity:integer,trim ""}
    {location:trim ""}
    {add_services:trim ""}
    {all_day_p "f"}
    {all_day_date:array,date ""}
    {from_date:array,date ""}
    {to_date:array,date ""}
    {eq:multiple ""}
    {current_page:naturalnum 0}
    {row_num:naturalnum 25}
    {paginate_p 1}
    {max_dbrows 50}
    {max_returnresults 25}
}

set package_id [ad_conn package_id]
set user_id    [ad_conn user_id]

#check permissions - log in not required for viewing rooms
permission::require_permission -privilege "read" -object_id $package_id

# ------------------------------------------------------------
# Initialize the date arrays if the dates are not defined
# ------------------------------------------------------------
set date_option_list [list date year month day hours minutes ampm]

if ![info exists subsite_id] {
    set subsite_id [ad_conn subsite_id]
}

if ![info exists from_date(date)] {
    foreach option $date_option_list {
	set from_date($option) ""
    }
} 
if ![info exists to_date(date)] {
    foreach option $date_option_list {
	set to_date($option) ""
    }
} 
if ![info exists all_day_date(date)] {
    foreach option $date_option_list {
	set all_day_date($option) ""
    }
} 

# -------------------------------------------------------------------------- 
# Address the issue relating to the short hours for date widgets
# --------------------------------------------------------------------------
if [info exists from_date(short_hours)] {
    set from_date(hours) $from_date(short_hours)
}

if [info exists to_date(short_hours)] {
    set to_date(hours) $to_date(short_hours)
}

set title "Room listing"
set context [list [list  "room-search" "Search Filter"]  "Room Results Listing"]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $title]

if {[info exists from_date(date)]} {
    set from_date_list [list $from_date(date)\
			    $from_date(year)\
			    $from_date(month)\
			    $from_date(day)\
			    $from_date(hours)\
			    $from_date(minutes)\
			    $from_date(ampm)]
} else {
    set form_date_list [list]
}

if {[info exists to_date(date)]} {
    set to_date_list [list $to_date(date)\
			  $to_date(year)\
			  $to_date(month)\
			  $to_date(day)\
			  $to_date(hours)\
			  $to_date(minutes)\
			  $to_date(ampm)]
} else {
    set to_date_list [list]
}

if {[info exists all_day_date(date)]} {
    set all_day_date_list [list $all_day_date(year)\
			       $all_day_date(month)\
			       $all_day_date(day)]
} else {
    set all_day_date_list [list]
}
