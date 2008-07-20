# /packages/ctrl-calendar/tcl/ctrl-cal-event-procs.tcl		-*- tab-width: 4 -*-
ad_library {

	Calendar Event Procedures
	Uses tables from CTRL Events

	@author			avni@ctrl.ucla.edu (AK)
	@creation-date	12/19/05
	@cvs-id			$Id$
}

namespace eval ctrl::cal {}
namespace eval ctrl::cal::event {}

ad_proc -public ctrl::cal::event::insert {
	{-cal_id:required}
	{-event_id:required}
} {
	Proc which inserts a row into
	ctrl_calendar_event_map
	mapping an event_id to a calendar_id
} {
	db_dml ccem_insert {}
	return
}

ad_proc -public ctrl::cal::event::del {
	{-event_id:required}
} {
	Proc which deletes all rows
	in ctrl-event_event_map
	for the event_id passed in
} {
	db_dml ccem_del {}
}

ad_proc -public ctrl::cal::event::get_list {
	{-cal_id_list:required}
	{-viewtype:required}
	{-current_julian_date:required}
} {
	Function which returns events
	for the object list (123,124) given
	for the specified calendar view (day|week|month)
	for the specified julian date (12345)

	Returns a list of lists
	For viewtype
	day:   returns lists of lists with each inner list containing "event_id event_start_time event_end_time"
	month: returns lists of lists with each inner list containing "unique_date event_html"
	week: TODO -> needs to be implemented	 (the week selection needs work)
} {
	set current_ansi_date [dt_julian_to_ansi $current_julian_date]
	switch $viewtype {
		day {
			return [ctrl::cal::event::day_list -cal_id_list $cal_id_list -current_date $current_ansi_date]
		}
		month {
			return [ctrl::cal::event::month_list -cal_id_list $cal_id_list -current_date $current_ansi_date]
		}
		week {
			return [ctrl::cal::event::week_list -cal_id_list $cal_id_list -current_date $current_ansi_date]
		}
		default {
			return 0
		}
	}
}

ad_proc -public ctrl::cal::event::month_list {
	{-cal_id_list:required}
	{-current_date:required}
} {
	Function which returns events in the month format
	for the object list (123,124) given
	for the specified julian date (12345)

	Returns lists of lists with each inner list containing "unique_date event_html"
} {
	set month_event_list [list]

	set cal_id_list [join $cal_id_list ","]
	db_foreach get_month_event_list {} {
		lappend month_event_list		\
			[list	$julian_start_date	\
					$julian_end_date	\
					$start_date			\
					$end_date			\
					$start_time			\
					$end_time			\
					$event_id			\
					$title				\
					$all_day_p			\
					$cal_id				]
	}

	return $month_event_list
}

ad_proc -public ctrl::cal::event::week_list {
	{-cal_id_list:required}
	{-current_date:required}
} {
	Function which returns events in the week format
	for the object list (123,124) given
	for the specified julian date (12345)

	Returns lists of lists with each inner list containing "unique_date event_html"
} {
	set week_event_list ""

	set cal_id_list [join $cal_id_list ","]
	db_foreach get_week_event_list {} {
		lappend week_event_list [list $julian_start_date $julian_end_date $start_date $end_date $start_time $end_time $event_id $title $all_day_p]
	}

	return $week_event_list
}

ad_proc -public ctrl::cal::event::day_list {
	{-cal_id_list:required}
	{-current_date:required}
} {
	Function which returns events in the month format
	for the object list (123,124) given
	for the specified julian date (12345)

	Returns lists of lists with each inner list containing "unique_date event_html"
} {
	set day_event_list [list]

	set cal_id_list [join $cal_id_list ","]
	db_foreach day_event_list {} {
		lappend day_event_list [list $julian_start_date $julian_end_date $start_date $end_date $start_time $end_time $event_id $title $all_day_p]
	}

	return $day_event_list
}

ad_proc -public ctrl::cal::event::multiple_days {
	{-start_date:required}
	{-end_date:required}
} {
	if {$start_date==$end_date} {
		set multiple_p 0
	} else {
		set multiple_p 1
	}

	return $multiple_p
}

ad_proc -public ctrl::cal::event::log_download {
	{-event_id:required}
} {
	Proc which records a user downloading an event
} {
	set user_id [ad_conn user_id]
	if {$user_id != "0"} {
		set email [db_string get_email {} -default ""]
		if {![db_string record_exists_p {}] } {
			db_dml log_download {}
		}
	}

	return
}

