# /packages/ctrl-calendar/www/view-weekly.tcl

ad_page_contract {

    Weekly View of Calendar

    @author reye@mednet.ucla.edu
    @creation-date 02/01/2006
    @cvs-id $Id

} {
    {room_id:naturalnum,notnull}
    {julian_date:optional ""}
}

set user_id [ad_conn user_id]

crs::calendar::get -room_id $room_id -column_array cal_info
set cal_id $cal_info(cal_id)
permission::require_permission -party_id $user_id -object_id $cal_id -privilege read
#set create_p [permission::permission_p -party_id $user_id -object_id $cal_id -privilege create]
#Give permission to create a reservation, since it will always be allowed
set create_p 1
set page_title "$cal_info(cal_name) - Weekly View  "
set context [list [list [export_vars -base ../room-details room_id] $cal_info(room_name)] "Calendar -  Weekly View"]

### SET UP CALENDAR PARAMETERS ################################################################################################
if {![empty_string_p $julian_date]} {
    set current_date [dt_julian_to_ansi $julian_date]
} else {
    set current_date [dt_sysdate]
    set current_date_list [split $current_date "-"]
    set year  [lindex $current_date_list 0] 
    set month [string trimleft [lindex $current_date_list 1] 0] 
    set day   [string trimleft [lindex $current_date_list 2] 0]
    set julian_date [dt_ansi_to_julian $year $month $day]
}

set next_julian_date [expr $julian_date + 7]
set previous_julian_date [expr $julian_date - 7]

set next_week_template "( <a href=view-week?[export_url_vars room_id]&julian_date=$next_julian_date>Next Week</a> )"
set prev_week_template "( <a href=view-week?[export_url_vars room_id]&julian_date=$previous_julian_date>Previous Week</a> )"
#set day_number_template "<a href=view-day?[export_url_vars room_id]&julian_date=$julian_date>$day_number</a>"

### END SETTING UP CALENDAR PARAMETERS #########################################################################################

### SET UP OBJECT EVENTS #######################################################################################################
set calendar_details [ns_set create calendar_details]
set object_event_info [crs::event::get_list -room_id $room_id -viewtype "week" -current_julian_date $julian_date]
set events_display ""

# get all unique julian date from object_event_info in a list
#set julian_list [db_list get_juilian_date {}]
db_1row julian_week_date_list {**SQL**} 
set julian_list [list $sunday_j $sunday_date $monday_j $monday_date $tuesday_j $tuesday_date \
		     $wednesday_j $wednesday_date $thursday_j $thursday_date $friday_j $friday_date $saturday_j $saturday_date]

# foreach julian date, build display of that date
foreach [list j_date resv_date] $julian_list {
    set events_display ""
    set cell_display ""
    foreach date_info $object_event_info {
	if {[lindex $date_info 5] == $j_date} {
	    set event_id [lindex $date_info 0]
	    set event_object_id [lindex $date_info 1]
	    set title [lindex $date_info 2]
	    set start_date [lindex $date_info 3]
	    set end_date [lindex $date_info 4]
	    set julian_start_date [lindex $date_info 5]
	    set start_time [lindex $date_info 6]
	    set end_time [lindex $date_info 7]
	    set request_id [lindex $date_info 8]

	    append cell_display "<li>\[ $start_time - $end_time \] <a href=\"../reservation-details?[export_url_vars request_id]\">$title</a></li>"
	}
    }
    if $create_p {
	append events_display "<a href=\"../room-details?[export_url_vars room_id to_date=$resv_date from_date=$resv_date]\">Make Reservation</a> </li>"
    }
    if ![empty_string_p $cell_display] {
	append events_display "<ul>$cell_display</ul>"
    }
    ns_set update $calendar_details $j_date $events_display
}


### END SETTING UP OBJECT EVENTS ###############################################################################################

### DISPLAY WEEKLY CALENDAR ###########################################################################################################
set calendar [dt_widget_week -calendar_details $calendar_details \
		  -date $current_date \
		  -next_week_template $next_week_template \
		  -prev_week_template $prev_week_template \
		  -calendar_width "800" \
		  -master_bgcolor "#aaaaaa" \
		  -header_bgcolor "#339900" \
		  -header_text_color "#242942" \
		  -header_text_size "4" \
		  -day_header_size 2 \
		  -day_header_bgcolor "#FFCC00" \
		  -day_bgcolor "#ffffff" \
		  -today_bgcolor "#aaaaaa" \
		  -day_text_color "#4D4DB4" \
		  -empty_bgcolor "#cccccc" \
		  -prev_next_links_in_title 1]
### END DISPLAY WEEKLY CALENDAR #######################################################################################################
