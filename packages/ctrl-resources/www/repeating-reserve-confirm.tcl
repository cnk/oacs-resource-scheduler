ad_page_contract {
    A page that allows you confirm your reservation or fix any conflicts before confirming

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$

    @param request_id is passed in if editing
} {
    {room_id:notnull}
    {request_id:notnull}
    {event_id:optional ""}
    {context:optional ""}
    {return_url [get_referrer]}
    {title:notnull}
    {description ""}
    {additional_service ""}
    {event_start_time:array ""}
    {event_duration_days:optional 0}
    {event_duration_hm:array ""}
    {start_date:array,date ""}
    {end_date:array,date ""}
    {start_date_sql ""}
    {end_date_sql ""}
    {all_day_p ""}
    {repeat_template_p ""}
    {specific_days_week:multiple ""}
    {specific_days_month ""}
    {frequency_type ""}
    {frequency_day ""}
    {frequency_week ""}
    {frequency_month ""}
    {frequency_year ""}
    {specific_day_frequency ""}
    {specific_dates_of_month_month ""}
    {specific_dates_of_month_year ""}
    {specific_months ""}
    {repeat_month_opt1 ""}
    {repeat_month_opt2 ""}
    {repeat_end_date_opt ""}
    {repeat_end_date:array,date ""}
    {repeat_end_date_sql ""}
    {room_eqpmt_check:multiple ""}
    {gen_eqpmt_check:multiple ""}
    {event_code ""}
    {update_future_p ""}
    {update_future_status_p ""}
} 

set user_id    [auth::require_login]
set user_name  [person::name -person_id $user_id]
set page_title "Confirm Reservation"
set room_admin_p [permission::permission_p -object_id $room_id -privilege "admin"]

set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

set request_repeat_template_id ""
set event_repeat_template_id ""		
set msg "No"
set internal_eq ""
set external_eq ""


# Variables for search page
set from_date_list [list]
set to_date_list [list]
set all_day_date_list [list]

if {![empty_string_p $context]} {
    lappend context $page_title
} else {
    set context [list [list $return_url "Room Details"] $page_title]
}

if {[empty_string_p $all_day_p]} {set all_day_p "f"}
if {[empty_string_p $update_future_p]} {set update_future_p "f"}
if {[empty_string_p $update_future_status_p]} {set update_future_status_p "f"}
if {[empty_string_p $repeat_template_p]} {set repeat_template_p "f"}

# Get room information
crs::room::get -room_id $room_id -column_array "room_info"
# -----------------------------------------------------------
# Set the status
# -----------------------------------------------------------
set status "approved"
if {$room_info(approval_required_p)} {
    if {!$room_admin_p} {set status "pending"}
} 

# ---------------------------------------------------------------
# Is this a new request or an update? 
# Need to check request id under both request_id and repeat_template_id
# ---------------------------------------------------------------
set updating_p [db_string check_exists {} -default 0]
if {$updating_p == 0} {
    if {[db_string check_exists_repeat {}] > 0} {
	set updating_p 1
    } else {
	set updating_p 0
    }
}

# ---------------------------------------------------------------
# Format Dates to display and used for queries
# ---------------------------------------------------------------

if {[array size start_date] != 0 && [array size event_start_time] != 0} {
    #Construct the proper start_date with the event_start_time. This is bc in
    #repeating events start_date is divided in 2: start_date (contains only the date)
    #and event_start_time contains only the start_time of resv.
    set start_date(format) "$start_date(format) $event_start_time(format)"
    set start_date(short_hours) "$event_start_time(short_hours)"
    set start_date(minutes) "$event_start_time(minutes)"
    set start_date(ampm) "$event_start_time(ampm)"
    
    set start_date_pretty [ctrl_event::date_util::get_date_str -date_ary_param start_date \
			-date_ary_reference_param "" \
			-all_day_p $all_day_p \
			-start_date_p 1 \
			-sql_p 0 \
			 -time_p 1]
    set start_date_sql [ctrl_event::date_util::get_date_str -date_ary_param start_date \
			    -date_ary_reference_param "" \
			    -all_day_p $all_day_p \
			    -start_date_p 1 \
			    -sql_p 1 \
			    -time_p 1]

    #Since we don't have end_date anymore, we need to construct it
    #from start_date + event_duration_time.    
    set ed_days_1 [expr $event_duration_hm(hours) / 24.0] 
    set ed_days_2 [expr $event_duration_hm(minutes) / 1440.0] 
    #Here we have event_duration_time converted in days, so we can 
    #add the number of days to the start_date and the result 
    #will be the end_date
    set ed_days [expr $event_duration_days + $ed_days_1 + $ed_days_2]    
    set ed_list [split [db_string calc_end_date ""] " "]    
    
    #Construct the end_date array from the above list.
    if { [llength $ed_list] > 0 } {
       set end_date(format) "$start_date(format)"    
       set end_date(year) [lindex $ed_list 0] 
       set end_date(month) [lindex $ed_list 1]
       set end_date(day) [lindex $ed_list 2]
       set end_date(date) "$end_date(year)-$end_date(month)-$end_date(day)"
       set end_date(short_hours) [lindex $ed_list 3]
       set end_date(minutes) [lindex $ed_list 4]
       set end_date(ampm) [string tolower [lindex $ed_list 5]]
    } else { set end_date ""}
}

if {[array size end_date] != 0} {
    set end_date_pretty [ctrl_event::date_util::get_date_str -date_ary_param end_date \
			     -date_ary_reference_param start_date \
			     -all_day_p $all_day_p \
			     -start_date_p 0 \
			     -sql_p 0 \
			     -time_p 1]
    set end_date_sql [ctrl_event::date_util::get_date_str -date_ary_param end_date \
			  -date_ary_reference_param start_date \
			  -all_day_p $all_day_p \
			  -start_date_p 0 \
			  -sql_p 1 \
			  -time_p 1]
}

if {[array size repeat_end_date] != 0} {
    regsub -all {\-} $repeat_end_date(date) " " repeat_end_date(date)
    set repeat_end_date_pretty [ctrl_event::date_util::get_date_str -date_ary_param repeat_end_date \
				    -date_ary_reference_param repeat_end_date \
				    -all_day_p "t" \
				    -start_date_p 0 \
				    -sql_p 0 \
				    -time_p 0]

    regsub -all {\/} $repeat_end_date_pretty "-" repeat_end_date_pretty
    set repeat_end_date_sql "to_date('$repeat_end_date(date)', 'YYYY MM DD')"
} else {
    set repeat_end_date_pretty ""
}


# ---------------------------------------------------------------
# END Format Dates to display and used for queries
# ---------------------------------------------------------------

# Format multiple list
regsub -all {\{} $specific_days_week "" specific_days_week
regsub -all {\}} $specific_days_week "" specific_days_week
set room_eq_check $room_eqpmt_check
set gen_eq_check $gen_eqpmt_check

set event_date_list ""

# ---------------------------------------------------------------
# Get a list of start and end dates of the repeating event
# ---------------------------------------------------------------
if {$updating_p} {
    if {$update_future_p || $update_future_status_p} {
	set request_repeat_template_id [crs::request::get_repeat_template_id -request_id $request_id]
	set event_repeat_template_id [crs::event::get_repeat_template_id -event_id $event_id]
	ctrl_event::repetition::get -repeat_template_id $event_repeat_template_id -array "repeat_template_info"
	set repeat_month_opt [ctrl_event::repetition::get_month_opt -specific_day_frequency $repeat_template_info(specific_day_frequency) \
				  -specific_days $repeat_template_info(specific_days) \
				  -specific_dates_of_month $repeat_template_info(specific_dates_of_month) \
				  -specific_months $repeat_template_info(specific_months)]
	if {$repeat_month_opt == "1"} {
	    set repeat_month_opt1 1
	} elseif {$repeat_month_opt == "2"} {
	    set repeat_month_opt2 1
	} 

	# Displays repeating pattern if exists	
	set repeat_end_date_opt 1 	
	set msg [crs::event::repetition_pattern_text -frequency_type $repeat_template_info(frequency_type) \
		     -frequency_day $repeat_template_info(frequency) \
		     -frequency_week $repeat_template_info(frequency) \
		     -repeat_month_opt1 $repeat_month_opt1 \
		     -specific_dates_of_month_month $repeat_template_info(specific_dates_of_month) \
		     -specific_months $repeat_template_info(specific_months) \
		     -frequency_month $repeat_template_info(frequency) \
		     -specific_day_frequency $repeat_template_info(specific_day_frequency) \
		     -specific_days_month $repeat_template_info(specific_days) \
		     -specific_dates_of_month_year $repeat_template_info(specific_dates_of_month) \
		     -repeat_end_date_opt $repeat_end_date_opt -repeat_end_date_sql $repeat_template_info(end_date)]
	
	# Get all future events recalculated based on the new start dat
	regsub -all {\-} $repeat_template_info(end_date) " " repeat_template_info(end_date)
	set event_date_list [ctrl_event::repetition::repeat -event_id $event_id \
				 -frequency_type $repeat_template_info(frequency_type) \
				 -repeat_end_date_opt $repeat_end_date_opt \
				 -frequency_day $repeat_template_info(frequency) \
				 -frequency_week $repeat_template_info(frequency) \
				 -specific_days_week $repeat_template_info(specific_days) \
				 -frequency_month $repeat_template_info(frequency) \
				 -frequency_year $repeat_template_info(frequency) \
				 -specific_day_frequency $repeat_template_info(specific_day_frequency) \
				 -specific_days_week $repeat_template_info(specific_days) \
				 -specific_months $repeat_template_info(specific_months) \
				 -specific_days_month $repeat_template_info(specific_days) \
				 -specific_dates_of_month_month $repeat_template_info(specific_dates_of_month) \
				 -specific_dates_of_month_year $repeat_template_info(specific_dates_of_month) \
				 -repeat_month_opt1 $repeat_month_opt1 -repeat_month_opt2 $repeat_month_opt2 \
				 -repeat_end_date "to_date('$repeat_template_info(end_date)', 'YYYY MM DD')" \
				 -event_object_id $room_id -title $title \
				 -start_date $start_date_sql -end_date $end_date_sql -all_day_p $all_day_p \
				 -location "" -notes $additional_service -capacity "" \
				 -event_image "" -event_image_caption "" -category_id "" \
				 -context_id [ad_conn package_id] -package_id [ad_conn package_id] -add_event_p "f"]
    }
} else {

    if {$repeat_template_p == "t"} {

	set msg [crs::event::repetition_pattern_text -frequency_type $frequency_type -frequency_day $frequency_day \
		     -frequency_week $frequency_week -specific_days_week [join $specific_days_week ","] \
		     -repeat_month_opt1 $repeat_month_opt1 \
		     -specific_dates_of_month_month $specific_dates_of_month_month \
		     -specific_months $specific_months \
		     -frequency_month $frequency_month -specific_day_frequency $specific_day_frequency \
		     -specific_days_month $specific_days_month -specific_dates_of_month_year $specific_dates_of_month_year \
		     -repeat_end_date_opt $repeat_end_date_opt -repeat_end_date_sql $repeat_end_date_pretty]


	set event_date_list [ctrl_event::repetition::repeat -event_id $event_id -frequency_type $frequency_type \
				 -repeat_end_date_opt $repeat_end_date_opt \
				 -frequency_day $frequency_day -frequency_week $frequency_week \
				 -specific_days_week $specific_days_week \
				 -frequency_month $frequency_month -frequency_year $frequency_year \
				 -specific_day_frequency $specific_day_frequency \
				 -specific_days_week $specific_days_week -specific_months $specific_months \
				 -specific_days_month $specific_days_month \
				 -specific_dates_of_month_month $specific_dates_of_month_month \
				 -specific_dates_of_month_year $specific_dates_of_month_year \
				 -repeat_month_opt1 $repeat_month_opt1 -repeat_month_opt2 $repeat_month_opt2 \
				 -repeat_end_date $repeat_end_date_sql -event_object_id $room_id -title $title \
				 -start_date $start_date_sql -end_date $end_date_sql -all_day_p $all_day_p \
				 -location "" -notes $additional_service -capacity "" \
				 -event_image "" -event_image_caption "" -category_id "" \
				 -context_id [ad_conn package_id] -package_id [ad_conn package_id] -add_event_p "f"]

    }

}

   
# ---------------------------------------------------------------
# Set list of dates to check availability.  
# If event_date_list is empty based on repeating pattern or if it is a single request, use the form start/end dates
# ---------------------------------------------------------------
if {![empty_string_p $event_date_list]} {
    set start_date_list [lindex $event_date_list 0]
    set end_date_list [lindex $event_date_list 1]
} else {
    set start_date_list [list $start_date_sql]
    set end_date_list [list $end_date_sql]
}

# ---------------------------------------------------------------
# Set variables for overall availability
# ---------------------------------------------------------------
set room_available_all_p 1
set conflicting_request_id_all [list]
set conflicting_reserver_name_all [list]
set conflicting_reserver_email_all [list]
set conflicting_reserver_name_display [list]
# ---------------------------------------------------------------
# Loop for each repeating reservation, check for conflicts
# ---------------------------------------------------------------
foreach sd $start_date_list ed $end_date_list {
    if {$update_future_p || $update_future_status_p} {
	set room_available_p [crs::reservable_resource::check_availability -repeat_template_id $event_repeat_template_id \
				  -resource_id $room_id -start_date $sd -end_date $ed]
    } else {
	set room_available_p [crs::reservable_resource::check_availability -event_id $event_id \
				  -resource_id $room_id -start_date $sd -end_date $ed]	
    }

    # If the room is not available, gather extra information about previous reservations
    if {!$room_available_p} {		

	# Remember the first conflict date, used for alternative room search
	# room_available_all_p is initially set to 1 and only set to 0 after one reservation is not avaialbel
	if {$room_available_all_p} {
	    set start_date_temp [join [ctrl_event::date_util::parse_date -date_var $sd] " "]
	    set end_date_temp [join [ctrl_event::date_util::parse_date -date_var $ed] " "]

	    if {$all_day_p} {
		set all_day_date_list [list [lindex $start_date_temp 0]\
					   [lindex $start_date_temp 1]\
					   [lindex $start_date_temp 2]]
	    } else {
		set from_date_list [list "[lindex $start_date_temp 0]-[lindex $start_date_temp 1]-[lindex $start_date_temp 2]"\
					[lindex $start_date_temp 0]\
					[lindex $start_date_temp 1]\
					[lindex $start_date_temp 2]\
					[lindex $start_date_temp 3]\
					[lindex $start_date_temp 4]]		
		set to_date_list [list "[lindex $end_date_temp 0]-[lindex $end_date_temp 1]-[lindex $end_date_temp 2]"\
					[lindex $end_date_temp 0]\
					[lindex $end_date_temp 1]\
					[lindex $end_date_temp 2]\
					[lindex $end_date_temp 3]\
					[lindex $end_date_temp 4]]
	    }
	}

	# If at least one conflict, set flag to display conflict message
	set room_available_all_p 0

	set prev_reservations [crs::resource::reservation::previous_reservation -start_date $sd -end_date $ed -room_id $room_id]
	set conflicting_request_id [list [lindex $prev_reservations 0]]
	set conflicting_reserver_name [list [lindex $prev_reservations 1]]
	set conflicting_reserver_email [list [lindex $prev_reservations 2]]
        lappend conflicting_reserver_name_display [lindex $prev_reservations 1]
#        lappend conflicting_reserver_name_display [list "[join [lindex $prev_reservations 1] ""] for reservation on [ctrl_event::date_util::parse_date -date_var $sd]"]
    } else {
	set conflicting_request_id [list]
	set conflicting_reserver_name [list]
	set conflicting_reserver_email [list]
    }

    # Remember all variables for confirmation
    lappend conflicting_request_id_all $conflicting_request_id
    lappend conflicting_reserver_name_all $conflicting_reserver_name
    lappend conflicting_reserver_email_all $conflicting_reserver_email

    # NOTE: Similar to dates, you can't export multiples. The workaround is to make it a hidden but this will get passed in as a sublist.
    # We'll have to parse it out, if it's a sublist.
    if {[llength $room_eq_check] == 1} {set room_eq_check [lindex $room_eq_check 0]}

    # If updating, modify the eq list to remove anything that is already reserved -- we only want to check new entries
    if {$updating_p} {
	set already_reserved_eq [crs::request::get_non_room_resources -request_id $request_id]
    } else {
	set already_reserved_eq [list]
    }

    # Internal equipment
    set internal_eq_check [crs::resource::reservation::check_internal_equipment -start_date_sql $sd -end_date_sql $ed \
			       -room_eq_check $room_eq_check -already_reserved_eq $already_reserved_eq]
    set internal_eq_list [lindex $internal_eq_check 0]
    set items_to_remove [lindex $internal_eq_check 1]
    set internal_eq [join $internal_eq_list ",<br>"]
    set room_eq_check [lindex [ctrl::list::lists_minus $room_eq_check $items_to_remove] 0]
    
    if {[llength $gen_eq_check] == 1} {set gen_eq_check [lindex $gen_eq_check 0]}

    # For each piece of external equipment, display conflicts and remove conflicting entries from the list
    set external_eq_check [crs::resource::reservation::check_external_equipment -start_date $sd -end_date $ed -gen_eq_check $gen_eq_check]
    set external_eq_list [lindex $external_eq_check 0]
    set items_to_remove [lindex $external_eq_check 1]
    set external_eq [join $external_eq_list ",<br>"]
    set gen_eq_check [lindex [ctrl::list::lists_minus $gen_eq_check $items_to_remove] 0]
}

# Get all internal equipments associate with the room
set all_equipments $room_eq_check
set default_equipments [db_list default_equipment {}]
foreach default_eq $default_equipments {
    lappend all_equipments $default_eq
}

set conflicting_reserver_name_display [join [join $conflicting_reserver_name_display " "] ", "]

# Validate that the start_date < end_date
set start_end_date_conflict_p [db_string check_dates {} -default 0]
set past_reservation_p [db_string check_dates_past {} -default 0]

# ---------------------------------------------------------------
# Form
# ---------------------------------------------------------------
ad_form -name "confirm" -form {
    {room_eqpmt_check:text(hidden) {value $room_eqpmt_check}}
    {gen_eqpmt_check:text(hidden) {value $gen_eqpmt_check}}
    {warn:text(inform) {label {Confirm:}} {value {<b>Please review and confirm your reservation or go back to make any changes:</b>}}}
    {sub:text(submit) {label {Make Reservation}}}
} -on_submit {   
    # Check for policy
    set request_date "to_date('[clock format [clock seconds] -format "%Y-%m-%d %I:%M %p"]','YYYY-MM-DD HH12:MI AM')"
    set description [ctrl_procs::util::demoronise $description]

    if {$updating_p} {
	# -------------------------------------------------------
	# Update request
	# -------------------------------------------------------
	set action update

	# Set the list of all the request_id based on weather it is a repeating template
	if {$repeat_template_p == "f"} {
	    if {$update_future_p} {
		# set request_id to the first request after it has been reassigned.
		set request_id_list ""
	    } else {
		# set request_id to the current request
		set request_id_list [list $request_id]
	    }
	} else {
	    set template_id $request_id
	    set request_id_list [db_list get_request_id_from_template_id {}]
	}

	# Delete all future events to recreate new requests.
	if {$update_future_p && $room_admin_p} {
	    set date_str "to_date('[db_string get_current_event_start_date {}]', 'YYYY MM DD HH24 MI')"
	    set future_event_id [db_list get_future_event_id {}]

	    foreach f_event_id $future_event_id {
		crs::event::delete -event_id $f_event_id		
	    }
	}	
    } else {
	# -------------------------------------------------------
	# New request
	# -------------------------------------------------------
	set action new

	# Set repeat_template_id based on weather it is a repeating template
	if {$repeat_template_p == "t"} {
	    # Create repeat_template_ids if it is a new repeating_events
	    set request_repeat_template_id [crs::request::new -request_id $request_id -repeat_template_id "" \
						-repeat_template_p $repeat_template_p -name $title -description $description \
						-reserved_by [ad_conn user_id] -status $status]
	    set event_repeat_template_id [crs::event::new -request_id $request_repeat_template_id \
					      -event_id "$event_id" -name "$title" \
					      -object_requested "$room_id" \
					      -start_date $start_date_sql -end_date $end_date_sql \
					      -event_code $event_code\
					      -all_day_p $all_day_p -status $status \
					      -notes $additional_service \
					      -repeat_template_p "t" \
					      -request_id $request_repeat_template_id]
	    #Add repeating pattern for future use
	    ctrl_event::repetition::pattern_add_from_form_widgets -repeat_template_id $event_repeat_template_id \
		-frequency_type $frequency_type -frequency_day $frequency_day \
		-frequency_week $frequency_week -frequency_month $frequency_month \
		-frequency_year $frequency_year \
		-specific_day_frequency $specific_day_frequency -specific_days_week $specific_days_week \
		-specific_months $specific_months -specific_days_month $specific_days_month \
		-specific_dates_of_month_month $specific_dates_of_month_month \
		-specific_dates_of_month_year $specific_dates_of_month_year \
		-repeat_month_opt1 $repeat_month_opt1 -repeat_month_opt2 $repeat_month_opt2 \
		-repeat_end_date_opt $repeat_end_date_opt \
		-repeat_end_date $repeat_end_date_sql
	}
    }

    # Loop through all the requests, if there is no conflict, the conflicting_request_id is null;
    # Loop through if each request conflicts with other multiple requests, 
    foreach conflicting_request_id_list $conflicting_request_id_all \
	    reserver_name $conflicting_reserver_name_all \
	    reserver_email $conflicting_reserver_email_all \
	    sd $start_date_list \
	    ed $end_date_list {

	# Policy check
	set valid_p [crs::resv_resrc::policy::check_compliance -user_id $user_id -resource_id $room_id \
			 -request_date $request_date -reservation_start_date $sd \
			 -reservation_end_date $ed -action $action]
	
	if {$valid_p==0} {
	    template::form::set_error confirm sub "There is a conflict with room policy"
	} else {
	    set fail_p 0
	    db_transaction {
		#assume continue (no conflict, or conflict room admin)
		set continue_p 1
		
		if {[llength $conflicting_request_id_list] > 0} {
		    #make the string from foreach loop a list 
		    set conflicting_request_id_list [join $conflicting_request_id_list " "]
		    
		    foreach conflicting_request_id $conflicting_request_id_list {
			set all_conflicting_events [db_list get_conflicting_events {}]			
			
			#cancel conflicting reservation, if it exists		       
			if {$room_admin_p} {
			    foreach c_event_id $all_conflicting_events {
				crs::event::update_status -event_id $c_event_id -status "cancelled"
			    }
			    #send email for each cancelled request
			    crs::request::update_status -request_id $conflicting_request_id -status "cancelled"
			} else {
			    set continue_p 0
			}
		    }
		}

		# --------------------------------------------------------------
		# if it is only updating future status then for each request do not modify other attributes
		# update status at the end of the module
		# --------------------------------------------------------------
		if {$update_future_status_p} {		    
		    set continue_p 0
		}

		# --------------------------------------------------------------
		# continue_p allows the requester to add or modify a request and it's related events and attributes
		# --------------------------------------------------------------
		if {$continue_p} {
		    # -------------------------------------------
		    # INSERT CRS EVENT 
		    # -------------------------------------------
		    if {!$updating_p} {
			set request_id [crs::request::new -request_id "" -repeat_template_id $request_repeat_template_id \
					    -repeat_template_p "f" -name $title -reserved_by [ad_conn user_id] -status $status \
					    -description $description]
			#compose a comprehensive list of all the request_id
			lappend request_id_list $request_id
			set event_id [db_nextval acs_object_id_seq]
			set event_code [crs::event::generate_event_code -event_id $event_id]
			set event_id [crs::event::new -request_id $request_id \
					  -event_id "$event_id" -name "$title" \
					  -object_requested "$room_id" \
					  -start_date $sd -end_date $ed \
					  -event_code $event_code -all_day_p $all_day_p -status $status \
					  -notes $additional_service \
					  -repeat_template_id $event_repeat_template_id \
					  -repeat_template_p "f"]
			crs::email::notify_user_of_request -request_id $request_id -action "creation"
		    } else {
			# Update all future requests/repeated requests
			if {$update_future_p} {
			    set request_id [crs::request::new -request_id "" -repeat_template_id $request_repeat_template_id \
						-repeat_template_p "f" -name $title -reserved_by [ad_conn user_id] -status $status \
						-description $description]
			    # Compose a comprehensive list of all the request_id
			    lappend request_id_list $request_id
			    
			    set event_id [db_nextval acs_object_id_seq]
			    set event_code [crs::event::generate_event_code -event_id $event_id]
			    set event_id [crs::event::new -request_id $request_id \
					      -event_id "$event_id" -name "$title" \
					      -object_requested "$room_id" \
					      -start_date $sd -end_date $ed \
					      -event_code $event_code -all_day_p $all_day_p -status $status \
					      -notes $additional_service \
					      -repeat_template_id $event_repeat_template_id \
					      -repeat_template_p "f"]			    
			    crs::email::notify_user_of_request -request_id $request_id -action $action	    
			} else {
			    #update single request based on request_id
			    crs::request::update -request_id $request_id -name $title -description $description -status $status
			    crs::event::update -event_id $event_id -title $title -start_date $sd -end_date $ed \
				-all_day_p $all_day_p -status $status -notes $additional_service
			    
			    #if updating, delete all the old reservation and add back the new ones		    
			    foreach eq_id $already_reserved_eq {
				set eq_event_id [db_string get_event {} -default 0]
				crs::event::delete -event_id $eq_event_id				
			    }
			}
		    }

		    permission::grant -party_id $user_id -object_id $request_id -privilege read	
			
		    # ADDING RESERVATIONS FOR SELECTED EQUIPMENT
		    set all_eq [concat $room_eq_check $gen_eq_check]
		    foreach res_id $all_eq {
			#check if the resource is available on the specified dates
			if {[crs::reservable_resource::check_availability -resource_id $res_id -start_date $sd -end_date $ed]} {
			    crs::reservable_resource::get -resource_id $res_id -column_array "rr_info"
			    if {$rr_info(approval_required_p)} {
				set res_admin_p [permission::permission_p -object_id $res_id -privilege "admin"]
				if {$res_admin_p} {
				    set resource_status "approved"
				} else {
				    set resource_status "pending"
				}
			    } else {
				set resource_status "approved"
			    }			    
			    set event_id [crs::event::new -request_id $request_id \
					      -event_id "$event_id" -name "$title" \
					      -object_requested "$res_id" \
					      -start_date $sd -end_date $ed \
					      -all_day_p $all_day_p -status $resource_status \
					      -notes $additional_service \
					      -repeat_template_id $event_repeat_template_id \
					      -repeat_template_p "f"]
			}
		    }
		}	    
	    } on_error {
		set fail_p 1
		db_abort_transaction
	    }
	    if {$fail_p != 0} {
		ad_return_error "Error" "$errmsg"
		ad_script_abort
	    }

	    # ---------------------------------------------------
	    # SEND EMAIL IF NECESSARY
	    # send email to CNSI regardless of status
	    # ---------------------------------------------------

	    if {[string equal $status "pending"] || [regexp cnsi [ctrl::subsite::best_url]]} {
		ns_log notice "CRS-> SENDING EMAIL --> reserve-confirm.tcl [ctrl::subsite::best_url]"
		crs::email::notify_admin_of_request -request_id $request_id -action $action
	    }
	}
    }

    # -----------------------------------------------------------
    # Update all status after removing conflicts
    # -----------------------------------------------------------    
    if {$update_future_status_p && $room_admin_p} {		    
	set date_str "to_date('[db_string get_current_event_start_date {}]', 'YYYY MM DD HH24 MI')"
	set request_id_all [db_list get_future_request_id {}]
	foreach r_id $request_id_all {
	    crs::request::update_status -request_id $r_id -status $status
	}	
    }
} -after_submit {
    # Pass the first request id
    ad_returnredirect "reservation-details?request_id=[lindex $request_id_list 0]&room_id=$room_id"
} -export {
    room_id
    event_id
    context
    return_url
    title
    description
    additional_service
    all_day_p
    repeat_template_p
    specific_days_week
    specific_days_month
    frequency_type
    frequency_day
    frequency_week
    frequency_month
    frequency_year
    specific_day_frequency
    specific_dates_of_month_month
    specific_dates_of_month_year
    specific_months
    repeat_month_opt1
    repeat_month_opt2
    repeat_end_date_opt
    event_code
    start_date_sql
    end_date_sql
    repeat_end_date_sql
    request_id
    update_future_p
    update_future_status_p
}
