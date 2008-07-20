ad_library {
    General procedures for repetition events: add repeating pattern and add recurrent events
    @creation-date 06/21/05
    @cvs_id $id$
}

namespace eval ctrl_event::repetition {}

ad_proc -public ctrl_event::repetition::get {
	{-array:required}
	{-repeat_template_id:required}
} {
	Select something from the database

	@param array
	@param event_id
} {
	upvar $array local_array
	set selection [db_0or1row get {} -column_array local_array]
	if {!$selection} {
	    return 0
	} else {
	    return 1
	}
}

ad_proc -public ctrl_event::repetition::repeat {
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
    {-speakers ""}
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
    -add_event_p:required
} {
    Proc which encapsulates the repetition of an event
    Returns a list of event_id that was added (08/28/2006)
} {

    set fail_p [catch {

	set event_date_list ""
	set invalid_recurrence_msg "The recurrence pattern you entered is not valid."
	switch $frequency_type {
	    "daily" {
		if {$repeat_end_date_opt=="0"} {
		    set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
		}
		
		if {[empty_string_p $frequency_day]} {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}
	
		set event_date_list [ctrl_event::repetition::daily -event_id $event_id \
					 -event_object_id $event_object_id \
					 -repeat_template_id $event_id \
					 -repeat_template_p "f" \
					 -title $title \
					 -speakers $speakers \
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
					 -package_id $package_id \
					 -add_event_p $add_event_p]
	    }
	    
	    "weekly" {
		
		if {$repeat_end_date_opt=="0"} {
		    set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
		}
	
        
		if {[empty_string_p $frequency_week] || [empty_string_p $specific_days_week]} {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}

		set event_date_list [ctrl_event::repetition::weekly -event_id $event_id \
					 -event_object_id $event_object_id \
					 -repeat_template_id $event_id \
					 -repeat_template_p "f" \
					 -title $title \
					 -speakers $speakers \
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
					 -package_id $package_id \
					 -add_event_p $add_event_p]
	    }
	    
	    "monthly" {
		if {$repeat_end_date_opt=="0"} {
		    set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
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
		
		set event_date_list [ctrl_event::repetition::monthly -event_id $event_id \
					 -event_object_id $event_object_id \
					 -repeat_template_id $event_id \
					 -repeat_template_p "f" \
					 -title $title \
					 -speakers $speakers \
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
					 -package_id $package_id \
					 -add_event_p $add_event_p]
	    }
	    
	    "yearly" {
		if {$repeat_end_date_opt=="0"} {
		    set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 24 -repeat_end_date_var $repeat_end_date]
		}
		
		if {[empty_string_p $specific_months] || [empty_string_p $specific_dates_of_month_year]} {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}
		
		if {[empty_string_p $frequency_year]} {
		    set frequency_year 1
		}
		
		set event_date_list [ctrl_event::repetition::yearly -event_id $event_id \
					 -event_object_id $event_object_id \
					 -repeat_template_id $event_id \
					 -repeat_template_p "f" \
					 -title $title \
					 -speakers $speakers \
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
					 -package_id $package_id \
					 -add_event_p $add_event_p]
	    }
	    
	    default {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
	}
	
    } errmsg]

    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
	ad_script_abort
    }
    
    return $event_date_list
}


ad_proc -public ctrl_event::repetition::pattern_add {
    {-repeat_template_id:required}
    {-frequency_type:required}
    {-frequency:required}
    {-specific_day_frequency ""}
    {-specific_days ""}
    {-specific_dates_of_month ""}
    {-specific_months ""}
    {-end_date ""}
} {
    Adding a repetition pattern into ctrl_events_repetitions
    @param repeat_template_id
    @param frequency_type
    @param frequency
    @param specific_day_frequency
    @param specific_days
    @param specific_dates_of_month
    @param specific_months 
    @param end_date 
} {
    set error_p 0
    db_transaction {
	#add template if it doesn't exist
	if {![ctrl_event::repetition::get -repeat_template_id $repeat_template_id -array "dummy"]} {
	    db_dml add_repetition_template {}
	}
    } on_error {
	set error_p 1
    }
    
    if {$error_p} {
	error $errmsg
    }
}

ad_proc -public ctrl_event::repetition::pattern_add_from_form_widgets {
    {-repeat_template_id:required}
    {-frequency_type:required}
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
    {-repeat_end_date_opt ""}
    {-repeat_end_date ""}
} {
    Adding a repetition pattern into ctrl_events_repetitions take all parameters from form and select values based on repeating pattern
} {
    set invalid_recurrence_msg "The recurrence pattern you entered is not valid."

    switch $frequency_type {
	"daily" {
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $frequency_day]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }

	    ctrl_event::repetition::pattern_add -repeat_template_id $repeat_template_id \
		-frequency_type $frequency_type \
		-frequency $frequency_day \
		-specific_day_frequency "first" \
		-specific_days "M" \
                -specific_dates_of_month "" \
                -specific_months "" \
		-end_date $repeat_end_date
	}
	
	"weekly" {

	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $frequency_week] || [empty_string_p $specific_days_week]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }

	    ctrl_event::repetition::pattern_add -repeat_template_id $repeat_template_id \
		-frequency_type $frequency_type \
		-frequency $frequency_week \
		-specific_day_frequency "first" \
		-specific_days [join $specific_days_week ","] \
		-specific_dates_of_month "" \
                -specific_months "" \
		-end_date $repeat_end_date
	}
	
	"monthly" {
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 12 -repeat_end_date_var $repeat_end_date]
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
	    
	    ctrl_event::repetition::pattern_add -repeat_template_id $repeat_template_id \
		-frequency $frequency \
		-frequency_type $frequency_type \
		-specific_day_frequency $specific_day_frequency \
		-specific_days $specific_days \
		-specific_dates_of_month $specific_dates_of_month \
		-specific_months $specific_months \
		-end_date $repeat_end_date

	}
	
	"yearly" {
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date [ctrl_event::repetition::get_repeat_end_date -repeat_duration 60 -repeat_end_date_var $repeat_end_date]
	    }
	    
	    if {[empty_string_p $specific_months] || [empty_string_p $specific_dates_of_month_year]} {
		ad_return_complaint 1 $invalid_recurrence_msg
		ad_script_abort
	    }
	    
	    if {[empty_string_p $frequency_year]} {
		set frequency_year 1
	    }
	    
	    ctrl_event::repetition::pattern_add -repeat_template_id $repeat_template_id \
		-frequency_type $frequency_type \
		-frequency $frequency_year \
		-specific_dates_of_month $specific_dates_of_month_year \
		-specific_months $specific_months \
		-end_date $repeat_end_date
	}
	
	default {
	    ad_return_complaint 1 $invalid_recurrence_msg
	    ad_script_abort
	}
    }
}

ad_proc -public ctrl_event::repetition::daily {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-speakers ""}
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
    {-add_event_p:required}
} {
    Adds recurring daily events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param speakers
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
    set start_date_list ""
    set end_date_list ""

    set frequency_type "daily"

    set fail_p [catch {
	ctrl_event::repetition::validation -frequency_type $frequency_type \
	    -frequency $frequency \
	    -specific_days_of_week "" \
	    -start_date $start_date \
	    -end_date $end_date

	if {$add_event_p=="t"} {
	    ctrl_event::repetition::pattern_add -repeat_template_id $event_id \
		-frequency_type $frequency_type \
		-frequency $frequency \
		-specific_day_frequency "first" \
		-specific_days "M" \
		-specific_dates_of_month "" \
		-specific_months "" \
		-end_date $repeat_end_date
	}

	set frequency_param $frequency	

	set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 

	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	while {[template::util::date::compare $new_start_date $repeat_end_date] != 1} { 

	    set new_start_date_str [ctrl_event::date_util::format_date -date_var $new_start_date]
	    set new_end_date_str [ctrl_event::date_util::format_date -date_var $new_end_date]

	    lappend start_date_list $new_start_date_str
	    lappend end_date_list $new_end_date_str

	    if {$add_event_p=="t"} {
		set event_id [ctrl_event::new -event_id $event_id \
				  -event_object_id $event_object_id \
				  -repeat_template_id $repeat_template_id \
				  -repeat_template_p $repeat_template_p \
				  -title $title \
				  -speakers $speakers \
				  -start_date $new_start_date_str \
				  -end_date $new_end_date_str \
				  -all_day_p $all_day_p \
				  -location $location \
				  -notes $notes \
				  -capacity $capacity \
				  -event_image $event_image \
				  -event_image_caption $event_image_caption \
				  -category_id $category_id \
				  -context_id $context_id \
				  -package_id $package_id]       
	    }
		

	    # GETTING NEW START DATE BASED ON THE PREVIOUS START DATE (START DATE THAT WAS JUST INSERTED)
	    set new_start_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $frequency]	
	    # GETTING NEW END DATE BASED ON THE PREVIOUS END DATE (END DATE THAT WAS JUST INSERTED)
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	}
    } errmsg]
	
    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
	return
    }
    return [concat [list $start_date_list] [list $end_date_list]]
}

ad_proc -public ctrl_event::repetition::weekly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-speakers ""}
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
    {-add_event_p:required}
} {
    Adds recurring weekly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param speakers 
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
    set start_date_list ""
    set end_date_list ""
    set frequency_type "weekly"
    ctrl_event::repetition::validation -frequency_type $frequency_type \
                                       -frequency $frequency \
	                               -specific_days_of_week $specific_days \
	                               -start_date $start_date \
		                       -end_date $end_date
    set fail_p [catch {

	if {$add_event_p=="t"} {
	    ctrl_event::repetition::pattern_add -repeat_template_id $event_id \
		-frequency_type $frequency_type \
		-frequency $frequency \
		-specific_day_frequency "first" \
		-specific_days [join $specific_days ","] \
		-specific_dates_of_month "" \
		-specific_months "" \
		-end_date $repeat_end_date
	}

	set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date] 

	set new_start_date [ctrl_event::date_util::parse_date -date_var $start_date]
	set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]

	set original_start_date [ctrl_event::date_util::parse_date -date_var $start_date]

	#set specific_days [split $specific_days ","]
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

		lappend start_date_list $new_start_date_str
		lappend end_date_list $new_end_date_str

		if {$add_event_p=="t"} {		
		    set event_id [ctrl_event::new -event_id $event_id \
				      -event_object_id $event_object_id \
				      -repeat_template_id $repeat_template_id \
				      -repeat_template_p $repeat_template_p \
				      -title $title \
				      -speakers $speakers \
				      -start_date $new_start_date_str \
				      -end_date $new_end_date_str \
				      -location $location \
				      -notes $notes \
				      -capacity $capacity \
				      -event_image $event_image \
				      -event_image_caption $event_image_caption \
				      -category_id $category_id \
				      -context_id $context_id \
				      -package_id $package_id]
		}
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
    return [concat [list $start_date_list] [list $end_date_list]]
}

ad_proc -public ctrl_event::repetition::monthly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required}
    {-title:required}
    {-speakers ""}
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
    {-add_event_p:required}
} {
    Adds recurring monthly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param speakers
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
    set start_date_list ""
    set end_date_list ""
    set frequency_type "monthly"
    ctrl_event::repetition::validation -frequency_type $frequency_type \
                                       -frequency $frequency \
	                               -specific_days_of_week "" \
	                               -start_date $start_date \
		                       -end_date $end_date    
    set fail_p [catch {
	if {$add_event_p=="t"} {
	    ctrl_event::repetition::pattern_add -repeat_template_id $event_id \
                -frequency_type $frequency_type \
                -frequency $frequency \
                -specific_day_frequency $specific_day_frequency \
                -specific_days $specific_days \
                -specific_dates_of_month $specific_dates_of_month \
                -specific_months "" \
                -end_date $repeat_end_date
	}

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
			
		lappend start_date_list $new_start_date_str
		lappend end_date_list $new_end_date_str 	

		if {$add_event_p=="t"} {		    
		    set event_id [ctrl_event::new -event_id $event_id \
				      -event_object_id $event_object_id \
				      -repeat_template_id $repeat_template_id \
				      -repeat_template_p $repeat_template_p \
				      -title $title \
				      -speakers $speakers \
				      -start_date $new_start_date_str \
				      -end_date $new_end_date_str \
				      -location $location \
				      -notes $notes \
				      -capacity $capacity \
				      -event_image $event_image \
				      -event_image_caption $event_image_caption \
				      -category_id $category_id \
				      -context_id $context_id \
				      -package_id $package_id]
		}

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
			    
			lappend start_date_list $new_start_date_str
			lappend end_date_list $new_end_date_str

			if {$add_event_p=="t"} {
			    set event_id [ctrl_event::new -event_id $event_id \
					      -event_object_id $event_object_id \
					      -repeat_template_id $repeat_template_id \
					      -repeat_template_p $repeat_template_p \
					      -title $title \
					      -speakers $speakers \
					      -start_date $new_start_date_str \
					      -end_date $new_end_date_str \
					      -location $location \
					      -notes $notes \
					      -capacity $capacity \
					      -event_image $event_image \
					      -event_image_caption $event_image_caption \
					      -category_id $category_id \
					      -context_id $context_id \
					      -package_id $package_id]
			}
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

			lappend start_date_list $new_start_date_str
			lappend end_date_list $new_end_date_str

			if {$add_event_p=="t"} {
			    set event_id [ctrl_event::new -event_id $event_id \
					      -event_object_id $event_object_id \
					      -repeat_template_id $repeat_template_id \
					      -repeat_template_p $repeat_template_p \
					      -title $title \
					      -speakers $speakers \
					      -start_date $new_start_date_str \
					      -end_date $new_end_date_str \
					      -location $location \
					      -notes $notes \
					      -capacity $capacity \
					      -event_image $event_image \
					      -event_image_caption $event_image_caption \
					      -category_id $category_id \
					      -context_id $context_id \
					      -package_id $package_id]
			}
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

    return [concat [list $start_date_list] [list $end_date_list]]
}

ad_proc -public ctrl_event::repetition::yearly {
    {-event_id:required}
    {-event_object_id:required}
    {-repeat_template_id:required}
    {-repeat_template_p:required} 
    {-title:required}
    {-speakers ""}
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
    {-add_event_p:required}
} {
    Adds recurring yearly events based on the repetition template
    @param event_id
    @param event_object_id
    @param repeat_template_id
    @param repeat_template_p
    @param title
    @param speakers 
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
    set start_date_list ""
    set end_date_list ""
    set frequency_type "yearly"
    ctrl_event::repetition::validation -frequency_type "yearly" \
                                       -frequency $frequency \
	                               -specific_days_of_week "" \
	                               -start_date $start_date \
		                       -end_date $end_date
    set fail_p [catch {

	if {$add_event_p=="t"} {
	    ctrl_event::repetition::pattern_add -repeat_template_id $event_id \
		-frequency_type $frequency_type \
		-frequency $frequency \
		-specific_day_frequency "" \
		-specific_days "" \
		-specific_dates_of_month $specific_dates_of_month \
		-specific_months $specific_months \
		-end_date $repeat_end_date
	}
	
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
		    
	    lappend start_date_list $new_start_date_str
	    lappend end_date_list $new_end_date_str

	    if {$add_event_p=="t"} {
		set event_id [ctrl_event::new -event_id $event_id \
				  -event_object_id $event_object_id \
				  -repeat_template_id $repeat_template_id \
				  -repeat_template_p $repeat_template_p \
				  -title $title \
				  -speakers $speakers \
				  -start_date $new_start_date_str \
				  -end_date $new_end_date_str \
				  -location $location \
				  -notes $notes \
				  -capacity $capacity \
				  -event_image $event_image \
				  -event_image_caption $event_image_caption \
				  -category_id $category_id \
				  -context_id $context_id \
				  -package_id $package_id]
	    }

	    set new_start_date [ctrl_event::date_util::get_new_month -date_param $new_start_date -frequency_param $frequency_param]
	    set new_end_date [ctrl_event::date_util::get_new_day -date_param $new_start_date -frequency_param $event_duration]
	}
    } errmsg]	
	
    if {$fail_p != 0} {
	error $errmsg
    }
   
    return [concat [list $start_date_list] [list $end_date_list]]
}


ad_proc -public ctrl_event::repetition::get_new_monthly_repeat_option2 {
    {-date_param:required} 
    {-frequency_param:required}
    {-day_param:required}
    {-month_incr_p:required}
} {
    @param date_param
    @param frequency_param
    @param day_param
    @param month_incr
} {
    set fail_p [catch {

	set date_str $date_param

	if {$month_incr_p=="t"} {
	    set date_str [ctrl_event::date_util::get_new_month -date_param $date_param -frequency_param 1]
	}

	set date_str [ctrl_event::date_util::get_previous_last_day -date_param $date_str]

	set date_str [ctrl_event::date_util::get_new_weekday -date_param $date_str -day_param $day_param]
	set date_str [ctrl_event::date_util::get_new_day -date_param $date_str -frequency_param $frequency_param]
    } errmsg]

    if {$fail_p != 0} {
	error $errmsg
    }

    return $date_str
}

ad_proc -public ctrl_event::repetition::validation {
    {-frequency_type:required}
    {-frequency:required}
    {-specific_days_of_week:required}    
    {-start_date:required}
    {-end_date:required}
} {
    @param frequency_type frequency type
    @param frequency frequency
    @param specific_days_of_week Sun to Mon
    @param start_date
    @param end_date
} {
    set fail_p [catch {

	#set repeat_end_date "[ctrl_event::date_util::parse_date -date_var $repeat_end_date] 23 59"
	set event_duration [ctrl_event::date_util::get_event_duration -start_date $start_date -end_date $end_date]
	
	switch $frequency_type {
	    
	    "daily" {
		set validation_duration $frequency
	    } 
	    
	    "weekly" {
		set number_of_weekdays [llength $specific_days_of_week]
		
		#same as daily repeating with a frequency of 7
		if {$number_of_weekdays == "1"} {
		    
		    set validation_duration [expr $frequency * 7]

		} else {	
		    #initial variables
		    set i 0
		    
		    set diff [expr [ctrl_event::repetition::weekday_index -weekday [lindex $specific_days_of_week 0]] \
				  - [ctrl_event::repetition::weekday_index -weekday \
					 [lindex $specific_days_of_week [expr $number_of_weekdays - 1]]] + 7]
		    
		    while {$i < [expr $number_of_weekdays - 2]} {
			if {$diff > [expr [ctrl_event::repetition::weekday_index -weekday [lindex $specific_days_of_week [expr $i + 1]]] \
					 - [ctrl_event::repetition::weekday_index -weekday [lindex $specific_days_of_week $i]]]} {
			    set diff [expr [ctrl_event::repetition::weekday_index -weekday [lindex $specific_days_of_week [expr $i + 1]]] \
					  - [ctrl_event::repetition::weekday_index -weekday [lindex $specific_days_of_week $i]]]
			}
			incr i
		    }
		    set validation_duration $diff
		}
	    }

	    "monthly" {
		set validation_duration [expr $frequency * 29]
	    }
	    
	    "yearly" {
		set validation_duration [expr $frequency * 365]
	    }
	}

	if {$event_duration >= $validation_duration} {
	    ad_return_complaint 1 "The duration of event must be shorter than how frequently it occurs"
	    ad_script_abort
	    set validation_flag 1
	}
    } errmsg]

    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
	ad_script_abort
    }
}

ad_proc -public ctrl_event::repetition::weekday_index {
    {-weekday:required}
} {
    @param weekday
} {    
    switch [string toupper $weekday] {
	"SUN" {
	    set weekday_index 0
	}
	"MON" {
	    set weekday_index 1
	} 
	"TUE" {
	    set weekday_index 2
	} 
	"WED" {
	    set weekday_index 3
	} 
	"THU" {
	    set weekday_index 4
	} 
	"FRI" {
	    set weekday_index 5
	} 
	"SAT" {
	    set weekday_index 6
	} 
    }

    return $weekday_index
}

ad_proc -public ctrl_event::repetition::today_day_in_string {
    {-date_param:required}
} {
    @param date_param
} {
    set today_string [db_string get_day {}]
    return $today_string
}

ad_proc -public ctrl_event::repetition::get_repeat_end_date {
    {-repeat_duration:required}
    {-repeat_end_date_var}
} {
    @param repeat_duration
} {
    set repeat_end_date_str [ctrl_event::date_util::parse_date -date_var $repeat_end_date_var]
    set repeat_end_date [string range [db_string get_repeat_end_date {}] 0 9]
    set repeat_end_date "to_date('$repeat_end_date', 'YYYY MM DD')"

    return $repeat_end_date
}

ad_proc -public ctrl_event::repetition::get_month_opt {
    {-specific_day_frequency ""}
    {-specific_days ""}
    {-specific_dates_of_month ""}
    {-specific_months}
} {
    
} {
    set opt 0

    if {![empty_string_p $specific_dates_of_month] && ![empty_string_p specific_months]} {
	set opt 1
    }

    if {![empty_string_p $specific_day_frequency] && ![empty_string_p $specific_days]} {
	set opt 2
    }
    
    return $opt
}
