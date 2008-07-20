# /packages/ctrl-resources/tcl/crs-calendar-procs.tcl
ad_library {
    Procs for handling crs calendars

    @author: jmhek@cs.ucla.edu
    @creation-date: 02/12/06
    @cvs-id $Id: $
}

namespace eval crs::calendar {}

ad_proc -public crs::calendar::get {
    {-room_id:required} 
    {-column_array:required}
} {
    select cal_id, cal_name, description, owner_id from ctrl_calendars by room_id
} {

    #if calendar doesn't exist, create one.
    set test [db_string calendar_exist_p {}]
    if {$test == 0} {
	crs::room::get -room_id $room_id -column_array room_info
	set var_list [list\
                          [list cal_name $room_info(name)]\
			  [list description "Calendar for $room_info(name)" ]\
                          [list owner_id [ad_conn user_id]] \
                          [list context_id $room_id] \
                          [list object_id $room_id]]
        ctrl::cal::new -var_list $var_list
    }

    upvar $column_array local_array
    db_0or1row get {} -column_array local_array
}

ad_proc -public crs::calendar::daily_view {
    {-room_id:required}
    {-current_julian_date:required}
    {-start_time:required}
    {-end_time:required}
    {-interval 30}
    {-display_24 1}
    {-event_color "#ffffcc"}
    {-default_color "#ffffff"}
    {-tomorrow_template ""}
    {-yesterday_template ""}
    {-manage_p 0}
} {
    Create a daily view of calendar of events

    @param object_id_list 
    @param start_time
    @param end_time
    @param interval        in minutes
    @param display_24      1 in hh24 format
    @param event_color     default color with occupied events
    @param default_color   default color for background
    @param tomorrow_template
    @param yesterday_template
    @param manage_p
} {
    set current_date [dt_julian_to_ansi $current_julian_date]
    set curr_sec [clock scan $current_date]
    set date_display_str [clock format $curr_sec -format "%A %b %d, %Y"]
    set from_date [string tolower [clock format [expr $curr_sec+60] -format "%Y %m %d %I %H"]]
    set to_date [string tolower [clock format [expr $curr_sec+120] -format "%Y %m %d %I %H"]]

    if {[regexp cnsi [subsite::get_url]]} {
	set make_resv_link ""
    } else {
	set make_resv_link "<a href=\"../room-details?[export_url_vars room_id from_date to_date]\">Make Reservation</a>"
    }

    set event_list [crs::event::get_list -room_id $room_id -viewtype "day" -current_julian_date $current_julian_date]

    set interval [expr $interval/60.0]
    set events [list]

    # rebuild event list
    foreach el $event_list {
	# handle for multiple days events
	set event_start_julian_date [lindex $el 5]
	set event_end_julian_date [lindex $el 6]

	# default nonset value
	set event_start_slot -2
	set event_end_slot -2

	# if event started before
	if {$event_start_julian_date < $current_julian_date} {
	    set event_start_slot -1
	}
	# if event will end in the future
	if {$event_end_julian_date > $current_julian_date} {
	    set event_end_slot 25
	}
	
	# manipulate event time
	set event_start [lindex $el 1]

	# 01 will be trimmed as 1, but be careful with 00
	set event_start_hour [string trimleft [lindex [split $event_start :] 0] 0]
	set event_start_min [string trimleft [lindex [split $event_start :] 1] 0]

	if {[empty_string_p $event_start_hour]} {
	    set event_start_hour 0
	}
	if {[empty_string_p $event_start_min]} {
	    set event_start_min 0
	}
	if {$event_start_slot == -2} {
	    set temp [expr floor([expr [expr $event_start_min/60.0] / $interval])]
	    set event_start_slot [expr $temp*$interval + $event_start_hour]
	}
	if {$event_start_hour < 12} {
	    set start_flag am
	} else {
	    set start_flag pm
	}

	set event_end [lindex $el 2]
	set event_end_hour [string trimleft [lindex [split $event_end :] 0] 0]
	set event_end_min [string trimleft [lindex [split $event_end :] 1] 1]
	if {$event_end_slot == -2} {
	    set temp [expr ceil([expr [expr $event_end_min/60.0] / $interval])]
	    set event_end_slot [expr $event_end_hour + $temp*$interval]
	}
	if {$event_end_hour < 12} {
	    set end_flag am
	} else {
	    set end_flag pm
	}

	# event time display
	if {$display_24 != 1} {
	    set event_start_hour [expr $event_start_hour<=12?$event_start_hour:[expr $event_start_hour-12]]
	    set event_end_hour [expr $event_end_hour<=12?$event_end_hour:[expr $event_end_hour-12]]
	    set event_start "$event_start_hour:$event_start_min $start_flag"
	    set event_end "$event_end_hour:$event_end_min $end_flag"
	}

	set event_id [lindex $el 3]
	set event_title [lindex $el 4]
	set request_id [lindex $el 7]

	# if multiple days event
	if {$event_start_slot == -1 || $event_end_slot == 25} {
	    set event_start_date [dt_julian_to_ansi $event_start_julian_date]
	    set event_end_date [dt_julian_to_ansi $event_end_julian_date]
	    set event_title "<li>\[$event_start_date $event_start ~ $event_end_date $event_end\] $make_resv_link &nbsp;\[ <a href=\"ics/${event_id}.ics\">Download to Desktop</a>\]</li>"
	} else {
	    set event_title "<li>\[$event_start ~ $event_end\] $make_resv_link $event_title</a> &nbsp;\[<a href=\"../ics/$event_id.ics\">Download to Desktop</a> \]</li>"
	}

	lappend events [list $event_start_slot $event_end_slot $event_title $event_id]
    }

    # build up calendar table
    set day_view "<br><br><table width=\"100%\" border=0 cellpadding=2 cellspacing=2>\n"
    if {$manage_p} {
	append day_view "<td align=center colspan=2>$make_resv_link</td></tr>\n"
    }
    append day_view "<tr><td id=\"calendar-hdr\" align=center width=\"7%\">Time</td><td align=\"center\" id=\"calendar-hdr\" width=\"90%\">
<table width=\"100%\" id=\"standard\"><tr><td width=\"10%\">($yesterday_template)</td><td id=\"calendar-hdr\" width=\"80%\" align=center>
Events for $date_display_str</td>
<td width=\"10%\">($tomorrow_template)</td></tr></table>
</td></tr>\n"

    for {set i $start_time} {$i <= $end_time} {set i [expr $i+$interval]} {
	# set up display time
	set display_hour [lindex [split $i .] 0]
	if {$display_hour < 12} {
	    set display_flag am
	} else {
	    set display_flag pm
	}
	if {$display_24 != 1} {
	    set display_hour [expr $display_hour<=12?$display_hour:[expr $display_hour-12]]
	}

	set min [lindex [split $i .] 1]
	if {[empty_string_p $min] || ($min == 0)} {
	    set display_min 00
	} else {
	    set display_min [expr round([expr (0.[lindex [split $i .] 1])*60])]
	    set display_min [expr $display_min<10?0$display_min:$display_min]
	}

	set display_time $display_hour:$display_min
	if {$display_24 != 1} {
	    append display_time " $display_flag"
	}

	set j [expr $i + $interval]

	set flag 0
	set titles ""
	foreach e $events {
	    set event_start_slot [lindex $e 0]
	    set event_end_slot [lindex $e 1]
	    set event_title [lindex $e 2]
	    set event_id [lindex $e 3]

	    if {$event_start_slot >= $i && $event_start_slot < $j} {
		append titles $event_title
		set flag 1
	    } elseif {$event_start_slot < $i && $event_end_slot > $i} {
		if {($event_start_slot == -1 || $event_end_slot==25) && $i == $start_time} {
		    append titles $event_title
		} elseif {($event_start_slot < $start_time) && ($event_end_slot > $end_time) && ($i == $start_time)} {
		    append titles $event_title
		}
		set flag 2
	    } 
	}

	if {$flag == 1} {
	    append day_view "<tr><td align=right>$display_time</td><td bgcolor=$event_color><ul>$titles</ul></td></tr>\n"
	} elseif {$flag == 2} {
	    append day_view "<tr><td align=right>$display_time</td><td bgcolor=$event_color><ul>$titles</ul></td></tr>\n"
	} else {
	    append day_view "<tr><td align=right>$display_time</td><td bgcolor=$default_color>&nbsp;</td></tr>\n"
	}
    }

    if {$manage_p} {
	append day_view "<tr><td align=center colspan=2>$make_resv_link</td></tr>\n"
    }
    append day_view "</table>\n"
    return $day_view
}

ad_proc -public crs::calendar::monthly_view {
    {-room_id:required}
    {-julian_date ""}
    {-prev_month_template ""}
    {-next_month_template ""}
    {-day_number_template ""}
    {-size "small"}
    {-easy_day_color "#00FF99"}
    {-moderate_day_color "#FF99FF"}
    {-busy_day_color "#FF0000"}
} {
    display approved events in a monthly calendar
} {
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

    set calendar_details [ns_set create calendar_details]
    set object_event_info [crs::event::get_list -room_id $room_id -viewtype "month" -current_julian_date $julian_date]

    foreach date_info $object_event_info {
	set julian_event_date [lindex $date_info 0]
	set start_time [lindex $date_info 1]
	set title [lindex $date_info 2]
	set event_id [lindex $date_info 3]
	set request_id [lindex $date_info 7]
	set events_display "$start_time <a href=\"../reservation-details?[export_url_vars request_id]\">$title</a>"
	ns_set update $calendar_details $julian_event_date $events_display
    }

    # customize calendar color of each day
    set day_bgcolors [ns_set create day_bgcolor]
    set timespan_info [crs::event::list_event_timespan_in_a_month -room_id $room_id -current_date $current_date]

    foreach date_info $timespan_info {
	set start_day [string trimleft [lindex $date_info 0] 0]
	set end_day [string trimleft [lindex $date_info 1] 0]
	set timespan [lindex $date_info 2]

	if {$timespan < 2} {
	    set color $easy_day_color
	} elseif {$timespan < 6} {
	    set color $moderate_day_color
	} else {
	    set color $busy_day_color
	}

	for {set j $start_day} {$j <= $end_day} {incr j} {
	    if {$j < 10} {
		set temp 0$j
	    } else {
		set temp $j
	    }
	    ns_set update $day_bgcolors $temp $color
	}
    }

    set calendar [dt_widget_month_small -date $current_date -day_number_template $day_number_template -next_month_template $next_month_template \
		      -prev_month_template $prev_month_template -master_bgcolor "414C60" -header_bgcolor "#B3BCD6" -header_text_color "#242942" \
		      -day_header_bgcolor "#E5E5BA" \
		      -day_bgcolor "#ffffff" -day_text_color "#4D4DB4" -empty_bgcolor "#cccccc"]

    return $calendar
}
