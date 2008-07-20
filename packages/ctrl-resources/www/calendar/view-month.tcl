# /packages/ctrl-calendar/www/view-month.tcl

ad_page_contract {

    Monthly View of Calendar

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/19/2005
    @cvs-id $Id$
} {
    room_id:naturalnum,notnull
    {ansi_date:optional}
}


set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $room_id -privilege read

crs::calendar::get -room_id $room_id -column_array cal_info
set cal_id $cal_info(cal_id)
set page_title "$cal_info(cal_name) - Monthly View  "
set context [list [list [export_vars -base ../room-details room_id] $cal_info(room_name)] "Calendar -  Monthly View"]

### SET UP CALENDAR PARAMETERS ################################################################################################
if {[info exists ansi_date]} {
    set current_date $ansi_date
} else {
    set current_date [dt_sysdate]
}

set next_month_template "( <a href=\"view-month?[export_url_vars room_id]&ansi_date=\$ansi_date\">Next Month</a> )"
set prev_month_template "( <a href=\"view-month?[export_url_vars room_id]&ansi_date=\$ansi_date\">Previous Month</a> )"
set day_number_template "<a href=\"view-day?[export_url_vars room_id]&julian_date=\$julian_date\">\$day_number</a>"

### END SETTING UP CALENDAR PARAMETERS #########################################################################################

### SET UP OBJECT EVENTS #######################################################################################################
set current_date_list [split $current_date "-"]
set year  [lindex $current_date_list 0] 
set month [string trimleft [lindex $current_date_list 1] 0] 
set day   [string trimleft [lindex $current_date_list 2] 0]
set julian_date [dt_ansi_to_julian $year $month $day]

set calendar_details [ns_set create calendar_details]
set object_event_info [crs::event::get_list -room_id $room_id -viewtype "month" -current_julian_date $julian_date]
foreach date_info $object_event_info {
    set julian_event_date [lindex $date_info 0]
    set start_time [lindex $date_info 1]
    set title [lindex $date_info 2]
    set event_id [lindex $date_info 3]
    set request_id [lindex $date_info 7]
    set events_display "$start_time <a href=\"../reservation-details?[export_url_vars request_id]\">$title</a>"
    ns_log Notice "VERO: $julian_event_date"
    ns_set update $calendar_details $julian_event_date $events_display
}
### END SETTING UP OBJECT EVENTS ###############################################################################################

### Set reservation links #####################################################################################################
dt_get_info $current_date
set next_julian_date $first_julian_date_of_month
#We need to add to the calendar the make reservation
#link for each day.
for {set i 1} {$i <= $num_days_in_month} {incr i} {
  set ansi_date "[dt_julian_to_ansi $next_julian_date]-00"
  regsub -all -- {-} $ansi_date " " ansi_date
  set resv_link "<font size=-2><a href=\"../room-details?[export_url_vars room_id to_date=$ansi_date from_date=$ansi_date]\">Make Reservation</a></font>"
  #Check if for this date there is already an event, if 
  #there is any, then append to the reservation link, so 
  #both will appear in the calendar.
  if {[ns_set find $calendar_details $next_julian_date]!= "-1"} {
      append resv_link "<br> [ns_set get $calendar_details $next_julian_date]"
  }
  ns_set update $calendar_details $next_julian_date $resv_link
  set next_julian_date [expr $next_julian_date + 1]
}
###############################################################################################################################


### DISPLAY CALENDAR ###########################################################################################################
set calendar [dt_widget_month -calendar_details $calendar_details -date $current_date -day_number_template $day_number_template -next_month_template $next_month_template \
		  -prev_month_template $prev_month_template -calendar_width "700" -master_bgcolor "414C60" -header_bgcolor "#FF9900" -header_text_color "#242942" \
		  -header_text_size "4" -day_header_size 2 -day_header_bgcolor "#E5E5BA" \
		  -day_bgcolor "#ffffff" -today_bgcolor "#F2F29A" -day_text_color "#333333" -empty_bgcolor "#cccccc" -prev_next_links_in_title 1]
### END DISPLAY CALENDAR #######################################################################################################
