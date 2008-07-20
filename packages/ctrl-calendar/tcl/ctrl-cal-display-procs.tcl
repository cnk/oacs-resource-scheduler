# /packages/ctrl-calendar/tcl/ctrl-cal-display-procs.tcl	-*- tab-width: 4 -*-
ad_library {

	CTRL Calendar Display Procs for the Monthly, Daily, Weekly View.  These are
	based on the tcl/acs-calendar-procs.tcl in the acs-datetime package and
	www/view-month-display.adp but have been rewritten for ctrl-calendar.

	@author			avni@ctrl.ucla.edu (AK)
	@creation-date	8/4/2007
	@cvs-id			$Id$
}

namespace eval ctrl::cal::display {}

ad_proc ctrl::cal::display::month {
	{-cal_id}
	{-calendar_events ""}
	{-date ""}
	{-days_of_week ""}
} {
	Returns a calendar for a specific month, with details supplied
	by Julian date. Defaults to this month.

	To specify details for the individual days (if large_calendar_p is
	set) put data in an ns_set calendar_events.	 The key is the
	Julian date of the day, and the value is a string (possibly with
	HTML formatting) that represents the details.
} {

	set html ""

	### SETUP DATE VARIABLES ########################################
	if [empty_string_p $days_of_week] {
		set days_of_week "[_ acs-datetime.days_of_week]"
	}

	dt_get_info $date
	set today_date [dt_sysdate]

	if [empty_string_p $calendar_events] {
		set calendar_events [ns_set create calendar_events]
	}

	set day_of_week $first_day_of_month
	set julian_date $first_julian_date
	### END SETTING UP DATE VARIABLES ################################

	# prev month link
	set prev_month_url	?[export_vars {cal_id {ansi_date $prev_month}}]
	set prev_month_link	"<a href=\"$prev_month_url\" title=\"Previous Month\"><img src=\"/resources/calendar/images/left.gif\" alt=\"Previous Month\" border=\"0\" /></a>"

	# next month link
	set next_month_url	?[export_vars {cal_id {ansi_date $next_month}}]
	set next_month_link	"<a href=\"$next_month_url\" title=\"Next Month\"><img src=\"/resources/calendar/images/right.gif\" alt=\"Next Month\" border=\"0\" /></a>"

	### MONTH HEADER ####################################
	set month_heading [format "%s %s" $month $year]
	append html "
		<h1 class='cal-month-header-blue' align='center'>
			$prev_month_link
			<font color='white'>&nbsp;$month_heading&nbsp;</font>
			$next_month_link
		</h1>
	"
	### END MONTH HEADER ################################

	### BEGIN CONTENT ROWS ##################################################################################################################################
	append html "
		<div>
			<table class='cal-table-display' cellpadding='0' cellspacing='0' border='0' width='99%'
				summary=\"calendar grid display for $month_heading\">
	"

	# DAYS OF WEEK ######################################
	append html "<tr>"
	foreach day_of_week $days_of_week {
		append html "<th width='14%' class='cal-month-day-title'>$day_of_week</td>"
	}

	append html "</tr>"
	# END DAYS OF WEEK ##################################

	# CAL MONTH TABLE ###################################
	append html {
	<tr><td colspan="7">
			<table class="cal-month-table" cellpadding="0" cellspacing="0" border="0" width="100%">
				<tbody>
	}

	set day_of_week			1
	set julian_date			$first_julian_date
	set day_number			$first_day

	set today_ansi_list		[dt_ansi_to_list $today_date]
	set today_julian_date	[dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]

	while {1} {
		if {$julian_date < $first_julian_date_of_month} {
			set before_month_p	1
			set after_month_p	0
		} elseif {$julian_date > $last_julian_date_in_month} {
			set before_month_p	0
			set after_month_p	1
		} else {
			set before_month_p	0
			set after_month_p	0
		}

		if {$julian_date == $first_julian_date_of_month} {
			set day_number 1
		} elseif {$julian_date > $last_julian_date} {
			break
		} elseif {$julian_date == [expr $last_julian_date_in_month+1]} {
			set day_number 1
		}

		if { $day_of_week == 1} {
			append html "<tr>"
		}

		if {$before_month_p || $after_month_p} {
			append html "<td class='cal-month-day-inactive' width='14%'>&nbsp;<a href=\"view-day?[export_vars {cal_id julian_date}]\">$day_number</a>"

		} else {
			if {$julian_date == $today_julian_date} {
				set the_class "cal-month-today"
			} else {
				set the_class "cal-month-day"
			}

			append html "<td class=\"$the_class\" width='14%' onclick=''>&nbsp;<a href=\"view-day?[export_vars {cal_id julian_date}]\" title=\"Go to day $day_number\">$day_number</a>"
		}


		set calendar_day_index [ns_set find $calendar_events $julian_date]

		while { $calendar_day_index >= 0 } {
			set calendar_day [ns_set value $calendar_events $calendar_day_index]

			ns_set delete $calendar_events $calendar_day_index

			append html "<div class='cal-month-event calendar-Item'><span class='cal-text-grey-sml'>$calendar_day</span></div>"

			set calendar_day_index [ns_set find $calendar_events $julian_date]
		}
		append html "</td>"

		incr day_of_week
		incr julian_date
		incr day_number

		if { $day_of_week > 7 } {
			set day_of_week 1
			append html "</tr>"
		}
	}
	# END CAL MONTH TABLE ################################

	# PREV NEXT LINKS
	append html {
				</tbody>
			</table>
		</td>
	</tr>
	<tr><td colspan="7">
			<table width="100%">
				<tr><td class="calendar-back-forward">} $prev_month_link {</td>
					<td class="calendar-back-forward" align="right">
						} $next_month_link {
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table></div>
	}

	return $html
}
