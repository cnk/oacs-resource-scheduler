# -*- tab-width: 4 -*-
ad_page_contract {
    A page to add/edit repeating reservations.

	@author			veronica@viaro.net
	@creation-date	20/05/2008
	@cvs-id			$Id$

    @param room_id
    @param admin_p
    @param julian_date
    @param eq
    @param return_url
	@param request_id if editing
    @param event_id if editing
} {
}

set internal_date			[dt_julian_to_unix $julian_date]
set new_p					[ad_form_new_p -key request_id]

# Construct the list of reservable equipment
set room_eq						[crs::resource::find_child_resources -resource_id $room_id]
set room_resv_equip_list		[db_list_of_lists room_resv_equipment ""]
set room_eqpmt_options			[list]
set default_eqpmt_options		[list]
set room_has_eqpmt_p			0

if {[llength $room_resv_equip_list] > 0} {
	set room_has_eqpmt_p 1
	foreach res_info $room_resv_equip_list {
		set res_id			[lindex $res_info 0]
		set res_name		[lindex $res_info 1]
		set res_category_id	[lindex $res_info 2]

		lappend room_eqpmt_options [list $res_name $res_id]

		if {[lsearch -exact $eq $res_category_id] != -1} {
			lappend default_eqpmt_options $res_id
		}
	}
}

# Construct the list of default equipments for room
set general_available_eq		[db_list_of_lists general_resv_equipment ""]

# Initialize the list option list for selects and radios
set yes_no_options			[list [list "No" 0] [list "Yes" 1] ]
set resource_type_options	[list [list "Select One ..." -1]]
set resource_type_options	[concat $resource_type_options [db_list_of_lists get_type_options ""]]
set object_types			[db_list_of_lists get_object_types ""]

set days_of_the_week {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}
set months_of_the_yr {{"" ""} {"January" 1} {"February" 2} {"March" 3} {"April" 4} {"May" 5} {"June" 6} {"July" 7} {"August" 8} {"September" 9} {"October" 10} {"November" 11} {"December" 12}}

# Set up submit button name
if {$new_p} {
	set submit_label "Create Reservation"
} else {
	set submit_label "Update Reservation"
}

# SET UP EVENT FORM ############################################################
ad_form -name "add_edit_event" -method post -action {repeating-reserve-confirm} -form {
	{request_id:key}
	{room_id:text(hidden) {value $room_id}}
	{event_code:text(hidden) {value {}}}
	{title:text(text)										{label "Event Title: "} }
	{description:text(textarea) 							{label "Description: "} {html {rows 3 cols 40}}}
    {event_start_time:date,to_sql(linear_date),from_sql(sql_date),to_html(sql_date)  
                                                            {label "Event Start Time"} {minutes_interval {0 59 5}} {format "HH12:MI AM"} {help}
    }
    {event_duration_days:text,optional                      {label "Days"} {html {size 3 maxlength 3}} {help_text "Days"} {value 0}}
    {event_duration_hm:date,to_sql(linear_date),from_sql(sql_date),to_html(sql_date)  
                                                    		{label ""} {minutes_interval {0 59 5}} {format "HH24 MI"} {help}
    }
	{start_date:date,to_sql(sql_date),from_sql(sql_date)	{label "Start Date: "}	{minutes_interval {0 59 5}} {format "YYYY/MM/DD"} {help}}
	{end_date:date,to_sql(sql_date),from_sql(sql_date)		{label "End Date: "}	{minutes_interval {0 59 5}} {format "YYYY/MM/DD"} {help}}
	{all_day_p:boolean(checkbox),optional					{label "All Day Event: "}	{options {{"" t}} {value f}} {after_html "(If selected, time will not be used.)"}}
	{repeat_template_p:text(hidden) 			            {label "Repeating Event: "}	{value "t"}}
	{specific_days_week:text(checkbox),multiple 			{label "Days"}	{options $days_of_the_week} {optional}}
	{specific_days_month:text(select)						{label "Days"}	{options $days_of_the_week} {optional}}
	{frequency_type:text(radio) 							{label ""}		{options {{"Daily" daily} {"Weekly" weekly} {"Monthly" monthly} {"Yearly" yearly}}} {optional}}
	{frequency_day:integer(text) 							{label "Frequency: "} {html {size 2}} {optional}}
	{frequency_week:integer(text) 							{label "Frequency: "} {html {size 2}} {optional}}
	{frequency_month:integer(text) 							{label "Frequency: "} {html {size 2}} {optional}}
	{frequency_year:integer(text) 							{label "Frequency: "} {html {size 2}} {value {1}} {hidden} {optional}}
	{specific_day_frequency:text(select) 					{label ""} {options {{"first" first} {"second" second} {"third" third} {"fourth" fourth} {"last" last}}} {optional}}
	{specific_dates_of_month_month:integer(text)			{label ""} {html {size 2}} {optional}}
	{specific_dates_of_month_year:integer(text) 			{label ""} {html {size 2}} {optional}}
	{specific_months:text(select) 							{label ""} {options $months_of_the_yr} {optional}}
	{repeat_month_opt1:text(radio) 							{label ""} {options {{"Day" 1}}} {optional}}
	{repeat_month_opt2:text(radio) 							{label ""} {options {{"The" 1}}} {optional}}
	{repeat_end_date_opt:text(radio) 						{label "End Date: "} {options {{"Until" 1} {"No End Date" 0}}} {value {1}}}
	{repeat_end_date:date,to_sql(sql_date) 					{label ""} {format "YYYY/MM/DD"} {help} {optional}}
	{room_eqpmt_check:text(checkbox),multiple,optional 		{label {test}}	{options $room_eqpmt_options} {values $default_eqpmt_options}}
	{gen_eqpmt_check:text(checkbox),multiple,optional 		{label {test}}	{options $general_available_eq}}
	{update_future_p:boolean(checkbox),optional 			{label "Update All Future Requests: "} {options {{"" t}}} {after_html "Check if you want to update all future requests"}}
	{submit:text(submit) 									{label "$submit_label"}}
} -validate {
	{	end_date
		{[template::util::date::compare $end_date $start_date] > 0}
		"End date must be after the start date"
	}
} -after_submit {
	template::forward $return_url
} -new_request {
	set internal_date_w_tm	[expr $internal_date + ([clock format [clock seconds] -format %k]*3600)]
	set start_date			[clock format $internal_date_w_tm				-format "%Y %m %d %H %M"]
	set end_date			[clock format [expr $internal_date_w_tm + 3600]	-format "%Y %m %d %H %M"]    
    set event_start_time    $start_date
	set repeat_end_date		$start_date
    set event_duration_hm   "[lrange $start_date 0 2] 00 00"
} -edit_request {
	# if there was a request_id then we are editing a current reservation
	# gather all the old data
	crs::request::get -request_id $request_id -column_array "request_info"
	set title		$request_info(name)
	set description	$request_info(description)
	if {$event_id !=0} {
		if {[crs::event::get -event_id $event_id -date_format "'yyyy mm dd hh24 mi'" -column_array "event_info"]} {
			set start_date			$event_info(start_date)
            set event_start_time    $event_info(start_date)
			set end_date			$event_info(end_date)           
			set all_day_p			$event_info(all_day_p)
			set repeat_template_p	$event_info(repeat_template_p)
			set event_code			$event_info(event_code)


            #Calculation of Event Duration Time from End Date
            set duration_time [db_string calc_event_duration_time ""]
            set duration_time_days 0
            set duration_time_hours 0
            set duration_time_min 0            

            if { $duration_time >= 1} {
               #This means that the event_duration is greater than 1 day
			   set duration_time_list [split $duration_time "."]               
			   set duration_time_days [lindex $duration_time_list 0]
               #ns_log Notice "VLC -duration_time $duration_time -list $duration_time_list"
               #Means that time is $duration_time_days days and with some remaining hours/minutes.
               if {[llength $duration_time_list] > 1} {
			      set duration_time_hours [expr "0.[lindex $duration_time_list 1]" * 1440]
               }
            } else {
               #This means that the event duration time is only hours:min
			   set duration_time_hours [expr $duration_time * 1440]
            }

            #Separate event duration time into hours and minutes, this 
            #is to get the correct format for duration time: #days, #hours, #minutes
            #ns_log Notice "VLC -duration_time_hours $duration_time_hours"
			if { [expr [format "%.0f" $duration_time_hours] % 60] == 0} {
               #In here we have exact hours, meaning we have multiples of 60 (Ex. 60, 120, 180, ...)
			   set duration_time_hours [format "%.0f" [expr $duration_time_hours / 60]]
            } else {
               #In here we have hours with remaining minutes, or only minutes (Ex, 40, 70, 80, ...)
			   set dt_hours_aux [split [expr $duration_time_hours / 60] "."]
			   set duration_time_hours [format "%.0f" [lindex $dt_hours_aux 0]]
			   set duration_time_min [format "%.0f" [expr "0.[lindex $dt_hours_aux 1]" * 60]]               
            }
            
            #If hours or minutes is only 1 digit, append a 0 to the left.
            #This is only for date format.
            if { $duration_time_hours < 10 } { set duration_time_hours "0$duration_time_hours"}  
            if { $duration_time_min < 10 } { set duration_time_min "0$duration_time_min"}  

            #Finally we can construct the event duration time
            set event_duration_days $duration_time_days
            set event_duration_hm "[lrange $end_date 0 2] $duration_time_hours $duration_time_min"
            #########################################################################################
            #ns_log Notice "VLC -event_duration -days $event_duration_days -hm $event_duration_hm"
			# look for the reserved equipment
			set room_eqpmt_check	[db_list get_equipment_list ""]
			set gen_eqpmt_check		$room_eqpmt_check
		} else {
			ad_return_complaint 1 "Invalid event_id"
			ad_script_abort
		}
	}
}  -export {all_day_date julian_date calendar_click_p event_id}
# END SET UP EVENT FORM ########################################################

# List Repeating requests if available
if {[exists_and_not_null request_id]} {
	set repeat_template_id	[db_string get_repeat_template_id ""]
} else {
	set repeat_template_id	""
	set request_id			""
}

db_multirow -extend {edit_url} get_repeat_reservation get_repeat_reservation "" {
	set edit_url [export_vars -base room-details {room_id request_id {event_id $event_id1}}]
}

#if {![exists_and_not_null $repeat_template_id]} {set repeat_template_p "t"}
