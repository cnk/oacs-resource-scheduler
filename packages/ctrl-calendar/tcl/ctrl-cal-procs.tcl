# /packages/ctrl-calendar/tcl/ctrl-cal-procs.tcl		-*- tab-width: 4 -*-
ad_library {

	CTRL Calendar Procs

	@creation-date	12/19/05
	@cvs_id			$Id$
}

namespace eval ctrl::cal {}

ad_proc -public ctrl::cal::get {
	{-column_array:required}
	{-cal_id:required}
} {
	Select cal_name ,description ,owner_id ,object_id from ctrl_calendars

	@param column_array The array that we upvar information into
	@param cal_id

} {
	upvar $column_array local_array
	set selection [db_0or1row get {} -column_array local_array]
	return $selection
}

ad_proc -public ctrl::cal::update {
	{-cal_id:required}
	{-cal_name}
	{-description}
	{-owner_id}
	{-object_id}
	{-subsite_id_list ""}
 } {
	Update a row in ctrl_calendars

	 @param cal_name
	 @param description
	 @param owner_id
	 @param object_id
	 @param subsite_id_list

} {
	set update_list [list]

	if {[info exists cal_name]} {
		lappend update_list "cal_name=:cal_name"
	}
	if {[info exists description]} {
		lappend update_list "description=:description"
	}
	if {[info exists owner]} {
		lappend update_list "owner=:owner"
	}
	if {[info exists object_id]} {
		lappend update_list "object_id=:object_id"
	}
	set update_string [join	 $update_list ","]

	if {[empty_string_p $update_string]} {
		ad_return_complaint 1 "You didn't pass in anything to update!"
		ad_script_abort
	}

	set error_p 0
	db_transaction {
		ctrl_procs::acs_object::update_object -object_id $cal_id
		db_dml update {}

		# DELETE OLD SUBSITE - CALENDAR MAPPINGS
		ctrl::subsite::object_rel_del -object_id $cal_id

		# ADD NEW SUBSITE - CALENDAR MAPPINGS
		foreach subsite_id $subsite_id_list {
			ctrl::subsite::object_rel_new -subsite_id $subsite_id -object_id $cal_id
		}

	} on_error {
		set error_p 1
	}

	if {$error_p} {
		ad_return_complaint 1 "There was a problem updating the ctrl_calendars table. $errmsg "
		ad_script_abort
	}
}


ad_proc -public ctrl::cal::remove {
	{-cal_id:required}
} {
	Delete the calendar (cal_id) passed in

	@param cal_id
} {
	set error_p 0
	db_transaction {
		ctrl::subsite::object_rel_del -object_id $cal_id
		db_exec_plsql remove {}
	} on_error {
		set error_p 1
	}

	if {$error_p} {
		ad_return_complaint 1 "There was problem removing the calendar.	 $errmsg "
		ad_script_abort
	}
}

ad_proc -public ctrl::cal::new {
	{-var_list ""}
	{-subsite_id_list ""}
	{-object_type:required "ctrl_calendar"}
} {
	Creates a new acs_object

	@param var_list a list of key value pairs to be supplied to the pl/sql call
	@param object_type the type of object you are creating

} {
	set error_p 0
	db_transaction {
		set calendar_id [package_instantiate_object \
					 -var_list $var_list \
					 $object_type ]

		foreach subsite_id $subsite_id_list {
			ctrl::subsite::object_rel_new -subsite_id $subsite_id -object_id $calendar_id
		}

	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if {$error_p} {
		ad_return_complaint 1 "There was a problem creating a new calendar. $errmsg "
		ad_script_abort
	}
	return $calendar_id
}

ad_proc -public ctrl::cal::day_view {
	{-cal_id:required}
	{-object_id:required}
	{-current_julian_date:required}
	{-start_time:required}
	{-end_time:required}
	{-admin_p 0}
	{-interval 30}
	{-display_24 1}
	{-event_color "#ffffcc"}
	{-default_color "#ffffff"}
	{-tomorrow_template ""}
	{-yesterday_template ""}
} {
	Create a daily view of calendar events
	@param object_id_list
	@param start_time
	@param end_time
	@param interval
} {

	set current_date [dt_julian_to_ansi $current_julian_date]
	set curr_sec [clock scan $current_date]
	set date_display_str [clock format $curr_sec -format "%A %b %d, %Y"]

	set event_list [ctrl_event::get_approved_events_by_day -object_id_list $object_id -current_date $current_date]

	set interval [expr $interval/60.0]
	set events [list]
	set events_all_day [list]
	set events_multiple_day [list]

	# rebuild event list
	foreach el $event_list {
		# handle for multiple days events
		set event_start_julian_date [lindex $el 6]
		set event_end_julian_date [lindex $el 7]

		# default nonset value
		set event_start_slot -2
		set event_end_slot -2

		# started before
		if {$event_start_julian_date < $current_julian_date} {
			set event_start_slot -1
		}
		# end in the future
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
		if {[empty_string_p $event_start_min]} { set event_start_min 0 }
		if {$event_start_slot == -2} {
			set temp [expr floor([expr [expr $event_start_min/60.0] / $interval])]
			set event_start_slot [expr $temp*$interval + $event_start_hour]
		}
		if {$event_start_min < 10} { set event_start_min "0$event_start_min" }
		if {$event_start_hour < 12} {
			set start_flag am
		} else {
			set start_flag pm
		}

		set event_end [lindex $el 2]
		set event_end_hour [string trimleft [lindex [split $event_end :] 0] 0]
		set event_end_min [string trimleft [lindex [split $event_end :] 1] 0]

		if {[empty_string_p $event_end_min]} { set event_end_min 0 }
		if {$event_end_slot == -2} {
			set temp [expr ceil([expr [expr $event_end_min/60.0] / $interval])]
			set event_end_slot [expr $event_end_hour + $temp*$interval]
		}
		if {$event_end_min < 10} { set event_end_min "0$event_end_min" }
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

		if $admin_p {
			set admin_links ":: <a href=\"events/event-ae?[export_url_vars event_id cal_id]\">Edit</a> :: <a href=\"events/event-delete?[export_url_vars event_id cal_id]\">Delete</a>"
		} else {
			set admin_links ""
		}

		set event_start_date [dt_julian_to_ansi $event_start_julian_date]
		set event_end_date [dt_julian_to_ansi $event_end_julian_date]

		# Set title and link to the event and links to download
		set event_title "<a href=\"events/event-view?[export_url_vars cal_id event_id]\">$event_title</a> \[<a href=\"vcs/${event_id}.vcs\">Download to Outlook</a> :: <a href=\"ics/$event_id.ics\">Download to Other</a> $admin_links ]"


		# Code to display multiple day events in the proper cell in the table
		# if multiple days event
#		if {$event_start_slot == -1 || $event_end_slot == 25} {
#			set multiple_events_title "<li>\[$event_start_date $event_start - $event_end_date $event_end\] $event_title</li>"
#			lappend events_multiple_day $multiple_events_title
#		} else {
#			set event_title "<li>\[$event_start - $event_end\] $event_title</li>"
#		}

		if {[lindex $el 8] == "f"} {
			if {[ctrl::cal::event::multiple_days -start_date $event_start_julian_date -end_date $event_end_julian_date]} {
				set multiple_events_title "<li>\[$event_start_date $event_start - $event_end_date $event_end\] $event_title </li>"
				lappend events_multiple_day $multiple_events_title
			} else {
				set event_title "<li>\[$event_start - $event_end\] $event_title </li>"
				lappend events [list $event_start_slot $event_end_slot $event_title $event_id]
			}
		} else {
			if {[ctrl::cal::event::multiple_days -start_date $event_start_julian_date -end_date $event_end_julian_date]} {
				set all_day_event_title "<li>\[$event_start_date - $event_end_date \] $event_title </li>"
			} else {
				set all_day_event_title "<li> $event_title </li>"
			}
			lappend events_all_day [list $event_start_slot $event_end_slot $all_day_event_title $event_id]
		}
	}

	# build up calendar table
	set day_view "<br><br><table width=\"100%\" border=0 cellpadding=2 cellspacing=2>\n<tr><td id=\"calendar-hdr\" align=center width=\"7%\">Time</td>"

	append day_view "<td align=\"center\" id=\"calendar-hdr\" width=\"90%\">
<table width=\"100%\" id=\"standard\">"
	if $admin_p {
		append day_view "<tr><td align=center colspan=2><a href=\"events/event-ae?[export_url_vars date_value=$current_date cal_id]\">Add Event</a></td></tr>\n"
	}

	append day_view "<tr><td width=\"10%\">($yesterday_template)</td><td id=\"calendar-hdr\" width=\"80%\" align=center>
Events for $date_display_str</td>
<td width=\"10%\">($tomorrow_template)</td></tr></table>
</td></tr>\n"

	if {[llength $events_all_day] > 0} {
		append day_view "<tr><td align=right>All Day</td><td bgcolor=$event_color><ul>"
		foreach ead $events_all_day {
			append day_view "[lindex $ead 2]"
		}
		append day_view "</ul></td></tr>"
	}

	if {[llength $events_multiple_day] > 0} {
		append day_view "<tr><td align=right>Multiple Days</td><td bgcolor=$event_color><ul>"
		foreach ead $events_multiple_day {
			append day_view $ead
		}
		append day_view "</ul></td></tr>"
	}

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
					set flag 3
				} elseif {($event_start_slot < $start_time) && ($event_end_slot > $end_time) && ($i == $start_time)} {
					append titles $event_title
				}
				set flag 2
			}
		}

		if {$flag == 1} {
			append day_view "<tr><td align=right><nobr>$display_time</noby></td><td bgcolor=$event_color><ul>$titles</ul></td></tr>\n"
		} elseif {$flag == 2} {
			append day_view "<tr><td align=right><nobr>$display_time</noby></td><td bgcolor=$event_color><ul>$titles</ul></td></tr>\n"
		} else {
			append day_view "<tr><td align=right><nobr>$display_time</noby></td><td bgcolor=$default_color>&nbsp;</td></tr>\n"
		}
	}

	if $admin_p {
		append day_view "<tr><td align=center colspan=2><a href=\"events/event-ae?[export_url_vars date_value=$current_date cal_id]\">Add Event</a></td></tr>\n"
	}
	append day_view "</table>\n"
	return $day_view
}

ad_proc -public ctrl::cal::option_list {
} {
	set result [list [list "All" 0]]
	db_foreach calendars {} {
		lappend result [list "$cal_name" $cal_id]
	}
	return $result
}

ad_proc -public ctrl::cal::event_categories_upd {
	{-event_id:required}
	{-event_categories:required}
} {
	Update event categories for calendar
} {
	db_dml event_categories_del {}
	foreach category_id $event_categories {
		db_dml event_categories_create {}
	}
}

ad_proc -public ctrl::cal::event_categories_recurrence_upd {
	{-repeat_template_id:required}
	{-event_categories:required}
	{-start_date:required}
} {
	Update event categories for calendar
} {
	set event_list [db_list get_event_id {}]

	foreach id $event_list {
		ctrl::cal::event_categories_upd -event_id $id -event_categories $event_categories
	}
}

ad_proc -public ctrl::cal::get_event_categories {
	{-event_id:required}
} {
	Return categories for an event
} {
	set categories [db_list get_event_categories {}]
	return $categories
}


ad_proc -public ctrl::cal::get_calendar_list {
	{-filter_by:required}
	{-filter_id:required}
	{-truncate_length 0}
} {
	Return Calendar list
} {
	if {[string equal $filter_by "subsite"]} {
		set table_constraint " , acs_rels ar, ctrl_subsite_for_object_rels csfor "
		set and_filter_by " and ar.object_id_one = :filter_id
							and ar.object_id_two = cc.cal_id
							and ar.rel_id		 = csfor.rel_id"
	} else {
		set table_constraint ""
		set and_filter_by " and cc.package_id = :filter_id "
	}

	set calendar_list [list]
	db_foreach get_calendar_list {} {
		if {$truncate_length > 0} {
			if {![string equal $cal_name $truncated_cal_name]} {
				set cal_name "$truncated_cal_name..."
			}
		}
		lappend calendar_list [list $cal_name $cal_id]
	}
	return $calendar_list
}

ad_proc -public ctrl::cal::get_admin_calendar_list {
	{-user_id:required}
} {
	Return a list of calendars, which the user has admin privilege.
	Otherwise, return the Main Calendar.
} {
	set calendar_list [db_list_of_lists get_admin_calendar_list {}]
	if {[llength $calendar_list] <= 0} {
	   set calendar_list [ctrl::cal::get_main_calendar]
   }
	return $calendar_list
}

ad_proc -public ctrl::cal::get_main_calendar {
} {
	Return Main Calendar
} {
	set calendar_list [db_list_of_lists get_main_calendar {}]
	return $calendar_list
}

