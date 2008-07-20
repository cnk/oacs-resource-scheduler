# /packages/ctrl-calendar/www/view-month.tcl				-*- tab-width: 4 -*-
ad_page_contract {

	Monthly View of Calendar with each box showing all-day multi-day events,
	all-day single-day events, and partial-day single-day events.

	@author			avni@ctrl.ucla.edu (AK)
	@creation-date	12/19/2005
	@cvs-id			$Id$

} {
	{cal_id:naturalnum,optional}
	{calendars:naturalnum,optional,multiple [list]}
	{ansi_date:optional}
}

set package_id [ad_conn package_id]

if {[llength $calendars] > 0} {
	set existing_calendars [db_list names_of_existing_calendars {}]
	if {[llength $existing_calendars] < [llength $calendars]} {
		ad_return_error "Error" "
			<p>Not all of the calendars you selected exist on this site.  Please
			go back and select other calendars. The following calendars are
			<em>OK</em>:
				<ul><li>[join $existing_calendars "</li><li>"]</li></ul>
			</p>

			<p>Thank you.</p>
		"
		return
	}
}

if {[llength $calendars] <= 0} {
	if {![exists_and_not_null cal_id] || $cal_id == 0} {
		set calendars [db_list all_calendars {}]
	} else {
		set calendars [list $cal_id]
	}
}

if {[llength $calendars] <= 0} {
	ad_return_error "No calendars" "The database has no calendars."
	return
} elseif {[llength $calendars] == 1} {
	set cal_id		[lindex $calendars 0]
	ctrl::cal::get -cal_id $cal_id -column_array cal_info
	set page_title	"$cal_info(cal_name) -  Monthly View"
	set context		[list $page_title]
} else {
#	set cal_id		[lindex $calendars 0]
	set page_title	"Monthly View"
	set context		[list $page_title]
}

### SET UP CALENDAR PARAMETERS #################################################################################################
if {[info exists ansi_date]} {
	set current_date $ansi_date
} else {
	set current_date [dt_sysdate]
}
### END SETTING UP CALENDAR PARAMETERS #########################################################################################

### SET UP OBJECT EVENTS #######################################################################################################
if {[exists_and_not_null cal_id]} {
	set old_cal_id			$cal_id
}
set julian_date			[dt_ansi_to_julian_single_arg $current_date]
set calendar_events		[ns_set create calendar_events]
set object_event_info	[ctrl::cal::event::get_list				\
							-cal_id_list			$calendars	\
							-viewtype				"month"		\
							-current_julian_date	$julian_date]
set last_julian_day		""
set events_html			""
set all_day_events_html	""

foreach date_info $object_event_info {
	set julian_start_date	[lindex $date_info 0]
	set julian_end_date 	[lindex $date_info 1]
	set start_date 			[lindex $date_info 2]
	set end_date 			[lindex $date_info 3]
	set start_time 			[lindex $date_info 4]
	set end_time 			[lindex $date_info 5]
	set event_id 			[lindex $date_info 6]
	set title 				[lindex $date_info 7]
	set title 				[expr {[string length $title] > 8?"[string range $title 0 7]..":$title}]
	set all_day_p 			[lindex $date_info 8]
	set cal_id 				[lindex $date_info 9]


	# Determine if this is a multiple-day event
	set multiple_p	[ctrl::cal::event::multiple_days	\
						-start_date	$start_date			\
						-end_date	$end_date			]
	############################################################################
	# Populate all dates of this multiple day event in advance so it will
	# display even if there are no other events of the same date
	if {$multiple_p} {
	   set julian $julian_start_date
	   while {$julian <= $julian_end_date} {
	      set url [export_vars -base events/event-view {event_id cal_id}]
              set link	"<a href=\"$url\">$title</a><br />"
   	      append	multiday_events_on_jday_${julian}_html $link

	      # Store all multiples
	      ns_set update $calendar_events $julian [set multiday_events_on_jday_${julian}_html]
	      incr julian
	   }
        }

	############################################################################
	# Populate single-day/intra-day events
	set url		[export_vars -base events/event-view {event_id cal_id}]
	set link	"<a href=\"$url\">$title</a><br />"

	if {$last_julian_day != $julian_start_date} {
		# Reset variables
		set last_julian_day		$julian_start_date
		set all_day_events_html	""
		set events_html			""
	}

	if {$multiple_p} {
		# do nothing, multiday events were already handled above
	}  elseif {$all_day_p == "t"} {
		append all_day_events_html	$link
	} else {
		append events_html			$start_time {&nbsp;} $link
	}

	# Display events in the order: all day events (no start time), multi-day events (no start time), regular events (with a start time).
	set julian_day_html $all_day_events_html
	if {[exists_and_not_null multiday_events_on_jday_${julian_start_date}]} {
		append julian_day_html [set multiday_events_on_jday_${julian_start_date}]
	}

        if {![empty_string_p $events_html]} {
	   append julian_day_html $events_html
	   ns_set update $calendar_events $julian_start_date $julian_day_html
        }
}

# Restore the old state of 'cal_id'.  Unset it if it was not set prior to the
# above loop and it is set after the loop.
if {[exists_and_not_null old_cal_id]} {
	set cal_id $old_cal_id
} elseif {[exists_and_not_null cal_id]} {
	unset cal_id
}

### END SETTING UP OBJECT EVENTS ###############################################################################################

### DISPLAY CALENDAR ###########################################################################################################

if {[exists_and_not_null cal_id]} {
	set month_calendar_html [ctrl::cal::display::month	\
		-cal_id				$cal_id						\
		-calendar_events	$calendar_events			\
		-date				$current_date				]
} else {
	set month_calendar_html [ctrl::cal::display::month	\
		-calendar_events	$calendar_events			\
		-date				$current_date				]
}
### END DISPLAY CALENDAR #######################################################################################################
