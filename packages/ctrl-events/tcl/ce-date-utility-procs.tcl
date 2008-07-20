ad_library {
    General procedures for the event date namespace
    @create-date 07/27/05
    @cvs_id $id$
}

namespace eval ctrl_event::date_util {}

ad_proc -public ctrl_event::date_util::todays_date {
} {
    Procedure which returns today's date
} {
    return [db_string get_sysdate {}]
}

ad_proc -public ctrl_event::date_util::parse_date {
    {-date_var:required}
} {
    Parse to_date(date_x, 'YYYY MM DD HH24:MI') to date_x

    @param date_var
} {
    regexp {^to_date\('(.*)',.*$} $date_var match date_var_str
    return $date_var_str
}

ad_proc -public ctrl_event::date_util::format_date {
    {-date_var:required}
} {
    Format date into 'YYYY MM DD HH24:MI'
   
    @param date_var
} {
    set date_var_str "to_date('$date_var', 'YYYY MM DD HH24 MI')"
    return $date_var_str
}

ad_proc -public ctrl_event::date_util::get_date {
    {-date_var:required}
} {
    Format date into 'YYYY MM DD'
   
    @param date_var
} {
    set date_var_str "to_date('$date_var', 'YYYY MM DD')"
    return $date_var_str
}

ad_proc -public ctrl_event::date_util::get_time {
    {-date_var:required}
} {
    Format date into 'HH24:MI'
   
    @param date_var
} {
    set date_var_str "to_date('$date_var', 'HH24 MI')"
    return $date_var_str
}

ad_proc -public ctrl_event::date_util::format_month {
    {-date_var:required}
    {-month_var:required}
    {-day_var:required}
} {
    Replace month with a new value 'YYYY mm DD HH24 MI' to 'YYYY nn DD HH24 MI'

    @param date_var
    @param month_var
    @param day_var
} {    
    if {$month_var=="0"} {
	set new_month [string range $date_var 5 7]
    } else {	
	set new_month $month_var
    }
  
    if {$day_var=="-1"} {
	set date_var_str "[string range $date_var 0 4]$new_month[string range $date_var 7 end]"
    } else {
	set date_var_str "[string range $date_var 0 4]$new_month $day_var[string range $date_var 10 end]"
    }

    return $date_var_str
}

ad_proc -public ctrl_event::date_util::format_hour {
    {-date_var:required}
} {
    Replace month with a new value 'YYYY MM DD HH12 MI AM' to 'YYYY MM DD HH12 00 AM'

    @param date_var
} {    

    set date_var_str "[string range $date_var 0 12] 00 [string range $date_var 17 end]"

    return $date_var_str
}

ad_proc -public ctrl_event::date_util::format_month_to_number {
    {-month_param:required}
} {
    Return month in 'MM' format
    @param month_param
} {
    if {$month_param < 10} {
	set month_str 0$month_param
    } else {
	set month_str $month_param
    }
    return $month_str
}

ad_proc -public ctrl_event::date_util::get_new_day {
    {-date_param:required}
    {-frequency_param:required}
} {
    Return a new day, add frequency_param to the date_param
    @param date_param
    @param frequency_param
} { 
    set date_str [db_string add {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_new_day_median_format {
    {-date_param:required}
    {-frequency_param:required}
} {
    Return a new day in median format, add frequency_param to the date_param
    @param date_param
    @param frequency_param
} { 
    set date_str [db_string add {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_new_weekday {
    {-date_param:required}
    {-day_param:required}
} {
    Return a weekday
    @param date_param
    @param day_param
} {
    set date_str [db_string next_day {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_new_month {
    {-date_param:required}
    {-frequency_param:required}
} {
    Return a date for a new month, add frequency_param to the date_param
    @param date_param
    @param frequency_param
} {
    set date_str [db_string add_months {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_last_day {
    {-date_param:required}
} {
    Return last day of the month
    @param date_param
} {
    set date_str [db_string last_day {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_previous_last_day {
    {-date_param:required}
} {
    Return a the last day of the previous month
    @date_param
} {
    set date_str [db_string last_day_add_months {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_last_weekday_of_month {
    {-date_param:required}
    {-day_param:required}
} {
    Return the date for the last weekday of the month
    @date_param
    @day_param
} {
    set date_str [db_string next_day_last_day {}]
    return $date_str
}

ad_proc -public ctrl_event::date_util::get_event_duration {
    {-start_date:required}
    {-end_date:required}
} {
    Return the date for the last weekday of the month
    @start_date
    @end_date
} {
    set event_duration [db_string get_event_duration {}] 
    return $event_duration
}

ad_proc -public ctrl_event::date_util::get_date_str {
    {-date_ary_param ""}
    {-date_ary_reference_param ""}
    {-all_day_p:required}
    {-start_date_p:required}
    {-sql_p:required}
    {-time_p:required}
} {
    Return date in m/d/yyy hh:mm am (pretty format) or 
                   to_date('date_x','YYYY MM DD HH24 MI') (sql format)
} {
    upvar $date_ary_param date_ary
    upvar $date_ary_reference_param date_ary_reference 
 
    if {[empty_string_p $date_ary(date)]} {
	set date_ary(date) [clock format [clock seconds] -format "%Y %m %d"]
	set date_ary(year) [clock format [clock seconds] -format "%Y"]
	set date_ary(month) [clock format [clock seconds] -format "%m"]
	set date_ary(day) [clock format [clock seconds] -format "%d"]
    }
    
    if {$all_day_p} {
	if {$start_date_p} {
	    set date_ary(short_hours) "12"
	    set date_ary(minutes) "00"
	    set date_ary(ampm) "am"
	} else {
	    set date_ary(date) $date_ary_reference(date)
	    set date_ary(year) $date_ary_reference(year)
	    set date_ary(month) $date_ary_reference(month)
	    set date_ary(day) $date_ary_reference(day)
	    if {$sql_p} {
		set date_ary(short_hours) "23"
	    } else {
		set date_ary(short_hours) "11"
	    }
	    set date_ary(minutes) "55"
	    set date_ary(ampm) "pm"
	}
    }
    
    if {$time_p} {
	if {$date_ary(ampm) == "am" && $sql_p} {
	    if {$date_ary(short_hours) == 12} {
		set date_ary(short_hours) "00"
	    }
	} 
	if {$date_ary(ampm) == "pm" && $sql_p} {
	    if {$date_ary(short_hours) < 12} {
		if {$date_ary(short_hours) == "08"} {
		    set date_ary(short_hours) [expr 8 + 12]
		} elseif {$date_ary(short_hours) == "09"} {
		    set date_ary(short_hours) [expr 9 + 12]
		} else {
		    set date_ary(short_hours) [expr $date_ary(short_hours) + 12]
		}
	    }
	}
	
	if {[string length $date_ary(short_hours)] == 1} {
	    set date_ary(short_hours) "0$date_ary(short_hours)"
	}
	
	if {[string length $date_ary(minutes)] == 1} {
	    set date_ary(minutes) "0$date_ary(minutes)"
	}
    }
    
    if {[string length $date_ary(month)] == 1} {
	set date_ary(month) "0$date_ary(month)"
    }
    
    if {[string length $date_ary(day)] == 1} {
	set date_ary(day) "0$date_ary(day)"
    }
     

    if {$sql_p} {
	set date_str "to_date('$date_ary(year) $date_ary(month) $date_ary(day) $date_ary(short_hours) $date_ary(minutes)', 'YYYY MM DD HH24 MI')"
    } else {
	if {$time_p} {
	    set date_str "$date_ary(year)/$date_ary(month)/$date_ary(day) $date_ary(short_hours):$date_ary(minutes) $date_ary(ampm)"
	} else {
	    set date_str "$date_ary(year)/$date_ary(month)/$date_ary(day)"
	}
    }

    return $date_str
}
