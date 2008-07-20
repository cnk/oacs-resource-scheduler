# /packages/ctrl-calendar/www/view-day.tcl

ad_page_contract {
    Daily View of Calendar

    @author jmhek@cs.ucla.edu
    @creation-date 1/31/2006
    @cvs-id $Id$
} {
    room_id:notnull
    {julian_date ""}
}

set user_id [ad_conn user_id]

crs::calendar::get -room_id $room_id -column_array cal_info
set cal_id $cal_info(cal_id)

permission::require_permission -party_id $user_id -object_id $cal_id -privilege read
#set create_p [permission::permission_p -party_id $user_id -object_id $cal_id -privilege create]
#Give permission to create a reservation, 
#since always will be allowed to make a reservation.
set create_p 1
set page_title "$cal_info(cal_name) - Daily View  "
set context [list [list [export_vars -base ../room-details room_id] $cal_info(room_name)] "Calendar -  Daily View"]

# set current date
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

# create day view widget
set next_julian_date [expr $julian_date + 1]
set previous_julian_date [expr $julian_date - 1]
set tomorrow_template "<a href=\"view-day?[export_url_vars room_id julian_date=$next_julian_date]\">Tomorrow</a>"
set yesterday_template "<a href=\"view-day?[export_url_vars room_id julian_date=$previous_julian_date]\">Yesterday</a>"

set day_view [crs::calendar::daily_view -room_id $room_id -current_julian_date $julian_date \
		  -start_time 8 -end_time 20 -interval 30 -tomorrow_template $tomorrow_template \
		  -yesterday_template $yesterday_template -manage_p $create_p]

