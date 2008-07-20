# An includable page to show the details of the reservation
#
# @param Request_id the request_id for the reservation
# @param Update_status_p if 1, then display a formwidget to update the status
#

set user_id [auth::require_login]
if { [template::util::is_nil request_id] } {
    set request_id ""
}
if { [template::util::is_nil update_status_p] } {
    set update_status_p 0
}
if { [template::util::is_nil event_id] } {
    set event_id ""
}

#permission::require_permission -object_id $request_id -privilege "read"
set admin_p [permission::permission_p -object_id $request_id -privilege "admin"]
set write_p [permission::permission_p -object_id $request_id -privilege "write"]
set delete_p [permission::permission_p -object_id $request_id -privilege "delete"]

set status_options [list [list [list "approved" "approved" ] [list "denied" "denied" ] [list "pending" "pending" ] [list "cancelled" "cancelled"]]]

#form for updating status
ad_form -name "update" -method post -form {
    {update_all_p:boolean(checkbox),optional {label "Update all future status"} {options {{"" t}}} {after_html "Check if you want to update the status of all future requests"}}
}

db_multirow -extend {room_p edit_url delete_url widget_name status_update_url request_status} get_events get_events {} {
    set room_p [crs::room::is_room_p -resource_id $event_object_id]

    if {$room_p} {
	set edit_url "room-details?[export_url_vars room_id=$event_object_id request_id=$request_id2 event_id=$event_id2]"
	set delete_url "reservation-delete-confirm?[export_url_vars request_or_event_id=$request_id2]"
	set status_update_url "reservation-details?[export_url_vars room_id=$event_object_id request_id=$request_id2 update_status_p=1 event_id=$event_id2]"
	crs::request::get -request_id $request_id2 -column_array request_info
	set request_status $request_info(status)
	ad_form -extend -name "update" -form "{request_status_$request_id2:text(select),optional {options $status_options} {value $request_status}}"
    } else {
	set delete_url "reservation-delete-confirm?[export_url_vars request_or_event_id=$event_id2 request_type=resource]"
    }
} 

#repeating events
set repeat_template_id [crs::request::get_repeat_template_id -request_id $request_id]

db_multirow -extend {room_p request_item_count edit_url delete_url widget_name status_update_url request_status} get_repeating_events get_repeating_events {} {
    set room_p [crs::room::is_room_p -resource_id $event_object_id]
    set request_item_count [db_string count {}]

    if {$room_p} {
	set edit_url "room-details?[export_url_vars room_id=$event_object_id request_id=$request_id2 event_id=$event_id2]"
	set delete_url "reservation-delete-confirm?[export_url_vars request_or_event_id=$request_id2]"
	set status_update_url "reservation-details?[export_url_vars room_id=$event_object_id request_id=$request_id2 update_status_p=1 event_id=$event_id2]"

	crs::request::get -request_id $request_id2 -column_array request_info
	set request_status $request_info(status)
	ad_form -extend -name "update" -form "{request_status_$request_id2:text(select),optional {options $status_options} {value $request_status}}"
    } else {
	set delete_url "reservation-delete-confirm?[export_url_vars request_or_event_id=$event_id2 request_type=resource]"
    }
}

ad_form -extend -name "update" -form {
    {sub:text(submit) {label "OK"}}        
} -on_submit {
    #assume conflict
    set conflict_p 1

    if {[empty_string_p $update_all_p]} {
	set update_all_p "f"
    } else {
	set update_all_p "t"
    }

    set status [set request_status_$request_id]

    set dates [lindex [db_list_of_lists get_event_dates {}] 0]
  
    set sd "to_date('[lindex $dates 0]', 'YYYY MM DD HH24 MI')"
    set ed "to_date('[lindex $dates 1]', 'YYYY MM DD HH24 MI')"

    #look for conflicts only if status is 'approved' or 'pending'
    if {$status == "approved" || $status == "pending"} {	
	if {!$update_all_p} {
	    #check for conflicts, approves if no conflicts, otherwise recirect to confirma page
	    # get event id and update
	    if {[crs::reservable_resource::check_availability -event_id $event_id \
		     -resource_id $room_id -start_date $sd -end_date $ed]} {
		crs::request::update_status -request_id $request_id -status $status	
		set conflict_p 0
	    }
	}
    } else {	
	set conflict_p 0
	if {$update_all_p} {
	    # Get future request_id
	    set request_id_list [db_list get_request_ids {}]
	} else {
	    set request_id_list [list $request_id]
	}

	# Update status and return url to itself
	foreach request_ids $request_id_list {
	    crs::request::update_status -request_id $request_ids -status $status
	}	    
    }

    # If there is a conflict in reservation, redirect to confirm page warning to override
    if {$conflict_p} {
	# Set date array 
	set date_list [list year month day hours minutes ampm]  
	set sd_list [split [lindex $dates 2] " "]
	set ed_list [split [lindex $dates 3] " "]
	
	foreach item $date_list sd_item $sd_list ed_item $ed_list {
	    set start_date($item) $sd_item
	    set end_date($item) $ed_item
	}

	#description and all_day_p room_eq_check
	ad_returnredirect "reserve-confirm?[export_url_vars room_id request_id title event_id context return_url \
                                                    description all_day_p update_future_status_p=$update_all_p \
                                                    start_date.year=$start_date(year) start_date.month=$start_date(month) \
                                                    start_date.day=$start_date(day) start_date.short_hours=$start_date(hours) \
                                                    start_date.minutes=$start_date(minutes) start_date.ampm=$start_date(ampm) \
                                                    end_date.year=$end_date(year) end_date.month=$end_date(month) \
                                                    end_date.day=$end_date(day) end_date.short_hours=$end_date(hours) \
                                                    end_date.minutes=$end_date(minutes) end_date.ampm=$end_date(ampm) \
                                                    room_eq_check]"
    }
} -after_submit {
    ad_returnredirect "reservation-details?[export_url_vars request_id=$request_id]"
} -export {
    request_id 
    update_status_p
    event_id
    room_id
}
