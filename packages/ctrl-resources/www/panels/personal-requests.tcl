##Includable page 
## Author Jeff Wang (jeff@ctrl.ucla.edu)
##Param on parent page
##
## @history = 1 to show all history, 0 shows current events only
##

set user_id [auth::require_login]
set package_id [ad_conn package_id]

if {![info exists history]} {
    set history 0
}

if {$history} {
    set toggle_history_link [ad_conn url]?[export_url_vars history=0]
    set history_label "Show Upcoming Events"
    set filter ""
} else {
    set toggle_history_link [ad_conn url]?[export_url_vars history=1]
    set history_label "Show All Events"
    set filter "and start_date>= to_char(sysdate,'YYYY-MM-DD')"
}

#bg color is used to group requests events by color. 
set cur_bg_color "#ffffff"
set next_bg_color "#dddddd"
set cur_request_id 0

db_multirow -extend {bg_color details_url room_p room_reserve_url delete_url edit_url}  personal_events personal_events {} {

    set room_p [crs::room::is_room_p -resource_id $event_object_id]
    set context [list [list  [ad_conn url]?[export_url_vars history=$history] "Personal Requests"]]
    
    
    if {$room_p} {
	set delete_url "reservation-delete-confirm?[export_url_vars request_or_event_id=$request_id]"
	set edit_url "room-details?[export_url_vars room_id=$event_object_id request_id=$request_id event_id=$event_id]"
	set room_reserve_url "room-details?[export_url_vars room_id=$event_object_id context=[ad_urlencode $context]]"
	set details_url "reservation-details?[export_url_vars request_id]"
    } else {
	set delete_url "equipment-reservation-delete-confirm?[export_url_vars request_or_event_id=$event_id request_type=resource]"
	set edit_url "equipment-details?[export_url_vars resource_id=$event_object_id request_id=$request_id event_id=$event_id]"
	set room_reserve_url "equipment-details?[export_url_vars resource_id=$event_object_id context=[ad_urlencode $context]]"
	set details_url "equipment-reservation-details?[export_url_vars request_id]"
    }
    
    if {$request_id != $cur_request_id} {
	set cur_request_id $request_id
	set temp_bg_color $cur_bg_color
	set cur_bg_color  $next_bg_color
	set next_bg_color $temp_bg_color
	set bg_color $cur_bg_color
    } else {
	set bg_color $cur_bg_color
    }
    
}




