# /packages/ctrl-calendar/tcl/ctrl-cal-filter-procs.tcl

ad_library {
    
    CTRL Calendar Filter Procs
    
    @creation-date 07/25/2007
    @cvs_id $id$
 }

namespace eval ctrl::cal::filter {}

ad_proc -public ctrl::cal::filter::get {
    {-cal_filter_id:required}
    {-column_array:required}
} {
    @param column_array The array that we upvar information into
    @param cal_filter_id
} {
    upvar $column_array local_array
    set selection [db_0or1row get {} -column_array local_array]
    return $selection
}

ad_proc -public ctrl::cal::filter::new {
    {-cal_filter_id:required}
    {-filter_name:required}
    {-description:required}
    {-cal_id:required}
    {-filter_type:required}
    {-context_id ""}
    {-package_id ""}
} {
    Create a new filter
} {
    set error_p 0
    db_transaction {
	if {[empty_string_p $context_id]} {set context_id [ad_conn package_id]}
        if {[empty_string_p $package_id]} {set package_id [ad_conn package_id]}
	set user_id [ad_conn user_id]
	set cal_filter_id [db_exec_plsql new {}]
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error "There was a problem creating a new calendar filter. <br><br>$errmsg "
    }
    return $cal_filter_id
}

ad_proc -public ctrl::cal::filter::update {
    {-cal_filter_id:required}
    {-filter_name:required}
    {-description:required}
    {-cal_id:required}
    {-filter_type:required}
 } {
    Update a row in ctrl_calendar_filter
} {
    set error_p 0
    db_transaction {
	db_dml update {}
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem updating the ctrl_calendar_filters table. $errmsg "
 	ad_script_abort
    }
}

ad_proc -public ctrl::cal::filter::remove {
    {-cal_filter_id:required}
} {
    Remove an acs_object by calling the associated pl/sql function

    @param cal_id
} {
    set error_p 0
    db_transaction {
	db_exec_plsql remove {}
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was problem removing the calendar filter.  $errmsg "
 	ad_script_abort
    }
}


ad_proc -public ctrl::cal::filter::name_unique_p {
    {-cal_id:required}
    {-cal_filter_id:required}
    {-filter_name:required}
} {
} {
    return [db_string name_unique_p {} -default 0]
}

ad_proc -public ctrl::cal::filter::map {
    {-cal_filter_id:required}
    {-filter_list:required}
    {-color_list:required}
    {-update_p 0}
} {
} {
    set error_p 0
    db_transaction {
	# If update, delete all records and resave the map
	if {$update_p} {db_dml delete {}}

	set i 0

	while {$i < [llength $filter_list]} {
	    set object_id [lindex $filter_list $i]
	    set color [lindex $color_list $i]
	    db_dml new {}

	    incr i
	}

    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem creating a new calendar filter. $errmsg "
 	ad_script_abort
    }
}

ad_proc -public ctrl::cal::filter::get_mapped_object_id {
    {-cal_filter_id:required}
} {
} {
    return [db_list get {}]
}

ad_proc -public ctrl::cal::filter::get_mapped_color {
    {-cal_filter_id:required}
} {
} {
    return [db_list_of_lists get {}]
}

ad_proc -public ctrl::cal::filter::day_view {
    {-cal_id:required}
    {-cal_filter_id:required}
    {-current_julian_date:required}
    {-start_time:required}
    {-end_time:required}
    {-interval 30}
    {-display_24 0}
    {-default_color "#ffffff"}
    {-tomorrow_template ""}
    {-yesterday_template ""}
    {-manage_p 0}
    {-display_p 0}
} {
    Create a daily view of calendar of events

    @param object_id_list 
    @param start_time
    @param end_time
    @param interval        in minutes
    @param display_24      1 in hh24 format
    @param default_color   default color for background
    @param manage_p
} {
    # Get objects and mapped color
    set mapped_list [ctrl::cal::filter::get_mapped_color -cal_filter_id $cal_filter_id]
    if {[llength $mapped_list] == 0} {
	return "<br><br><font color=red size=4>No category or resource selected to display.  Please go to <a href=\"filter-ae?[export_url_vars cal_filter_id cal_id]\">edit filter</a> to add the objects you wish to display.</font>"
	ad_script_abort
    }

    set current_date [dt_julian_to_ansi $current_julian_date]

    set filter_type [db_string get_filter_type {}]

    append day_view "<table width=\"100%\" border=0><tr><td col=100%>
                         <table width=\"100%\"><tr>
                            <td width=\"50%\" align=left>$yesterday_template</td>
                            <td width=\"50%\" align=right>$tomorrow_template</td>
                         </tr></table>\n
                     </td></tr></table>\n"

    # set <td> width based on the how many objects are selected
    set td_width [expr [expr 100 - 7] / [llength $mapped_list]]

    # build up color key
    append day_view "<table width=\"100%\" border=1 cellpadding=2 cellspacing=0>\n"

    foreach item $mapped_list {
	set object_id [lindex $item 0]
	set color_code [lindex $item 1]

	if {$filter_type=="category"} {
	    append day_view "<tr><td bgcolor=$color_code align=center>[acs_object_name $object_id]</td></tr>"
	    lappend event_list_all [list [db_list_of_lists get_category_events {}] $color_code]
	} elseif {$filter_type=="resource"} {
	    crs::resource::get -resource_id $object_id -column_array info
	    set name $info(name)
	    append day_view "<tr><td bgcolor=$color_code align=center>$name</td></tr>"
	    set crs_event [crs::event::get_list -room_id $object_id -viewtype "day" -current_julian_date $current_julian_date]
	    if {[llength $crs_event] > 0} {
		lappend event_list_all "[list $crs_event $color_code]"
	    } else {
		lappend event_list_all "{} $color_code"
	    }
	}
    }

    append day_view "</table>"

    set interval [expr $interval/60.0]

    set events_all [list]

    foreach item_list $event_list_all {
	set event_list [lindex $item_list 0]
	set color [lindex $item_list 1]
	set events [list]
	# rebuild event list #######################################################
	foreach el $event_list {
	    # handle for multiple days events
	    set event_start_julian_date [lindex $el 5]
	    set event_end_julian_date [lindex $el 6]
	    
	    # default nonset value
	    set event_start_slot -2
	    set event_end_slot -2
	    
	    # if event started before
	    if {$event_start_julian_date < $current_julian_date} {set event_start_slot -1}
	    # if event will end in the future
	    if {$event_end_julian_date > $current_julian_date} {set event_end_slot 25}
	    
	    # manipulate event time
	    set event_start [lindex $el 1]
	    
	    # 01 will be trimmed as 1, but be careful with 00
	    set event_start_hour [string trimleft [lindex [split $event_start :] 0] 0]
	    set event_start_min [lindex [split $event_start :] 1]
	    
	    if {[empty_string_p $event_start_hour]} {set event_start_hour 0}
	    if {[empty_string_p $event_start_min]} {set event_start_min 0}
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
	    set event_end_min [lindex [split $event_end :] 1]
	    if {[empty_string_p $event_end_hour]} {set event_end_hour 0}
	    if {[empty_string_p $event_end_min]} {set event_end_min 0}

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
		set event_title "\[$event_start_date $event_start - $event_end_date $event_end\] &nbsp;"
	    } else {
		set event_title "\[$event_start - $event_end\] <a href=\"../../events/event-view?[export_url_vars event_id cal_id]\">$event_title</a> &nbsp;"
	    }
	    
	    lappend events [list $event_start_slot $event_end_slot $event_title $event_id $color]
	}
	# END rebuild event list ###################################################
	lappend events_all $events
    }

    # build up calendar table
    append day_view "<table width=\"100%\" border=0 cellpadding=2 cellspacing=2>\n"

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

	append day_view "<tr><td width=9%><nobr>$display_time</td>"

	foreach e_list $events_all {
	    set flag 0
	    set titles ""

	    append day_view "<td>"

	    foreach e $e_list {
		set event_start_slot [lindex $e 0]
		set event_end_slot [lindex $e 1]
		set event_title [lindex $e 2]
		set event_id [lindex $e 3]
		set event_color [lindex $e 4]
		
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
		append day_view "<td bgcolor=$event_color width=$td_width%><font size=1>$titles</font></td>"
	    } elseif {$flag == 2} {
		append day_view "<td bgcolor=$event_color width=$td_width%><font size=1>$titles</font></td>"
	    } else {
		append day_view "<td bgcolor=$default_color width=$td_width%><font size=1>&nbsp;</font></td>"
	    }
	    append day_view "</td>"
	}

	append day_view "</tr>\n"
    } 
    # END build table ##########################################################

    append day_view "</table>\n"

    append day_view "<table width=\"100%\" border=0><tr><td col=100%>
                         <table width=\"100%\"><tr>
                            <td width=\"50%\" align=left>$yesterday_template</td>
                            <td width=\"50%\" align=right>$tomorrow_template</td>
                         </tr></table>\n
                     </td></tr></table>\n"

    return $day_view
}

ad_proc -public ctrl::cal::filter::option_list {
} {
  set result [list [list "All" 0]]
  db_foreach calendars {} {
     lappend result [list "$cal_name" $cal_id]
  }
  return $result
}

