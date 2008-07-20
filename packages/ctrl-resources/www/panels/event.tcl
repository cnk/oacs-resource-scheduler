
# -------------
# Parameters
# --------------
if { [template::util::is_nil request_id] } {
    set request_id ""
}

# --------------
# Initialize the list option list for selects and radios
# ---------------
set yes_no_options [list [list "No" 0] [list "Yes" 1] ]
set resource_type_options [list [list "Select One ..." -1]]
set resource_type_options [concat $resource_type_options [db_list_of_lists get_type_options {}]]
set js_code [crs::util::build_branch_js]

set today_date [ctrl_event::date_util::format_hour -date_var [ctrl_event::date_util::todays_date]]
set today_date_end [ctrl_event::date_util::format_hour -date_var [ctrl_event::date_util::get_new_day_median_format -date_param $today_date -frequency_param "0.04167"]]
set object_types [db_list_of_lists get_object_types {}]

# SET UP EVENT FORM ################################################################################################################################################

ad_form -name "add_edit_event" -method post -form {
    event_id:key
    {request_id:text(hidden) {value $request_id}}
    {title:text(text) {label "Event Title: "}}
    {resource_type:text(select) {label {Resource Type}} {options $resource_type_options}}
    {resource:text(select) {label {Request Resource Type}} {options {}} }
    {event_object_id:text(select) {label "Event Object: "} {options {$object_types}} }
    {start_date:date,to_sql(sql_date),from_sql(sql_date) {label "Start Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help} {value $today_date}}
    {end_date:date,to_sql(sql_date),from_sql(sql_date) {label "End Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help} {value $today_date_end}}
    {all_day_p:boolean(checkbox),optional {label "All Day Event: "} {options {{"" t}} {value $all_day_p}} {after_html "(If selected, time will not be used.)"}}
    {location:text(textarea) {label "Location: "} {html {cols 40}}}
    {notes:text(textarea) {label "Notes: "} {html {rows 6 cols 40}} {optional}}
    {capacity:integer(text) {label "Capacity: "} {html {size 5}} {optional}}
    {event_image:text(file),optional {label "Upload Event Image:"}}
    {repeat_template_p:boolean(checkbox),optional {label "Repeating Event: "} {options {{"" t}} {value $repeat_template_p}}}
    {specific_days_week:text(checkbox),multiple {label "Days"} \
	 {options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
    {specific_days_month:text(select) {label "Days"} \
	 {options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
    {frequency_type:text(radio) {label ""} {options {{"Daily" daily} {"Weekly" weekly} {"Monthly" monthly} {"Yearly" yearly}}} {optional}}
    {frequency_day:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_week:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_month:integer(text) {label "Frequency: "} {html {size 2}} {optional}}
    {frequency_year:integer(text) {label "Frequency: "} {html {size 2}} {value {1}} {hidden} {optional}}
    {specific_day_frequency:text(select) {label ""} {options {{"first" first} {"second" second} {"third" third} {"fourth" fourth} {"last" last}}} {optional}}
    {specific_dates_of_month_month:integer(text) {label ""} {html {size 2}} {optional}}
    {specific_dates_of_month_year:integer(text) {label ""} {html {size 2}} {optional}}
    {specific_months:text(select) {label ""} {options {{"" ""} {"January" 1} {"February" 2} {"March" 3} \
	                                               {"April" 4} {"May" 5} {"June" 6} \
						       {"July" 7} {"August" 8} {"September" 9} \
						       {"October" 10} {"November" 11} {"December" 12}}} {optional}}
    {repeat_month_opt1:text(radio) {label ""} {options {{"Day" 1}}} {optional}}
    {repeat_month_opt2:text(radio) {label ""} {options {{"The" 1}}} {optional}}
    {repeat_end_date_opt:text(radio) {label "End Date: "} {options {{"No End Date" 0} {"Until" 1}}} {value {0}}}
    {repeat_end_date:date,to_sql(sql_date) {label ""} {format "YYYY/MM/DD"} {help} {value $today_date} {optional}}
    {submit:text(submit) {label "Submit"}}
} -validate {
    {
	end_date
	{[template::util::date::compare $end_date $start_date] > 0}
	"End date must be after the start date"
    }
} -on_request {
    if [info exists event_id] {
	if {![event::exists_p -event_id $event_id]} {
	    ad_return_error "Error" "An invalid event_id has been passed to this page. Please contact 
			the system administrator at <a href=\"mailto:[ad_host_administrator]\">[ad_host_administrator]</a>
			if you have any questions. Thank you."
	    ad_script_abort
	}
    }
} -on_submit {

    if {[empty_string_p $repeat_template_p]} {
	set repeat_template_p "f"
    }

    if {[empty_string_p $all_day_p]} {
	set all_day_p "f"
    }

} -new_data {

    # HANDLING NEW EVENT DATA ################################################################################################################################

    set repeat_template_id ""
    set monthly_option ""
    set invalid_recurrence_msg "The recurrence pattern is not valid"

    set fail_p [catch {
	# INSERT NEW EVENT ###################################################################################################################################
	set event_id [event::new -event_id $event_id \
		                 -event_object_id $event_object_id \
				 -repeat_template_id $repeat_template_id \
				 -repeat_template_p $repeat_template_p \
				 -title $title \
				 -start_date $start_date \
				 -end_date $end_date \
				 -all_day_p $all_day_p \
				 -location $location \
				 -notes $notes \
				 -capacity $capacity\
				 -event_image $event_image]    

	# END INSERTING NEW EVENT


	# CHECK IF EVENT IS REPEATING - CALL PROCEDURE TO INSERT REPEATING EVENTS IF IT IS
	if {$repeat_template_p == "t"} {
	
	    #set repeating_events_inserted_p 
	 
	    switch $frequency_type {
		"daily" {

		    set frequency $frequency_day
		    set specific_day_frequency "first"
		    set specific_days "M"
		    set specific_dates_of_month ""
		    set specific_months ""
		
		    if {[empty_string_p $frequency]} {
			ad_return_complaint 1 $invalid_recurrence_msg
			ad_script_abort
		    }
		
		}
		
		"weekly" {

		    set frequency $frequency_week
		    set specific_day_frequency "first"
		    set specific_days_list [join $specific_days_week ","]
		    set specific_days $specific_days_week
		    set specific_dates_of_month ""
		    set specific_months ""

		    if {[empty_string_p $frequency] || [empty_string_p $specific_days]} {
			ad_return_complaint 1 $invalid_recurrence_msg
			ad_script_abort
		    }

		}
		"monthly" {
	    				
		    if {$repeat_month_opt1 == "1"} {

			set monthly_option "1"
			set frequency $frequency_month
			set specific_dates_of_month $specific_dates_of_month_month
			set specific_day_frequency ""
			set specific_days ""
			set specific_months ""
			
			if {[empty_string_p $frequency] || [empty_string_p $specific_dates_of_month]} {
			    ad_return_complaint 1 $invalid_recurrence_msg
			    ad_script_abort
			}

		    } elseif {$repeat_month_opt2 == "1"} {

			set monthly_option "2"
			set frequency "1"
			set specific_days $specific_days_month
			set specific_dates_of_month ""
			set specific_months ""
			
			if {[empty_string_p specific_days_month]} {
			    ad_return_complaint 1 $invalid_recurrence_msg
			    ad_script_abort
			}
		    
		    } else {
			ad_return_complaint 1 $invalid_recurrence_msg
			ad_script_abort
		    }
	    
		} 
		"yearly" {

		    set frequency $frequency_year		
		    set specific_day_frequency ""
		    set specific_days ""
		    set specific_dates_of_month $specific_dates_of_month_year
		    
		    if {[empty_string_p $specific_months] || [empty_string_p $specific_dates_of_month]} {
			ad_return_complaint 1 $invalid_recurrence_msg
			ad_script_abort
		    }
		}
	   
		default {
		    ad_return_complaint 1 $invalid_recurrence_msg
		    ad_script_abort
		}
	    }	
	
	    if {$repeat_end_date_opt=="0"} {
		set repeat_end_date_str [ctrl_event::date_util::parse_date -date_var $repeat_end_date]
		set repeat_end_date [string range [db_string get_repeat_end_date {}] 0 15]
		set repeat_end_date "to_date('$repeat_end_date', 'YYYY MM DD HH24 MI')"
	    }

	    # ADDING REPEATING EVENTS 

	    #add repeating pattern in repeating_events
	    event_repetitions::pattern_add -repeat_template_id $event_id \
		                           -frequency_type $frequency_type \
					   -frequency $frequency \
					   -specific_day_frequency $specific_day_frequency \
					   -specific_days $specific_days \
					   -specific_dates_of_month $specific_dates_of_month \
					   -specific_months $specific_months\
					   -end_date $repeat_end_date

	    #add all occurences to the event
	    event_repetitions::repeating_events_add -event_id "" \
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
						    -frequency_type $frequency_type \
						    -frequency $frequency \
						    -specific_day_frequency $specific_day_frequency \
						    -specific_days $specific_days \
						    -specific_dates_of_month $specific_dates_of_month \
						    -specific_months $specific_months \
						    -repeat_end_date $repeat_end_date \
						    -monthly_option $monthly_option
	    # FINISHED ADDING REPEATING EVENTS
	}   
    } errmsg] 

    if {$fail_p != 0} {
	ad_return_error "Fail" $errmsg
	return
    }   

} -after_submit {

    ad_returnredirect "/events/"

} -edit_data {

    set fail_p [catch {
    event::update -event_id $event_id \
	          -event_object_id $event_object_id \
		  -repeat_template_p $repeat_template_p \
		  -title $title \
		  -start_date $start_date \
		  -end_date $end_date \
		  -all_day_p $all_day_p \
		  -location $location \
		  -notes $notes \
		  -capacity $capacity
    } errmsg]

    if {$fail_p != 0} {
	ad_return_error "Fail" $errmsg
	return
    }

} -select_query_name get_event_data 

# END SET UP EVENT FORM ############################################################################################################################################

