# /packages/ctrl-calendar/www/view-month.tcl

ad_page_contract {

    Monthly View of Calendar

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/19/2005
    @cvs-id $Id$
} {
    {cal_id:naturalnum "0"}
    {ansi_date:optional}    
}

if {$cal_id} {
    set selection [ctrl::cal::get -cal_id $cal_id -column_array cal_info]
    if {!$selection} {
	ad_return_error "Error" "The calendar you selected does not exist in the database. Please go back and select another calendar. Thank you."
	return
    }
    set object_id_list $cal_info(object_id)
    set page_title "$cal_info(cal_name) -  Weekly View"

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
	
    set page_title "$subsite_name Weekly View"

}

set context [list $page_title]
#AMK TEMP HACK
#set admin_p [permission::permission_p -object_id $cal_id -privilege "admin"]
set admin_p 1

if $admin_p {
    set event_ae_link "<center><a href=\"events/event-ae?[export_url_vars cal_id]\">Add Event</a></center>"
} else {
    set event_ae_link ""
}

### SET UP CALENDAR PARAMETERS ################################################################################################
if {[info exists ansi_date]} {
    set current_date $ansi_date
} else {
    set current_date [dt_sysdate]
}

set next_month_template "( <a href=\"view-month?[export_url_vars cal_id]&ansi_date=\$ansi_date\">Next Month</a> )"
set prev_month_template "( <a href=\"view-month?[export_url_vars cal_id]&ansi_date=\$ansi_date\">Previous Month</a> )"
set day_number_template "<a href=view-day?[export_url_vars cal_id]&julian_date=\$julian_date>\$day_number</a>"

### END SETTING UP CALENDAR PARAMETERS #########################################################################################


### SET UP OBJECT EVENTS ######################################################################################################
set julian_date [dt_ansi_to_julian_single_arg $current_date]

set calendar_details [ns_set create calendar_details]
set object_event_info [ctrl::cal::event::get_list -object_id_list $object_id_list -viewtype "month" -current_julian_date $julian_date]

set julian_start_date_temp ""
set events_display ""
set events_display_all_day ""

foreach date_info $object_event_info {
    set julian_start_date [lindex $date_info 0]
    set julian_end_date [lindex $date_info 1]
    set start_time [lindex $date_info 2]
    set title [lindex $date_info 3]
    set event_id [lindex $date_info 4]
    set all_day_p [lindex $date_info 5]
    set start_date [lindex $date_info 6]
    set end_date [lindex $date_info 7]

    # Determine if this is a multiple event
    set multiple_p [ctrl::cal::event::multiple_days -start_date $start_date -end_date $end_date]

    # ------------------------------------------------------------------------------------------------------------------
    # Need to populate all dates of this multiple day event in advance 
    # so it will display even if there are no other events of the same date
    # ------------------------------------------------------------------------------------------------------------------
    if {$multiple_p} {
	set julian $julian_start_date
	while {$julian <= $julian_end_date} {
	    
	    if {[exists_and_not_null events_display_multiple_$julian]} {
		# Concat all multiple day events on this date
		set events_display_multiple_$julian [concat [set events_display_multiple_$julian] \
						 "<a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"]
	    } else {
		set events_display_multiple_$julian "<a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"
	    }

	    # Store all multiples
	    ns_set update $calendar_details $julian [set events_display_multiple_$julian]
	    incr julian
	}
    }
    # ------------------------------------------------------------------------------------------------------------------
    # END of handle multiple events
    # ------------------------------------------------------------------------------------------------------------------

    if {$julian_start_date_temp==$julian_start_date} {
	if {$multiple_p} {
	    #do nothing, multiples are handled first
	}  elseif {$all_day_p=="t"} {
	    set events_display_all_day [concat $events_display_all_day \
					    "<a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"]
	} else {
	    set events_display [concat $events_display \
				    "$start_time <a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"]	
	}	
    } else {
	# Reset variables
	set julian_start_date_temp $julian_start_date
	set events_display_all_day ""
	set events_display ""
	
	if {$multiple_p} {
	    #do nothing, multiples are handled first
	} elseif {$all_day_p=="t"} {
	    set events_display_all_day "<a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"
	} else {
	    set events_display "$start_time <a href=\"events/event-view?[export_url_vars event_id cal_id]\">$title</a><br>"
	}
    }

    # Display events in the order of all day event (no time), multiple events (no time), regular event (with a start time).
    if {[exists_and_not_null events_display_multiple_$julian_start_date]} {	
	set display [concat $events_display_all_day [set events_display_multiple_$julian_start_date] $events_display]
    } else {
	set display [concat $events_display_all_day $events_display]
    }

    ns_set update $calendar_details $julian_start_date $display
}
### END SETTING UP OBJECT EVENTS ###############################################################################################
