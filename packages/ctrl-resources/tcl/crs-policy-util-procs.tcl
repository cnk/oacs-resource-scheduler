ad_library {
    Helper display procs for reservaiton policies

    @author KH
    @cvs-id $Id$
    @creation-date 2006-06-14
}

namespace eval crs::resv_resrc::policy::util {}

ad_proc -public crs::resv_resrc::policy::util::format_interval_display {interval_seconds} {
    Format the seconds into a pretty display by days, hours, minutes, and seconds
} {
    if {$interval_seconds < 1} {
	return "(N/A)"
    }
    set day_seconds 86400
    set hour_seconds 3600
    set minute_seconds 60

    set step_list [list {$day_seconds day} {$hour_seconds hour} {$minute_seconds minute}]
    foreach step_info $step_list {
	set step [lindex $step_info 0]
	set label [lindex $step_info 1] 
	set value [expr $interval_seconds/$step]
	if {$value > 1} {
	    lappend conv_list  "$value ${label}s"
	} elseif {$value > 0} {
	    lappend conv_list "$value $label"
	}
	set interval_seconds [expr $interval_seconds%$step]
    }
    return [join $conv_list " "]
}

ad_proc -public crs::resv_resrc::policy::util::get_interval_info {
    -interval_seconds:required 
    {-column_array interval_info}
} {
    returns an array of interval steps of day, hour, and minutes
    @param interval_seconds the interval in seconds
    @param column_array the column array to store the interval
} {
    upvar $column_array interval_info

    set day_seconds 86400
    set hour_seconds 3600
    set minute_seconds 60
    if [empty_string_p $interval_seconds] {
	set interval_seconds 0
    }
    set step_list [list {$day_seconds day} {$hour_seconds hour} {$minute_seconds minute}]
    foreach step_info $step_list {
	set step [lindex $step_info 0]
	set label [lindex $step_info 1] 
	set value [expr $interval_seconds/$step]
	set interval_info($label) $value
	set interval_seconds [expr $interval_seconds%$step]
    }
}
