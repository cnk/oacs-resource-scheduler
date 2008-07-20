# -*- tab-width: 4 -*-
ad_page_contract {
    A page to add/edit non repeating reservations.

	@author			veronica@viaro.net (VLC)
	@creation-date	20/05/2008
	@cvs-id			$Id$

    @param room_id
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

# Set up submit button name
if {$new_p} {
	set submit_label "Create Reservation"
} else {
	set submit_label "Update Reservation"
}

# SET UP EVENT FORM ############################################################
ad_form -name "add_edit_event" -method post -action {reserve-confirm} -form {
	{request_id:key}
	{room_id:text(hidden) {value $room_id}}
	{event_code:text(hidden) {value {}}}
	{title:text(text)										{label "Event Title: "} }
	{description:text(textarea) 							{label "Description: "} {html {rows 3 cols 40}}}
	{start_date:date,to_sql(sql_date),from_sql(sql_date)	{label "Start Date: "}	{minutes_interval {0 59 5}} {format "YYYY/MM/DD HH12:MI AM"} {help}}
	{end_date:date,to_sql(sql_date),from_sql(sql_date)		{label "End Date: "}	{minutes_interval {0 59 5}} {format "YYYY/MM/DD HH12:MI AM"} {help}}
	{all_day_p:boolean(checkbox),optional					{label "All Day Event: "}	{options {{"" t}} {value f}} {after_html "(If selected, time will not be used.)"}}
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
	set repeat_end_date		$start_date
} -edit_request {
	# if there was a request_id then we are editing a current reservation
	# gather all the old data
	crs::request::get -request_id $request_id -column_array "request_info"
	set title		$request_info(name)
	set description	$request_info(description)
	if {$event_id !=0} {
		if {[crs::event::get -event_id $event_id -date_format "'yyyy mm dd hh24 mi'" -column_array "event_info"]} {
			set start_date			$event_info(start_date)
			set end_date			$event_info(end_date)
			set all_day_p			$event_info(all_day_p)
			set repeat_template_p	$event_info(repeat_template_p)
			set event_code			$event_info(event_code)

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

