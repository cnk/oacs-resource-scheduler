# /packages/ctrl-resources/tcl/crs-event-procs.tcl
ad_library {
    Procs for handling crs events

    @author: Jeff Wang (jcwang@cs.ucsd.edu)
    @creation-date: 12/12/05
    @cvs-id $Id: $
}

namespace eval crs::event {}

ad_proc -public crs::event::new {
    {-request_id:required}
    {-request_repeat_template_id ""}
    {-event_id ""}
    {-status "pending"}
    {-date_reserved "sysdate"}
    {-event_code ""}
    {-reserved_by ""}
    {-object_requested:required}
    {-name:required}
    {-start_date:required}
    {-end_date:required}
    {-all_day_p:required}
    {-notes:required}
    {-repeat_template_id ""}
    {-repeat_template_p "f"}
    {-location ""}
    {-capacity ""}
} {
    Create a new crs event and also tie it to a ctrl_event
} {

    if {[empty_string_p $reserved_by]} {
	set reserved_by [ad_conn user_id]
    }
    
    set error_p 0
    db_transaction {
	if {![crs::request::exists_p -request_id $request_id]} {
	    # Insert a request
	    set request_id [crs::request::new -request_id $request_id -repeat_template_id $request_repeat_template_id -repeat_template_p $repeat_template_p -name $name -reserved_by $reserved_by -status $status]
	}
	#generate a new event id
	if {[empty_string_p $event_id]} {
	    set event_id  [db_nextval acs_object_id_seq]
	}

	#make a ctrl event
	set event_id [ctrl_event::new \
			  -event_id $event_id \
			  -event_object_id $object_requested \
			  -title $name \
			  -start_date $start_date \
			  -end_date $end_date \
			  -all_day_p $all_day_p \
			  -location $location \
			  -notes $notes \
			  -capacity $capacity \
			  -repeat_template_id $repeat_template_id\
			  -repeat_template_p $repeat_template_p\
			  -category_id ""]

	if {[empty_string_p $event_code]} {
	    set event_code [crs::event::generate_event_code -event_id $event_id]
	} else {
	    #check that event code that was passed in is unique
	    set not_unique_p [db_string check_code {} -default 0]
	    if {$not_unique_p} {
		ad_return_complaint 1 "The event code you passed in has already been used.  \
                Please choose another event code or let us generate a unique one for you by leaving that field blank."
		ad_script_abort
	    }
	}

	#add a new crs event
	if {$repeat_template_p=="f"} {
	    db_exec_plsql new_event {}
	}

    } on_error {
	set error_p 1
	db_abort_transaction
    }
    
    if {$error_p} {
	ad_return_complaint 1 "There was a problem adding the event.  Please try again.<p>$errmsg"
	ns_log notice "---ERROR: Problem adding event in crs::event::new .  The error was $errmsg. ---"
	ad_script_abort
    }
    
    return $event_id
}

ad_proc -public crs::event::get {
    {-event_id:required}
    {-column_array:required}
    {-date_format "'MM DD YYYY'"}
} {

    Get information about this event

} {
    upvar $column_array local_array
    db_0or1row get {} -column_array local_array 
}

ad_proc -public crs::event::get_repeat_template_id {
    {-event_id:required}
} {
    Get event repeat template id
} {
    return [db_string get_repeat_template_id {}]
}

ad_proc -public crs::event::update {
    {-event_id:required}
    {-status}
    {-date_reserved}
    {-event_code}
    {-reserved_by}
    {-object_requested}
    {-title}
    {-start_date}
    {-end_date}
    {-all_day_p}
    {-notes}
} {
    Update this crs event
} {
    set var_list [list]
    if {[info exists event_code]} {
	lappend var_list "event_code=:event_code"
    }
    if {[info exists reserved_by]} {
	lappend var_list "reserved_by=:reserved_by"
    }
    if {[info exists object_requested]} {
	lappend var_list "object_requested=:object_requested"
    }
    if {[info exists title]} {
	lappend var_list "title=:title"
    }
    if {[info exists start_date]} {
	lappend var_list "start_date=$start_date"
    }
    if {[info exists end_date]} {
	lappend var_list "end_date=$end_date"
    }
    if {[info exists all_day_p]} {
	if {$all_day_p} {
	    lappend var_list "all_day_p='t'"
	} else {
	    lappend var_list "all_day_p='f'"
	}

    }
    if {[info exists notes]} {
	lappend var_list "notes=:notes"
    }

    if {[llength $var_list] > 0} {
	set update_string [join $var_list ","]
	set error_p 0
	db_transaction {
	    db_dml do_update {}
	    if {[info exists status]} {
		crs::event::update_status -event_id $event_id -status $status
	    }
	} on_error {
	    set error_p 1
	}
	
	if {$error_p} {
	    ad_return_complaint 1 "There was an error doing the update -- $errmsg"
	    ad_script_abort
	}

    }
}

ad_proc -public crs::event::delete {
    {-event_id:required}
} {

    Delete the crs_event and ctrl_event
} {

    ### AMK - REEXAMINE - crs::email::notify_user_of_event does not exist. Should it?
    ### SEND EMAIL TO RESERVER OF CHANGES
    ### crs::email::notify_user_of_event -event_id $event_id -action "delete"

    set error_p 0
    db_transaction {
	db_exec_plsql do_delete {}
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem deleting the event. Please try again. <br><br> $errmsg"
	ns_log notice "---ERROR: Problem deleting event in crs::event::delete .  The error was $errmsg. ---"
	ad_script_abort
    }
}

ad_proc crs::event::generate_event_code {
    {-event_id:required}
    {-num_chars 15}
} {
    Generate a unique event code based on this id
} {
    set alpha_length [expr $num_chars - [string length $event_id]]
    set prefix [ad_generate_random_string $alpha_length]
    set event_code "${prefix}${event_id}"
    return $event_code
}

ad_proc -public crs::event::update_status {
    {-event_id:required}
    {-status:required}
} {
    Update the status of this event

    @param status pending, approve, deny,cancelled
} {

    set error_p 0

    db_transaction {
	db_dml do_update {}
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint 1 "There was a problem updating the status of the event. Please try again. $errmsg"
	ns_log notice "---ERROR: Problem updating status .  The error was $errmsg. ---"
	ad_script_abort
    }
    
}

ad_proc -public crs::event::get_list {
    {-room_id:required}
    {-viewtype:required}
    {-current_julian_date:required}
} {
    Function which returns events 
    for the room_id (123,124) given
    for the specified calendar view (day|week|month) 
    for the specified julian date (12345)

    Returns a list of lists
    For viewtype 
    day:   returns lists of lists with each inner list containing "event_id event_start_time event_end_time"
    month: returns lists of lists with each inner list containing "unique_date event_html"
    week: TODO -> needs to be implemented    (the week selection needs work)
} {
    set current_ansi_date [dt_julian_to_ansi $current_julian_date]
    switch $viewtype {
        day {
            return [crs::event::day_list -room_id $room_id -current_date $current_ansi_date]
        }
        month {
            return [crs::event::month_list -room_id $room_id -current_date $current_ansi_date]
        }
        week {
	    return [crs::event::week_list -room_id $room_id -current_date $current_ansi_date]
        } 
        default {
            return 0
        }
    }
}

ad_proc -public crs::event::month_list {
    {-room_id:required}
    {-current_date ""}
} {
    list approved events in a particular month
} {
    if {[empty_string_p $current_date]} {
	set current_date [dt_sysdate]
    }
    return [db_list_of_lists get_events {}]
}

ad_proc -public crs::event::week_list {
    {-room_id:required}
    {-current_date ""}
} {
    list approved events in a particular week
} {
    if {[empty_string_p $current_date]} {
	set current_date [dt_sysdate]
    }
    return [db_list_of_lists get_events {}]
}

ad_proc -public crs::event::day_list {
    {-room_id:required}
    {-current_date ""}
} {
    list approved events in a particular day
} {
    if {[empty_string_p $current_date]} {
	set current_date [dt_sysdate]
    }
    return [db_list_of_lists get_events {}]
}

ad_proc -public crs::event::list_event_timespan_in_a_month {
    {-room_id:required}
    {-current_date ""}
} {
    list event timespan of the room in a month view
} {
    if {[empty_string_p $current_date]} {
	set current_date [dt_sysdate]
    }
    set timespan_info [db_list_of_lists get_timespan {}]
    return $timespan_info
}

ad_proc -public crs::event::repetition_pattern_text {
    {-frequency_type:required}
    {-frequency_day ""}
    {-frequency_week ""}
    {-specific_days_week ""}
    {-repeat_month_opt1 ""}
    {-specific_dates_of_month_month ""}
    {-frequency_month ""}
    {-specific_day_frequency ""}
    {-specific_days_month ""}
    {-specific_months ""}
    {-specific_dates_of_month_year ""}
    {-repeat_end_date_opt ""}
    {-repeat_end_date_sql ""}
} {
    Return string for repeating pattern
} {
    #upvar $repeat_end_date_ary repeat_end_date
    
    set msg "Repeat Every "

    switch $frequency_type {
	"daily" {
	    append msg "$frequency_day Days," 
	}
	"weekly" {
	    append msg "$frequency_week Weeks on $specific_days_week," 
	}
	"monthly" {
	    if {![empty_string_p $repeat_month_opt1]} {
		append msg "Day $specific_dates_of_month_month of Every $frequency_month Month(s)," 
	    } else {
		append msg "$specific_day_frequency $specific_days_month,"
	    }
	}
	"yearly" {
	    if {$specific_months<10} {set specific_months 0$specific_months}
	    if {$specific_dates_of_month_year<10} {set specific_dates_of_month_year 0$specific_dates_of_month_year}
	    append msg "Year on $specific_months/$specific_dates_of_month_year,"
	}
    }

    if {$repeat_end_date_opt==1} {
	#if {[array size repeat_end_date] != 0} {
	    append msg " Until $repeat_end_date_sql"
	#}
    } else {
	append msg " No End Date"
    }

    return $msg
}
