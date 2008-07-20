# /packages/ctrl-resources/tcl/crs-cnsi-procs.tcl

ad_library {
    
    Display Utilities for CNSI Room Reservation Application

    @author: kellie@ctrl.ucla.edu
    @creation-date: 06/12/07
    @cvs-id $Id: $
}

namespace eval crs::cnsi {}

ad_proc -public crs::cnsi::multiple_quantity {
    {-quantity:required}
} {
    set multiple_constant 9999

    if {$quantity==$multiple_constant} {
	set var "multiple"
    } elseif {$quantity=="multiple"} {
	set var $multiple_constant
    } else {
	set var $quantity
    }

    return $var
}


ad_proc -public crs::cnsi::context_bar {
    {-page_title:required}
    {-manage_p 0}
} {
    create context bar specifically for cnsi
} {
    if {[regexp cnsi [subsite::get_url]]} {
	if {$manage_p} {
	    set context_bar "<br>[ad_context_bar_html [list [list "../index" "Room Reservation"] [list "index" "Manage"] $page_title]]<br><br>"
	} else {
	    set context_bar "<br>[ad_context_bar_html [list [list "index" "Room Reservation"] $page_title]]<br><br>"
	}

    } else {
	set context_bar ""
    }
    return $context_bar
}

ad_proc -public crs::cnsi::calendar_context_bar {
    {-current_view:required}
} {
    Create linkage to different calendar views
} {
    switch $current_view {
	"daily" {
	    set context_bar "Day View :: <a href=\"view-all-week\">Week View</a> :: <a href=\"view-all-month\">Month View</a>"
	}
	"weekly" {
	    set context_bar "<a href=\"view-all\">Day View</a> :: Week View :: <a href=\"view-all-month\">Month View</a>"
	}	
	"monthly" {
	    set context_bar "<a href=\"view-all\">Day View</a> :: <a href=\"view-all-week\">Week View</a> :: Month View"
	}
	default {
	    set context_bar ""
	}
    }

    return $context_bar
}

ad_proc -public crs::cnsi::get_room_ids {
    {-package_id:required}
    {-subsite_id:required}
} {
    Get all room IDs for CNSI rooms
} {
    return [db_list_of_lists get_cnsi_rooms {}]
}

ad_proc -public crs::cnsi::color_code_legend {
    {-package_id:required}
    {-subsite_id:required}
} {
    create room legend
} {
    set color_code_list [db_list_of_lists get_color_codes {}]
    
    foreach var $color_code_list {
	set room_id [lindex $var 0]
	set name [lindex $var 1]
	set bgcolor [lindex $var 2]
	append room_color_code "<tr><td width=20% bgcolor=\"\#$bgcolor\">&nbsp;&nbsp;&nbsp;&nbsp;</td><td width=80% style=\"font-size:x-small;\">&nbsp;<a href=room-details?[export_url_vars room_id]>$name</a></td></tr>"
    }
    return $room_color_code
}

ad_proc -public crs::cnsi::daily_view {
    {-room_ids:required}
    {-current_julian_date:required}
    {-start_time:required}
    {-end_time:required}
    {-interval 30}
    {-display_24 0}
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
    set date_display_str [clock format $curr_sec -format "%a %b %d, %Y"]
    set from_date [string tolower [clock format [expr $curr_sec+60] -format "%Y %m %d %I %H"]]
    set to_date [string tolower [clock format [expr $curr_sec+120] -format "%Y %m %d %I %H"]]
    set admin_p	[permission::permission_p -object_id [ad_conn package_id] -privilege admin]

    if {[regexp cnsi [subsite::get_url]]} {
	set make_resv_link ""
    } else {
	#set make_resv_link "<a href=\"../room-details?[export_url_vars room_id from_date to_date]\">Make Reservation</a>"
	set make_resv_link ""
    }

    set event_list [crs::event::get_list -room_id $room_ids -viewtype "day" -current_julian_date $current_julian_date]

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
	regexp {0*([0-9]+):([0-9]+[0-9]+)} $event_start -> event_start_hour event_start_min 

	# 01 will be trimmed as 1, but be careful with 00
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
	regexp {0*([0-9]+):([0-9]+[0-9]+)} $event_end -> event_end_hour event_end_min 

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
	    set event_start_hour [expr ($event_start_hour<=12)?$event_start_hour:[expr $event_start_hour-12]]
	    set event_end_hour [expr ($event_end_hour<=12)?$event_end_hour:[expr $event_end_hour-12]]
	    set event_start "$event_start_hour:$event_start_min $start_flag"
	    set event_end "$event_end_hour:$event_end_min $end_flag"
	}

	set event_id [lindex $el 3]
	set event_title [lindex $el 4]
	set request_id [lindex $el 7]

	if {$admin_p} {
	    ## iframe acts as its own windows, a link will go to the page in iframe
	    set room_id [lindex $el 0]
	    set event_title "<a href=\"reservation-details?[export_url_vars room_id request_id]\" target=\"_parent\">$event_title</a>"
	} else {
	    set event_title "reserved"
	}
	# if multiple days event
	if {$event_start_slot == -1 || $event_end_slot == 25} {
	    set event_start_date [dt_julian_to_ansi $event_start_julian_date]
	    set event_end_date [dt_julian_to_ansi $event_end_julian_date]
	    set event_title "\[$event_start_date $event_start - $event_end_date $event_end\]&nbsp;$event_title&nbsp;"
	} else {
	    set event_title "\[$event_start - $event_end\]&nbsp;$event_title &nbsp;"
	}
	set this_room_id [lindex $el 0]
	lappend events [list $event_start_slot $event_end_slot $event_title $event_id $this_room_id]
    }

    # build up calendar table
    set day_view "<table width=\"100%\" border=0 cellpadding=2 cellspacing=2>\n"
    if {$manage_p} {
	append day_view "<td align=center colspan=2>$make_resv_link</td></tr>\n"
    }
    append day_view "<tr><td id=\"calendar-hdr\" align=center width=\"18%\">Time</td><td align=\"center\" id=\"calendar-hdr\" width=\"82%\">
<table width=\"100%\" id=\"standard\"><tr><td width=\"10%\">($yesterday_template)</td><td id=\"calendar-hdr\" width=\"80%\" align=center><nobr>$date_display_str</td>
<td width=\"10%\">($tomorrow_template)</td></tr></table>
</td></tr>\n"

    for {set i $start_time} {$i < $end_time} {set i [expr $i+$interval]} {
	# set up display time
	set display_hour [lindex [split $i .] 0]
	if {$display_hour == 0} {
	    set display_hour 12
	    set display_flag am
	} elseif {$display_hour < 12} {
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
	    set this_room_id [lindex $e 4]

	    #get color 
	    set my_bgcolor [db_string get_room_color "select color from crs_reservable_resources where resource_id = :this_room_id" -default ""]
            crs::event::get -event_id $event_id -column_array event_info

            set pname [person::name -person_id $event_info(reserved_by)]
            set pemail [party::email -party_id $event_info(reserved_by)]
            set event_title_aux $event_title
            set event_title "<tr><td><span style=\"background-color:\#${my_bgcolor};\">$event_title by ${pname}</span><br></td></tr>"

            if {$event_start_slot >= $i && $event_start_slot < $j} {
                if {$admin_p} {
                  append titles $event_title
                } else {
		  append titles "<tr><td><span style=\"background-color:\#${my_bgcolor};\">$event_title_aux </span></td></tr>"
                }
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

	# Fill in color for other cells
	if {$flag == 1} {
	    append day_view "<tr><td align=right><nobr>$display_time</nobr></td><td bgcolor=$default_color style=\"border:0px;\"><table style=\"border-style:hidden; border-color:$default_color;\">$titles</table></td></tr>\n"
	} elseif {$flag == 2} {
	    append day_view "<tr><td align=right><nobr>$display_time</nobr></td><td bgcolor=$default_color style=\"border:0px;\"><table style=\"border-style:hidden; border-color:$default_color;\">$titles</table></td></tr>\n"
	} else {
	    append day_view "<tr><td align=right><nobr>$display_time</nobr></td><td bgcolor=$default_color>&nbsp;</td></tr>\n"
	}
    }

    if {$manage_p} {
	append day_view "<tr><td align=center colspan=2>$make_resv_link</td></tr>\n"
    }
    append day_view "</table>\n"
    return $day_view
}

ad_proc -public crs::cnsi::filter_day_view {
    {-room_ids:required}
    {-current_julian_date:required}
    {-start_time:required}
    {-end_time:required}
    {-interval 30}
    {-display_24 0}
    {-default_color "\#ffffff"}
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
    set current_date [dt_julian_to_ansi $current_julian_date]
    set curr_sec [clock scan $current_date]
    set date_display_str [clock format $curr_sec -format "%a %b %d, %Y"]

    set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]

    append day_view "<table width=\"100%\"><tr>
                            <td width=\"30%\" align=left>$yesterday_template</td>
			    <td width=\"40%\" align=center><nobr>$date_display_str</td>
                            <td width=\"30%\" align=right>$tomorrow_template</td>
                     </tr></table>\n"

    set interval [expr $interval/60.0]
    set events_all [list]

    # Get room ids that actually have events so daily view only displays ones with events
    set current_ansi_date [dt_julian_to_ansi $current_julian_date]
    set room_id_list [db_list_of_lists get_room_ids {}]

    # set <td> width based on the how many objects are selected
    if {[llength $room_id_list] > 0} {
	set td_width [expr [expr 100 -7] / [llength $room_id_list]]
    } else {
	set td_width 93
    }

    foreach var $room_id_list {
	set room_id [lindex $var 0]
	crs::resource::get -resource_id $room_id -column_array room_info
	set color "\#$room_info(color)"
	set room_name "$room_info(name)"
	set event_list_all [crs::event::get_list -room_id $room_id -viewtype "day" -current_julian_date $current_julian_date]

	set events [list]
	# rebuild event list #######################################################

	foreach el $event_list_all {
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
	    regexp {0*([0-9]+):([0-9]+[0-9]+)} $event_end -> event_end_hour event_end_min

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
		set event_title "\[$event_start_date $event_start-$event_end_date $event_end\] &nbsp;"
	    } else {
		set event_title "<a href=\"reservation-details?[export_url_vars room_id request_id]\" target=\"_parent\">$event_title</a>"
		set event_title "\[$event_start-$event_end\] <a href=\"reservation-details?[export_url_vars room_id request_id]\" target=\"_parent\">$event_title</a> &nbsp;"
	    }
	    lappend events [list $event_start_slot $event_end_slot $event_title $event_id $color $room_name]
	}

	# END rebuild event list ###################################################
	lappend events_all $events
    }

    # build up calendar table
    append day_view "<table width=\"100%\" border=0 cellpadding=2 cellspacing=2>\n"

    for {set i $start_time} {$i < $end_time} {set i [expr $i+$interval]} {
	# set up display time
	set display_hour [lindex [split $i .] 0]
	if {$display_hour < 12} {
	    set display_flag am
	} else {
	    set display_flag pm
	}
	if {$display_24 != 1} {
	    set display_hour [expr $display_hour<=12?$display_hour:[expr $display_hour-12]]
	    if {[string equal $display_hour 0]} {set display_hour 12}
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

#	    append day_view "<td>"

	    foreach e $e_list {
		set event_start_slot [lindex $e 0]
		set event_end_slot [lindex $e 1]
		set event_title [lindex $e 2]
		set event_id [lindex $e 3]
		set event_color [lindex $e 4]
		set event_room [lindex $e 5]
		
		if {$event_start_slot >= $i && $event_start_slot < $j} {
		    append titles "<b>$event_room</b><br>$event_title"
		    set flag 1
		} elseif {$event_start_slot < $i && $event_end_slot > $i} {
		    if {($event_start_slot == -1 || $event_end_slot==25) && $i == $start_time} {
			append titles "<b>$event_room</b><br>$event_title"
		    } elseif {($event_start_slot < $start_time) && ($event_end_slot > $end_time) && ($i == $start_time)} {
			append titles "<b>$event_room</b><br>$event_title"
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
#	    append day_view "</td>"
	}

	append day_view "</tr>\n"
    } 
    # END build table ##########################################################

    append day_view "</table>\n"

    append day_view "<table width=\"100%\"><tr>
                            <td width=\"50%\" align=left>$yesterday_template</td>
                            <td width=\"50%\" align=right>$tomorrow_template</td>
                     </tr></table>\n"

    return $day_view
}

