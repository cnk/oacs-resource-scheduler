# /packages/ctrl-events/www/admin/event-ae.tcl				-*- tab-width: 4 -*-
ad_page_contract {

	This page allows you to add or edit an event into the CTRL Events Database

	@author:		Kellie@ctrl.ucla.edu
	@creation-date:	05/06/2005
	@cvs-id			$Id: event-ae.tcl,v 1.2 2006/08/08 00:53:53 avni Exp $
} {
	{event_id:optional,naturalnum}
	{delete_all_future_image:optional}
}

set user_id [ad_maybe_redirect_for_registration]
set ip_address [ns_conn peeraddr]
set subsite_url [site_node_closest_ancestor_package_url]
set package_url [ad_conn package_url]

if {[ad_form_new_p -key event_id]} {
	set current_image ""
	set event_template_p ""
	set page_title "Add Event"
	set edit_p 0
} else {
	set current_image  [ctrl_event::event_image_display -event_id $event_id]
	if {[empty_string_p [string trim $current_image]]} {
		set current_image "<i>n/a</i>"
		set delete_image_link ""
	} else {
		set delete_image_link "<a href=photo-delete?[export_vars event_id]>Remove this Image</a>"
	}
	set page_title "Edit Event"
	set edit_p 1
}

set context_id [ad_conn package_id]
set package_id [ad_conn package_id]

set category_options " {} [ctrl_event::category::option_list -path "" -package_id $package_id]"

set today_date [db_string today_date {}]
set today_date_end [db_string today_date_end {}]

# SET UP EVENT FORM #########################################################################################################################
ad_form -name "add_edit_event" -method post -html {enctype multipart/form-data} -form {
	event_id:key
	{event_object_id:text(hidden) {value -1}}
	{title:text(text)                                      {label "Event Title: "} {html {size 60}}}
	{category_id:integer(select),optional                  {label "Category: "} {options $category_options}}
	{start_date:date,to_sql(sql_date),from_sql(sql_date)   {label "Start Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help} {value $today_date}}
	{end_date:date,to_sql(sql_date),from_sql(sql_date)     {label "End Date: "} {format "YYYY/MM/DD HH12:MI AM"} {help} {value $today_date_end}}
	{all_day_p:boolean(checkbox),optional                  {label "All Day Event: "} {options {{"" t}} {value $all_day_p}} {after_html "(If selected, time will not be used.)"}}
	{location:text(textarea),optional                      {label "Location: "} {html {cols 40}}}
	{notes:text(textarea)                                  {label "Description: "} {html {rows 6 cols 40}} {optional}}
	{capacity:integer(text)                                {label "Capacity: "} {html {size 5}} {optional}}
	{current_image:text(inform)                            {label "Current Image: "} {value $current_image}}
	{event_image:text(file),optional                       {label "Upload Event Image:"}}
	{event_image_caption:text(textarea)                    {label "Event Caption: "} {html {rows 4 cols 40}} {optional}}
	{repeat_template_p:boolean(checkbox),optional          {label "Repeating Event: "} {options {{"" t}} {value $repeat_template_p}}}
	{specific_days_week:text(checkbox),multiple            {label "Days"} \
			{options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
	{specific_days_month:text(select)                      {label "Days"} \
			{options {{"Sunday" Sun} {"Monday" Mon} {"Tuesday" Tue} {"Wednesday" Wed} {"Thursday" Thu} {"Friday" Fri} {"Saturday" Sat}}} {optional}}
	{frequency_type:text(radio)                            {label ""} {options {{"Daily" daily} {"Weekly" weekly} {"Monthly" monthly} {"Yearly" yearly}}} {optional}}
	{frequency_day:integer(text)                           {label "Frequency: "} {html {size 2}} {optional}}
	{frequency_week:integer(text)                          {label "Frequency: "} {html {size 2}} {optional}}
	{frequency_month:integer(text)                         {label "Frequency: "} {html {size 2}} {optional}}
	{frequency_year:integer(text)                          {label "Frequency: "} {html {size 2}} {value {1}} {hidden} {optional}}
	{specific_day_frequency:text(select)                   {label ""} {options {{"first" first} {"second" second} {"third" third} {"fourth" fourth} {"last" last}}} {optional}}
	{specific_dates_of_month_month:integer(text)           {label ""} {html {size 2}} {optional}}
	{specific_dates_of_month_year:integer(text)            {label ""} {html {size 2}} {optional}}
	{specific_months:text(select)                          {label ""} {options {{"" ""} {"January" 1} {"February" 2} {"March" 3} \
			{"April" 4} {"May" 5} {"June" 6} \
			{"July" 7} {"August" 8} {"September" 9} \
			{"October" 10} {"November" 11} {"December" 12}}} {optional}}
	{repeat_month_opt1:text(radio)                         {label ""} {options {{"Day" 1}}} {optional}}
	{repeat_month_opt2:text(radio)                         {label ""} {options {{"The" 1}}} {optional}}
	{repeat_end_date_opt:text(radio)                       {label "End Date: "} {options {{"No End Date" 0} {"Until" 1}}} {value {1}}}
	{repeat_end_date:date,to_sql(sql_date)                 {label ""} {format "YYYY/MM/DD"} {help} {value $today_date} {optional}}
	{edit_repeating_event:boolean(checkbox),optional       {label "Edit Repeating Events: "} {options {{"" t}}}}
	{update_all_future_events_p:boolean(checkbox),optional {label "Update Future Events: "} {options {{"" t}}} {after_html "Check if you want to update all future events"}}
	{submit:text(submit)                                   {label "Submit"}}
} -validate {
	{end_date {[template::util::date::compare $end_date $start_date] > 0} "End date must be after the start date"}
	{start_date {[template::util::date::compare $end_date $start_date] > 0} "End date must be after the start date"}
} -edit_request {
	### Make sure event exists if event_id is passed to the page
	if {[info exists event_id]} {
		set selection [db_0or1row get_event_data {}]
		if {!$selection} {
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

	if {[empty_string_p $update_all_future_events_p]} {
		set update_all_future_events_p "f"
	}   

    if {$all_day_p=="t"} {
        set start_date "[string range $start_date 0 18] 00 00[string range $start_date 25 48]"
        set end_date "[string range $end_date 0 18] 23 55[string range $end_date 25 48]"
    }

} -new_data {
	# HANDLING NEW EVENT DATA ###############################################################################################################

	set repeat_template_id ""
	set monthly_option ""

	set failed_p 0
	db_transaction {
		# INSERT NEW EVENT ##################################################################################################################
		set event_id [ctrl_event::new -event_id $event_id \
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
									  -event_image $event_image\
						              -event_image_caption $event_image_caption\
									  -category_id $category_id \
						              -context_id $context_id \
						              -package_id $package_id]
		# END INSERTING NEW EVENT

		# CHECK IF EVENT IS REPEATING - CALL PROCEDURE TO INSERT REPEATING EVENTS IF IT IS
		if {$repeat_template_p == "t"} {
			set event_id_list [ctrl_event::repetition::repeat -event_id $event_id -frequency_type $frequency_type \
								   -repeat_end_date_opt $repeat_end_date_opt \
								   -frequency_day $frequency_day -frequency_week $frequency_week \
								   -frequency_month $frequency_month -frequency_year $frequency_year \
								   -specific_day_frequency $specific_day_frequency \
								   -specific_days_week $specific_days_week -specific_months $specific_months \
								   -specific_days_month $specific_days_month -specific_dates_of_month_month $specific_dates_of_month_month \
								   -specific_dates_of_month_year $specific_dates_of_month_year \
								   -repeat_month_opt1 $repeat_month_opt1 -repeat_month_opt2 $repeat_month_opt2 \
								   -repeat_end_date $repeat_end_date -event_object_id $event_object_id -title $title \
								   -start_date $start_date -end_date $end_date -all_day_p $all_day_p \
								   -location $location -notes $notes -capacity $capacity \
								   -event_image $event_image -event_image_caption $event_image_caption -category_id $category_id \
								   -context_id $context_id -package_id $package_id -add_event_p "t"]
		}
	} on_error {
		set failed_p 1
		db_abort_transaction
	}

	if {$failed_p != 0} {
		ad_return_error "Fail" $errmsg
		ad_script_abort
	}

} -edit_data {

	set failed_p 0
	db_transaction {

		ctrl_event::get -event_id $event_id -array event_info
		
		set repeat_template_id $event_info(repeat_template_id)
		if {[empty_string_p $repeat_template_id] || $update_all_future_events_p == "f"} {
			#No Other Repeating Events, just edit this event
			ctrl_event::update -event_id $event_id \
				               -event_object_id $event_object_id \
			                   -repeat_template_p $repeat_template_p \
			                   -title $title \
					           -start_date $start_date \
			     		       -end_date $end_date \
					           -all_day_p $all_day_p \
					           -location $location \
			    		       -notes $notes \
				    	       -capacity $capacity \
					           -event_image $event_image \
		                       -event_image_caption $event_image_caption \
					           -category_id $category_id   
		} else {
			#Edit other repeating Events
			if {[empty_string_p [string trim $event_image]] && $current_image == "<i>n/a</i>"} {
				set event_image ""
			}

			ctrl_event::update_recurrences -event_id $event_id \
			                               -event_object_id $event_object_id \
			                               -repeat_template_p $repeat_template_p \
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
				                           -repeat_template_id $repeat_template_id 
		}
		
	} on_error {
		set failed_p 1
		db_abort_transaction 
	}

	if {$failed_p != 0} {
		ad_return_error "Fail" $errmsg
		ad_script_abort
	}
} -after_submit {

	if {[ad_form_new_p -key event_id]} {
		ad_returnredirect "${package_url}admin"
	} else {
		ad_returnredirect "${package_url}event-view?event_id=$event_id"
	}
}

# END SET UP EVENT FORM #####################################################################################################################
