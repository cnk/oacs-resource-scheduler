ad_library {
    General procedures for repetition events: add repeating pattern and add recurrent events
    @creation-date 06/21/05
    @cvs_id $id$
}

namespace eval ctrl_event::repetition::date {}

ad_proc -public ctrl_event::repetition::date::repeat {
    -event_id:required
    -frequency_type:required
    -repeat_end_date_opt:required
    {-frequency_day ""}
    {-frequency_week ""}
    {-frequency_month ""}
    {-frequency_year ""}
    {-specific_day_frequency ""}
    {-specific_days_week ""}
    {-specific_months ""}
    {-specific_days_month ""}
    {-specific_dates_of_month_month ""}
    {-specific_dates_of_month_year ""}
    {-repeat_month_opt1 ""}
    {-repeat_month_opt2 ""}
    {-repeat_end_date ""}
    -event_object_id:required
    -title:required
    -start_date:required
    -end_date:required
    -all_day_p:required
    -location:required
    -notes:required
    -capacity:required
    {-event_image ""}
    {-event_image_caption ""}
    -category_id:required
    -context_id:required
    -package_id:required
} {
    Proc which encapsulates the repetition of an event
    Returns a list of event_id that was added (08/28/2006)
} {
    set event_id_list ""
    set invalid_recurrence_msg "The recurrence pattern you entered is not valid."
    switch $frequency_type {
	"daily" {
	    
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 24 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $frequency_day]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
										
	    set event_id_list [ctrl_event::repetition::date::daily -event_id $event_id \
				   -event_object_id $event_object_id \
				   -repeat_template_id $event_id \
				   -repeat_template_p "f" \
				   -title $title \
				   -start_date $start_date \
				   -end_date $end_date \
				   -all_day_p $all_day_p \
				   -location $location \
				   -notes $notes \
				   -capacity $capacity \
				   -event_image $event_image \
				   -event_image_caption $event_image_caption \
				   -category_id $category_id \
				   -frequency $frequency_day \
				   -repeat_end_date $repeat_end_date \
				   -context_id $context_id \
				   -package_id $package_id]
	}
	
	"weekly" {
	    
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 24 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $frequency_week] || [empty_string_p $specific_days_week]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
	    
	    set event_id_list [ctrl_event::repetition::date::weekly -event_id $event_id \
				   -event_object_id $event_object_id \
				   -repeat_template_id $event_id \
				   -repeat_template_p "f" \
				   -title $title \
				   -start_date $start_date \
				   -end_date $end_date \
				   -all_day_p $all_day_p \
				   -location $location \
				   -notes $notes \
				   -capacity $capacity \
				   -event_image $event_image \
				   -event_image_caption $event_image_caption \
				   -category_id $category_id \
				   -frequency $frequency_week \
				   -specific_days $specific_days_week \
				   -repeat_end_date $repeat_end_date \
				   -context_id $context_id \
				   -package_id $package_id]
	}
	
	"monthly" {
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 24 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {$repeat_month_opt1 == "1"} {
		
		set monthly_option "1"
		set frequency $frequency_month
		set specific_dates_of_month $specific_dates_of_month_month
		set specific_day_frequency ""
		set specific_days ""
		
		if {[empty_string_p $frequency] || [empty_string_p $specific_dates_of_month]} {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}
		
	    } elseif {$repeat_month_opt2 == "1"} {
		
		set monthly_option "2"
		set frequency "1"
		set specific_days $specific_days_month
		set specific_dates_of_month ""
		
		if {[empty_string_p specific_days_month]} {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}
		
	    } else {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
	    
	    set event_id_list [ctrl_event::repetition::date::monthly -event_id $event_id \
				   -event_object_id $event_object_id \
				   -repeat_template_id $event_id \
				   -repeat_template_p "f" \
				   -title $title \
				   -start_date $start_date \
				   -end_date $end_date \
				   -all_day_p $all_day_p \
				   -location $location \
				   -notes $notes \
				   -capacity $capacity \
				   -event_image $event_image \
				   -event_image_caption $event_image_caption \
				   -category_id $category_id \
				   -frequency $frequency \
				   -specific_day_frequency $specific_day_frequency \
				   -specific_days $specific_days \
				   -specific_dates_of_month $specific_dates_of_month \
				   -repeat_end_date $repeat_end_date \
				   -monthly_option $monthly_option \
				   -context_id $context_id \
				   -package_id $package_id]
	}
	
	"yearly" {
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 120 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $specific_months] || [empty_string_p $specific_dates_of_month_year]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
	    
	    set event_id_list [ctrl_event::repetition::yearly -event_id $event_id \
				   -event_object_id $event_object_id \
				   -repeat_template_id $event_id \
				   -repeat_template_p "f" \
				   -title $title \
				   -start_date $start_date \
				   -end_date $end_date \
				   -all_day_p $all_day_p \
				   -location $location \
				   -notes $notes \
				   -capacity $capacity \
				   -event_image $event_image \
				   -event_image_caption $event_image_caption \
				   -category_id $category_id \
				   -frequency $frequency_year \
				   -specific_dates_of_month $specific_dates_of_month_year \
				   -specific_months $specific_months \
				   -repeat_end_date $repeat_end_date \
				   -context_id $context_id \
				   -package_id $package_id]
	}
	
	default {
	    ad_return_complaint 1 $invalid_recurrence_msg
	    ad_script_abort
	}
    }

    ad_return_complaint 1 $event_id_list
    return $event_id_list
}

ad_proc -public ctrl_event::repetition::date::daily {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-start_date:required} 
    {-end_date:required} 
    {-all_day_p "f"} 
    {-location:required} 
    {-notes:required} 
    {-capacity:required}
    {-event_image ""}
    {-event_image_caption ""}
    {-category_id:required}
    {-frequency:required}
    {-repeat_end_date:required}
    {-context_id:required}
    {-package_id:required}
} {
    Adds recurring daily events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param start_date
    @param end_date
    @param all_day_p
    @param location
    @param notes
    @param capacity
    @param event_image
    @param event_image_caption
    @param category_id
    @param frequency
    @param repeat_end_date
    @param context_id
    @param package_id
} {
    set event_start_date_list ""
    set event_end_date_list ""

    set frequency_type "daily"
    ctrl_event::repetition::validation -frequency_type $frequency_type \
                                       -frequency $frequency \
	                               -specific_days_of_week "" \
	                               -start_date $start_date \
		                       -end_date $end_date
    set fail_p [catch {

	set frequency_param $frequency	
	set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 

	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
	    set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
	    set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]
		    
	    lappend event_start_date_list $new_start_date_str
	    lappend event_end_date_list $new_end_date_str
		
	    # GETTING NEW START DATE BASED ON THE PREVIOUS START DATE (START DATE THAT WAS JUST INSERTED)
	    set new_start_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $frequency]	
	    # GETTING NEW END DATE BASED ON THE PREVIOUS END DATE (END DATE THAT WAS JUST INSERTED)
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	}
    } errmsg]	
	
    if {$fail_p != 0} {
	error $errmsg
    }
    return lappend event_start_date_list $event_end_date_list
}

ad_proc -public ctrl_event::repetition::date::weekly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-start_date:required} 
    {-end_date:required} 
    {-all_day_p "f"} 
    {-location:required} 
    {-notes:required} 
    {-capacity:required}
    {-event_image ""}
    {-event_image_caption ""}
    {-category_id:required}
    {-frequency:required}
    {-specific_days ""}
    {-repeat_end_date:required}
    {-context_id:required}
    {-package_id:required}
} {
    Adds recurring weekly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param start_date
    @param end_date
    @param all_day_p
    @param location
    @param notes
    @param capacity
    @param event_image
    @param event_image_caption
    @param category_id
    @param frequency
    @param specific_days
    @param repeat_end_date
    @param context_id
    @param package_id
} { 
    set event_start_date_list ""
    set event_end_date_list ""
    set frequency_type "weekly"
    ctrl_event::repetition::validation -frequency_type $frequency_type \
                                       -frequency $frequency \
	                               -specific_days_of_week $specific_days \
	                               -start_date $start_date \
		                       -end_date $end_date
    set fail_p [catch {

	set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 

	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	set original_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set list_length [llength $specific_days]
	set specific_day_index 0
	
	#find the date of the first day (sun) of the start date week
	set frequency_param -7
	set day_param "Sun"

	set new_start_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $frequency_param]
	set new_start_date [ctrl_event::date_util::get_new_weekday -date_param $new_start_date -day_param $day_param]

	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	#find the first repeating week day if it is later than Sunday
	if {[lindex $specific_days 0] != "Sun"} {
	    set day_param [lindex $specific_days 0]

	    set new_start_date [ctrl_event::date_util::get_new_weekday -date_param $new_start_date -day_param $day_param]
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	}
	
	set first_start_date $new_start_date
	set first_end_date $new_end_date

	set frequency_param [expr $frequency * 7]

	while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
	    if {[template::util::date::compare $new_start_date $original_start_date] != -1} {

		set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
		set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]
			
		lappend event_start_date_list $new_start_date_str
		lappend event_end_date_list $new_end_date_str
	    }
				    
	    incr specific_day_index

	    if {$specific_day_index>=$list_length} {			    
		set specific_day_index 0
		   
		#increment 			
	        set new_start_date [ctrl_event::date_util::get_new_day -date_param $first_start_date -frequency_param $frequency_param]
		set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	    	
	        set first_start_date $new_start_date
	        set first_end_date $new_end_date

	    } else {
		set day_param [lindex $specific_days $specific_day_index]

		set new_start_date [ctrl_event::date_util::get_new_weekday -date_param $new_start_date -day_param $day_param]
		set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	    }
	}
    } errmsg]	
	
    if {$fail_p != 0} {
	error $errmsg
    }

    return lappend event_start_date_list $event_end_date_list
}

ad_proc -public ctrl_event::repetition::date::monthly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required}
    {-title:required}
    {-start_date:required}
    {-end_date:required}
    {-all_day_p "f"}
    {-location:required}
    {-notes:required}
    {-capacity:required}
    {-event_image ""}
    {-event_image_caption ""}
    {-category_id:required}
    {-frequency:required}
    {-specific_day_frequency ""}
    {-specific_days ""}
    {-specific_dates_of_month ""}
    {-repeat_end_date:required}
    {-monthly_option: ""}
    {-context_id:required}
    {-package_id:required}
} {
    Adds recurring monthly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param start_date
    @param end_date
    @param all_day_p
    @param location
    @param notes
    @param capacity
    @param event_image
    @param event_image_caption
    @param category_id
    @param frequency
    @param specific_day_frequency
    @param specific_days
    @param specific_dates_of_month
    @param repeat_end_date
    @param monthly_option
    @param context_id
    @param package_id
} {
    set event_start_date_list ""
    set event_end_date_list ""

    set frequency_type "monthly"
    ctrl_event::repetition::validation -frequency_type $frequency_type \
                                       -frequency $frequency \
	                               -specific_days_of_week "" \
	                               -start_date $start_date \
		                       -end_date $end_date    
    set fail_p [catch {

	set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 
    
	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
			     
	if {$monthly_option=="1"} {
	    set frequency_param $frequency
	    #FORMAT START AND END DATE TO THE FORMAT OF REPEATING PATTERN
	    set new_start_date [ctrl_event::date_util::format_month -date_var $new_start_date \
	       		                                      -month_var "0" \
	       						      -day_var [format "%02d" $specific_dates_of_month]]			
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	    #INCREMENT 1 MONTH IF THE DATE OF THIS MONTH HAS PAST
	    if {[template::util::date::compare $new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]] == -1 } {
		set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
		set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	    }

	    while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
		set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
		set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]
			 			    
		lappend event_start_date_list $new_start_date_str
		lappend even_end_date_list $new_end_date_str

		# GETTING NEW START DATE BASED ON THE PREVIOUS START DATE (START DATE THAT WAS JUST INSERTED)
		set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
		#If parse and compare date.  If greater, replace (for dates 28, 29, 30, 31)
		if {[string range $new_start_date 8 10] > $specific_dates_of_month} {
		    set new_start_date "[string range $new_start_date 0 7][format "%02d" $specific_dates_of_month][string range $new_start_date 11 end]"
		}
	     
		# GETTING NEW END DATE BASED ON THE PREVIOUS END DATE (END DATE THAT WAS JUST INSERTED)
		set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	    }
       
	} elseif {$monthly_option=="2"} {
		#increment month by 1
		set frequency_param $frequency
		set day_param $specific_days

		if {$specific_day_frequency=="last"} {
		    set new_start_date [ctrl_event::date_util::get_last_weekday_of_month -date_param $new_start_date -day_param $day_param]
		    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
			
		    #INCREMENT 1 MONTH IF THE DATE OF THIS MONTH HAS PAST
		    if {($new_start_date < [ctrl_event::date_util::parse_date -date_var $start_date])} {
			set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
			set new_start_date [ctrl_event::date_util::get_last_weekday_of_month -day_param $new_start_date -frequency_param $frequency_param]

			set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
		    }
			
		    while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
			set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
			set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]

			lappend event_start_date_list $new_start_date_str
			lappend even_end_date_list $new_end_date_str			    

			set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
			set new_start_date [ctrl_event::date_util::get_last_weekday_of_month -date_param $new_start_date -day_param $day_param]
			set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
		    }
		    
		} else {

		    switch $specific_day_frequency {
			"first" {
			    set frequency_param 0
			}
		        "second" {
			    set frequency_param 7
			}
			"third" {
			    set frequency_param 14
			}
			"fourth" {
			    set frequency_param 21
			}
		    }

		    #Get starting and ending date for the month the event is starting			
		    set new_start_date [ctrl_event::repetition::get_new_monthly_repeat_option2 -date_param $new_start_date \
		        	                                                          -frequency_param $frequency_param \
											  -day_param $day_param \
											  -month_incr_p "f"]
		    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

		    #INCREMENT 1 MONTH IF THE DATE OF THIS MONTH HAS PAST
		    if {($new_start_date < [ctrl_event::date_util::parse_date -date_var $start_date])} {
			set new_start_date [ctrl_event::repetition::get_new_monthly_repeat_option2 -date_param $new_start_date \
				                                                              -frequency_param $frequency_param \
											      -day_param $day_param \
											      -month_incr_p "t"]
			set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
		    }

		    while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
			set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
			set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]			    

			lappend event_start_date_list $new_start_date_str
			lappend event_end_date_list $new_end_date_str

			set new_start_date [ctrl_event::repetition::get_new_monthly_repeat_option2 -date_param $new_start_date \
				                                                                  -frequency_param $frequency_param \
												  -day_param $day_param \
												  -month_incr_p "t"]		
			set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
		    }
		}
	    }
    } errmsg]	
	
    if {$fail_p != 0} {
	error $errmsg
    }

    return $event_id_list
}

ad_proc -public ctrl_event::repetition::yearly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-start_date:required} 
    {-end_date:required} 
    {-all_day_p "f"} 
    {-location:required} 
    {-notes:required} 
    {-capacity:required}
    {-event_image ""}
    {-event_image_caption ""}
    {-category_id:required}
    {-frequency:required}
    {-specific_dates_of_month ""}
    {-specific_months ""}
    {-repeat_end_date:required}
    {-monthly_option: ""}
    {-context_id:required}
    {-package_id:required}
} {
    Adds recurring yearly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param start_date
    @param end_date
    @param all_day_p
    @param location
    @param notes
    @param capacity
    @param event_image
    @param event_image_caption
    @param category_id
    @param frequency
    @param specific_dates_of_month
    @param specific_months
    @param repeat_end_date
    @param monthly_option
    @param context_id
    @param package_id
} {
    set event_start_date_list ""
    set event_end_date_list ""

    set frequency_type "yearly"
    ctrl_event::repetition::validation -frequency_type "yearly" \
                                       -frequency $frequency \
	                               -specific_days_of_week "" \
	                               -start_date $start_date \
		                       -end_date $end_date
    set fail_p [catch {
	
        set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 
	
	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	
	set frequency_param [expr $frequency * 12]
	
	set new_start_date [ctrl_event::date_util::format_month -date_var $new_start_date \
				                                -month_var [format "%02d" $specific_months] \
				                                -day_var [format "%02d" $specific_dates_of_month]]	
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

       	#INCREMENT 1 MONTH IF THE DATE OF THIS MONTH HAS PAST
       	if {$new_start_date < [ctrl_event::date_util::parse_date -date_var $start_date]} {
	    set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
       	}
	
	while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 
	    set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
	    set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]

	    lappend event_start_date_list $new_start_date_str
	    lappend event_end_date_list $new_end_date_str

	    set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	}
    } errmsg]	
	
    if {$fail_p != 0} {
	error $errmsg
    }

    return lappend event_start_date_list $event_end_date_list
}
