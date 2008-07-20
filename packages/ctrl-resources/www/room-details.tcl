ad_page_contract {
    A page to display detailed information about a room as well as reservation information.

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$

    @param from_date the date as a list with the following elements in order: yyyy mm dd [hh12 mi ampm OR the time as army time]
    @param to_date the date as a list with the following elements in order: yyyy mm dd [hh12 mi ampm OR the time as army time]

    @param request_id if editing
} {
    {room_id:notnull}
    {event_id:optional}
    {request_id:optional}
    {all_day_p ""}
    {all_day_date:optional ""}
    {from_date:optional ""}
    {to_date:optional ""}
    {context:optional ""}
    {return_url [get_referrer]}
    {julian_date:optional ""}
    {ansi_date:optional ""}
    {calendar_click_p "0"}
    {eq:optional ""}
}

set user_id [ad_conn user_id]
set page_title "Room Details"

set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

set page_context $context

set passable_context $context
if {!$calendar_click_p} {
    lappend page_context {Room Details}
} else {
    set page_context "Room Details"
}
if {[exists_and_not_null request_id]} {
    set edit_p 1
} else {
    set edit_p 0
}

crs::room::get -room_id $room_id -column_array "room_info"
ctrl::address::get -address_id $room_info(address_id) -column_array "address_info"
set has_address_info_p [array exists address_info]

# --------------------------------------------------
# Construct the list of reservable equipments 
# --------------------------------------------------
set room_eq [crs::resource::find_child_resources -resource_id $room_id]
set room_resv_equip_list [db_list_of_lists room_resv_equipment {**SQL**}]

set room_eq_options [list]
set default_eq_options [list]
set room_has_eq_p 0

if {[llength $room_resv_equip_list] > 0} {
    set room_has_eq_p 1
    foreach res_info $room_resv_equip_list {
	set res_id [lindex $res_info 0]
	set res_name [lindex $res_info 1]
	set res_category_id [lindex $res_info 2]
	
	lappend room_eq_options [list $res_name $res_id]
	if {[lsearch -exact $eq $res_category_id] != -1} {
		lappend default_eq_options $res_id
	}
	}
} 

# ----------------------------------
# Construct the list of default equipments for room
# ----------------------------------
set default_equipment_list [db_list default_equipment {**SQL**}]
set default_equipment_display [join $default_equipment_list ", "]

set general_available_eq [db_list_of_lists general_resv_equipment {}]
#set general_available_eq [lindex [ctrl::list::lists_minus $general_available_eq $room_eq_options] 0]

# --------------
# Initialize the list option list for selects and radios
# ---------------
set yes_no_options [list [list "No" 0] [list "Yes" 1] ]
set resource_type_options [list [list "Select One ..." -1]]
set resource_type_options [concat $resource_type_options [db_list_of_lists get_type_options {}]]
set js_code [crs::util::build_branch_js]

#parse a possible passed in date
set default_dates_p 0

set today_date ""
set today_date_end ""

set object_types [db_list_of_lists get_object_types {}]

if {[exists_and_not_null request_id]} {
    set submit_btn "Update Reservation"
} else {
    set submit_btn "Create Reservation"
    #generate an event_id for a new request
    #set event_id [db_nextval acs_object_id_seq]
    
    if {[empty_string_p $all_day_p] || !$all_day_p} {
	#parse start and end date
	if { [empty_string_p [lindex $from_date 0]] || [empty_string_p [lindex $from_date 0]] } {
	    set default_dates_p 1
	} else {
	    if {[llength $from_date] == 6} {
		#hack the date widget to make it army time because ad_form won't take am/pm correctly
		if {[string equal [lindex $from_date 5] "pm"]} {
		    set from_date [lreplace $from_date 3 3 [expr [lindex $from_date 3]+12]]
		}
		set from_date [lreplace $from_date 5 5]
		
		if {[string equal [lindex $to_date 5] "pm"]} {
		    set to_date [lreplace $to_date 3 3 [expr [lindex $to_date 3]+12]]
		}
		set to_date [lreplace $to_date 5 5]
	    }
	    set today_date     [join $from_date " "]
	    set today_date_end [join $to_date " "]
	}
    } else {
	
	#parse all day
	if {  [empty_string_p [lindex $all_day_date 0]]} {
	    set default_dates_p 1
	} else {
	    set today_date "[join $all_day_date " "] 0 5 am"
	    set today_date_end "[join $all_day_date " "]  23 55 pm"
	    
	}
    }
}


#set default_dates_p 1
if {$default_dates_p} {
    set today_date [clock format [clock seconds] -format "%Y %m %d %H %M"]
    set today_date_end [clock format [clock scan "1 hour" -base [clock seconds]] -format "%Y %m %d %H %M"]
}


#adjust all_day_p to be set to t if =1
if {![empty_string_p $all_day_p]} {
    set all_day_p_option "t"
} else {
    set all_day_p_option "f"
}


# SET UP EVENT FORM ##############################################################################################################

ad_form -name "add_edit_event" -method post -action {reserve-confirm} -form {
    request_id:key
    {room_id:text(hidden) {value $room_id}}
    {context:text(hidden) {value $context}}
    {event_code:text(hidden) {value {}}}
    {title:text(text) {label "Event Title: "} }
    {description:text(text) {label "Description: "}}
    {start_date:date,to_sql(sql_date),from_sql(sql_date) {label "Start Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help}}
    {end_date:date,to_sql(sql_date),from_sql(sql_date) {label "End Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help}}
    {all_day_p:boolean(checkbox),optional {label "All Day Event: "} {options {{"" "t"}} {value $all_day_p_option}} {after_html "(If selected, time will not be used.)"}}
    {repeat_template_p:boolean(checkbox),optional {label "Repeating Event: "} {options {{"" t}} {value $repeat_template_p}}}
    {specific_days_week:text(checkbox),multiple {label "Days"} \
	 {options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
    {specific_days_month:text(select) {label "Days"} \
	 {options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
    {frequency_type:text(radio) {label ""} {options {{"Daily" daily} {"Weekly" weekly} {"Monthly" monthly} {"Yearly" yearly}}} {optional}}
    {frequency_day:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_week:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_month:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_year:integer(text) {label "Frequency: "} {html {size 2}} {value {1}} {hidden} {optional}}
    {specific_day_frequency:text(select) {label ""} {options {{"first" first} {"second" second} {"third" third} {"fourth" fourth} {"last" last}}} {optional}}
    {specific_dates_of_month_month:integer(text) {label ""} {html {size 2}} {optional}}
    {specific_dates_of_month_year:integer(text) {label ""} {html {size 2}} {optional}}
    {specific_months:text(select) {label ""} {options {{"" ""} {"January" 1} {"February" 2} {"March" 3} \
	                                               {"April" 4} {"May" 5} {"June" 6} \
						       {"July" 7} {"August" 8} {"September" 9} \
						       {"October" 10} {"November" 11} {"December" 12}}} {optional}}
    {repeat_month_opt1:text(radio) {label ""} {options {{"Day" 1}}} {optional}}
    {repeat_month_opt2:text(radio) {label ""} {options {{"The" 1}}} {optional}}
    {repeat_end_date_opt:text(radio) {label "End Date: "} {options {{"No End Date" 0} {"Until" 1}}} {value {0}}}
    {repeat_end_date:date,to_sql(sql_date) {label ""} {format "YYYY/MM/DD"} {help} {value $today_date} {optional}}
    {room_eq_check:text(checkbox),multiple,optional {label {test}}       {options $room_eq_options} {values $default_eq_options }  }
    {gen_eq_check:text(checkbox),multiple,optional {label {test}}       {options $general_available_eq}}
    {update_future_p:boolean(checkbox),optional {label "Update All Future Requests: "} {options {{"" t}}} {after_html "Check if you want to update all future requests"}}
    {submit:text(submit) {label "   $submit_btn   "}}
} -validate {
    {
	end_date
	{[template::util::date::compare $end_date $start_date] > 0}
	"End date must be after the start date"
    }
} -after_submit {
    ad_returnredirect $return_url
} -new_request {
    set start_date $today_date
    set end_date $today_date_end

} -edit_request {
    #if there was a request_id then we are editing a current reservation
    #gather all the old data
    crs::request::get -request_id $request_id -column_array "request_info"
    set title $request_info(name)
    set description $request_info(description)
    #set room_event_id [db_string get_room_id_for_request {} -default 0]
   
    if {$event_id !=0} {
	if {[crs::event::get -event_id $event_id -date_format "'yyyy mm dd hh24 mi'" -column_array "event_info"]} {
	    set start_date $event_info(start_date)
	    set end_date   $event_info(end_date)
	    set all_day_p $event_info(all_day_p)
	    set repeat_template_p $event_info(repeat_template_p)
	    set event_code $event_info(event_code)
	    #look for the reserved equipment
	    set room_eq_check [db_list get_equipment_list {}]
	    set gen_eq_check  $room_eq_check
	} else {
	    ad_return_complaint 1 "Invalid event_id"
	    ad_script_abort
	}
    } 
}  -export {all_day_date from_date to_date ansi_date julian_date calendar_click_p event_id} 

# END SET UP EVENT FORM ##########################################################################################################


# SET UP MONTH WIDGET  ###########################################################################################################
if {![empty_string_p $ansi_date]} { 
    set current_date $ansi_date
} {
    set current_date [dt_sysdate]
    set ansi_date $current_date
} 

set current_date_list [split $current_date "-"]
set year  [lindex $current_date_list 0]
set month [string trimleft [lindex $current_date_list 1] 0]
set day   [string trimleft [lindex $current_date_list 2] 0]
set julian_date [dt_ansi_to_julian $year $month $day]

set next_month_template "( <a href=\"room-details?[export_url_vars room_id eq context=[ad_urlencode context] from_date to_date]&calendar_click_p=1&ansi_date=\$ansi_date\">></a> )"

set prev_month_template "( <a href=\"room-details?[export_url_vars room_id eq context=[ad_urlencode context] from_date to_date]&calendar_click_p=1&ansi_date=\$ansi_date\"><</a> )"
set day_number_template "<a href=calendar/view-day?[export_url_vars room_id ]&julian_date=\$julian_date>\$day_number</a>"

set view_monthly_link "<a href=\"calendar/view-month?[export_url_vars room_id]\">View Month</a>"
set view_weekly_link "<a href=\"calendar/view-week?[export_url_vars room_id]\">View Week</a>"
set view_daily_link "<a href=\"calendar/view-day?[export_url_vars room_id]\">View Day</a>"

set calendar [crs::calendar::monthly_view -room_id $room_id \
		  -julian_date $julian_date -prev_month_template $prev_month_template \
		  -next_month_template $next_month_template -day_number_template $day_number_template]

# END SETTING UP MONTH WIDGET  ###################################################################################################

#List Repeating requests if available
if {[exists_and_not_null request_id]} {
    set repeat_template_id [db_string get_repeat_template_id {}]
} else {
    set repeat_template_id ""
    set request_id ""
}

db_multirow -extend {edit_link} get_repeat_reservation get_repeat_reservation {} {
    set edit_link "room-details?room_id=$room_id&request_id=$request_id1&event_id=$event_id1"
}

if {![exists_and_not_null $repeat_template_id]} {
    set repeat_template_p "t"
}
