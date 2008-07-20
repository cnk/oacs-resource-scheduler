# /packages/ctrl-calendar/www/view-weekly.tcl
ad_page_contract {

    Weekly View of Calendar

    @author reye@mednet.ucla.edu
    @creation-date 02/01/2006
    @cvs-id $Id

} {
    {cal_id:naturalnum "0"}
    {julian_date:optional ""}
}

if {$cal_id} {
    set selection [ctrl::cal::get -cal_id $cal_id -column_array cal_info]
    if {!$selection} {
	ad_return_error "Error" "The calendar you selected does not exist in the database. Please go back and select another calendar. Thank you."
	return
    }
    set object_id_list $cal_info(object_id)
    set page_title "$cal_info(cal_name) - Weekly View"
} else {
    set instance_id [ad_conn package_id]
    set subsite_id [ad_conn subsite_id]
    set subsite_name ""
    
    set filter_by [parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance]
   
    set calendar_list [ctrl::cal::get_calendar_list -filter_by $filter_by -filter_id [set ${filter_by}_id]]
    set object_id_list [list]
    foreach calendar $calendar_list {
	set calendar_id [lindex $calendar 1]
	lappend object_id_list $calendar_id
    }
    set object_id_list_for_sql [join $object_id_list ","]
    set page_title "$subsite_name Weekly View"
}

set context [list $page_title]

# AMK TEMP HACK
set admin_p 1
#set admin_p [permission::permission_p -object_id $cal_id -privilege "admin"]

### SET UP CALENDAR PARAMETERS ################################################################################################
if {![empty_string_p $julian_date]} {
    set current_date [dt_julian_to_ansi $julian_date]
} else {
    set current_date [dt_sysdate]
    set julian_date [dt_ansi_to_julian_single_arg $current_date]
}

set next_julian_date [expr $julian_date + 7]
set previous_julian_date [expr $julian_date - 7]

set next_week_template "( <a href=view-week?[export_url_vars cal_id]&julian_date=$next_julian_date>Next Week</a> )"
set prev_week_template "( <a href=view-week?[export_url_vars cal_id]&julian_date=$previous_julian_date>Previous Week</a> )"
#set day_number_template "<a href=view-day?[export_url_vars cal_id]&julian_date=$julian_date>$day_number</a>"

### END SETTING UP CALENDAR PARAMETERS #########################################################################################

### SET UP OBJECT EVENTS #######################################################################################################

set calendar_details [ns_set create calendar_details]
set object_event_info [ctrl::cal::event::get_list -cal_id_list $object_id_list -viewtype "week" -current_julian_date $julian_date]
set events_display ""



# get all unique julian date from object_event_info in a list
set julian_list [db_list get_juilian_date {}]
db_1row julian_week_date_list {**SQL**} 
set julian_list [list $sunday_j $sunday_date $monday_j $monday_date $tuesday_j $tuesday_date \
		     $wednesday_j $wednesday_date $thursday_j $thursday_date $friday_j $friday_date $saturday_j $saturday_date]

set return_url "../view-week?[export_url_vars cal_id julian_date]"

# foreach julian date, build display of that date
foreach [list j_date date_value] $julian_list {
    set events_display ""
    set cell_display ""
    set cell_display_top ""

    foreach date_info $object_event_info {
	    set julian_start_date [lindex $date_info 0]
            set julian_end_date   [lindex $date_info 1]
	    set start_date        [lindex $date_info 2]
	    set end_date          [lindex $date_info 3]
	    set start_time        [lindex $date_info 4]
	    set end_time          [lindex $date_info 5]
	    set event_id          [lindex $date_info 6]
	    set title             [lindex $date_info 7]
            set title                               [expr {[string length $title] > 8?"[string range $title 0 7]..":$title}]
	    set all_day_p         [lindex $date_info 8]

	if {$julian_start_date == $j_date || 
            $julian_end_date == $j_date ||
	   ($julian_start_date <= $j_date && $j_date <= $julian_end_date)} {

	    set multiple_p [ctrl::cal::event::multiple_days -start_date $start_date -end_date $end_date]

	    if $admin_p {
		set admin_links ":: <a href=\"events/event-ae?[export_url_vars event_id cal_id julian_date]\">Edit</a> :: <a href=\"events/event-delete?[export_url_vars event_id cal_id julian_date]\">Delete</a> "
	    } else {
		set admin_links ""
	    }

	    if {$all_day_p=="t" || $multiple_p=="1"} {
		append cell_display_top "<li> <a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a> &nbsp;\[<a href=\"vcs/${event_id}.vcs\">Download to Outlook</a> ::  <a href='ics/$event_id.ics'>Download To Other</a> $admin_links\]</li>"
	    } else {
		append cell_display "<li>\[$start_time - $end_time] <a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a> &nbsp;\[<a href=\"vcs/${event_id}.vcs\">Download to Outlook</a> ::  <a href='ics/$event_id.ics'>Download To Other</a> $admin_links\]</li>"
	    }
	}
    }
    set cell_display [concat $cell_display_top $cell_display]
    if ![empty_string_p $cell_display] {
	set events_display "<ul>$cell_display</ul>"
    }
    if $admin_p {
	append events_display "<a href=\"events/event-ae?[export_url_vars cal_id date_value return_url]\">Add Event</a>"
    }
    ns_set update $calendar_details $j_date $events_display
}
### END SETTING UP OBJECT EVENTS ###############################################################################################

### DISPLAY WEEKLY CALENDAR ####################################################################################################
set calendar [dt_widget_week -calendar_details $calendar_details \
		  -date $current_date \
		  -next_week_template $next_week_template \
		  -prev_week_template $prev_week_template \
		  -calendar_width "800" \
		  -master_bgcolor "#aaaaaa" \
		  -header_bgcolor "#339900" \
		  -header_text_color "#242942" \
		  -header_text_size "4" \
		  -day_header_size 2 \
		  -day_header_bgcolor "#FFCC00" \
		  -day_bgcolor "#ffffff" \
		  -today_bgcolor "#aaaaaa" \
		  -day_text_color "#4D4DB4" \
		  -empty_bgcolor "#cccccc" \
		  -prev_next_links_in_title 1]
### END DISPLAY WEEKLY CALENDAR ################################################################################################
