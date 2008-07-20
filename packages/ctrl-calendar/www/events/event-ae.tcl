# /packages/ctrl-events/www/admin/event-ae.tcl

ad_page_contract {
	
    This page allows you to add or edit an event into the CTRL Events Database

    @author kellie@ctrl.ucla.edu (KL)
    @author avni@ctrl.ucla.edu (AK)
    @creation-date: 05/06/2005
    @cvs-id $Id: event-ae.tcl,v 1.2 2006/08/08 00:53:53 avni Exp $

} {
    {event_id:optional,integer}
    {delete_all_future_image:optional}
    {cal_id:naturalnum "0"}
    {date_value:optional ""}
    {return_url:optional ""}
    {add_posting_p:optional "0"}
}

set user_id [ad_maybe_redirect_for_registration]
set ip_address [ns_conn peeraddr]
set subsite_url [site_node_closest_ancestor_package_url]
set package_url [ad_conn package_url]
set subsite_id [ad_conn subsite_id]
set instance_id [ad_conn package_id]

#permission::require_permission -object_id $instance_id -privilege "create"

set filter_by [parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance]

if {[ad_form_new_p -key event_id]} {
    set current_image ""
    set event_template_p ""
    set page_title "Add Event"
    set edit_p 0
} else {
    set current_image [ctrl_event::event_image_display -event_id $event_id]
    
    if {[empty_string_p [string trim $current_image]]} {
	set current_image "<i>n/a</i>"
	set delete_image_link ""
    } else {
	set delete_image_link "<a href=../../../events/admin/photo-delete?[export_vars event_id]>Remove this Image</a>"
    }
    set page_title "Edit Event"
    set edit_p 1
}

set repeat_template_id ""

set root_path [ctrl::cal::category::root_info -info path -package_id $instance_id]
set path "$root_path//Event Categories"
set category_options [ctrl::category::option_list -path "${path}" -disable_spacing 0]

set today_date [db_string today_date {}]
set today_date_end [db_string today_date_end {}]

# Format so it defaults to the calendar date and use default time
if {![empty_string_p $date_value]} {
    regsub -all {\-} $date_value " " date_value
    set today_date "[string range $date_value 0 9][string range $today_date 10 15]"
    set today_date_end "[string range $date_value 0 9][string range $today_date_end 10 15]"
}

if {$cal_id == 0} {
    set possible_calendar_list [ctrl::cal::get_admin_calendar_list -user_id $user_id]
    
    if {[llength $possible_calendar_list] <= 1} {
	set cal_id [lindex [lindex $possible_calendar_list 0] 1]
	ad_form -name "add_edit_event" -form {
	    {cal_id:text(hidden) {value $cal_id}}
	}
    } else {
	ad_form -name "add_edit_event" -form {
	    {calendar_list:text(checkbox),multiple {label \"Calendar: \"} {options $possible_calendar_list}}
	}
    }
} else {
    ad_form -name "add_edit_event" -form {
	{cal_id:text(hidden) {value $cal_id}}
    }
}

# SET UP EVENT FORM #########################################################################################################################
ad_form -extend -name "add_edit_event" -method post -html {enctype multipart/form-data} -form {
    {add_posting_p:text(hidden) {value $add_posting_p}}
    {date_value:text(hidden) {value $date_value}}
    {title:text(text)                                      {label "Event Title: "} {html {size 60}}}
    {speakers:text(text),optional                          {label "Speakers: "} {html {size 50}}}
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
    {category_id:integer(checkbox),multiple,optional       {label "Category: "} {options {$category_options}}}
    {submit:text(submit)                                   {label "Submit"}}
    event_id:key
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
	
    set category_id [join [db_list category_values {}] " "]
    set calendar_list [join [db_list get_event_calendar_ids {}] " "]
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
    
    regsub -all {to_timestamp} $start_date {to_date} start_date
    regsub -all {to_timestamp} $end_date {to_date} end_date
    regsub -all {to_timestamp} $repeat_end_date {to_date} repeat_end_date

    if {$all_day_p=="t"} {
	set start_date "[string range $start_date 0 18] 00 00[string range $start_date 25 48]"
	set end_date "[string range $end_date 0 18] 23 55[string range $end_date 25 48]"
    }

    ### AMK SET THE EVENT_OBJECT_ID TO THE FDB DGSOM GROUP ID
    set event_object_id 0

    if {$cal_id == 0} {
	set cal_id_to_insert_list $calendar_list
    } else {
	set cal_id_to_insert_list [list $cal_id]
    }

} -new_data {
    # HANDLING NEW EVENT DATA ###############################################################################################################
    set repeat_template_id ""
    set monthly_option ""
    
    set fail_p [catch {
		
	# INSERT NEW EVENT #############################################################################################################
	set event_id [ctrl_event::new -event_id $event_id \
			  -event_object_id $event_object_id \
			  -repeat_template_id $repeat_template_id \
			  -repeat_template_p $repeat_template_p \
			  -title $title \
			  -speakers $speakers \
			  -start_date $start_date \
			  -end_date $end_date \
			  -all_day_p $all_day_p \
			  -location $location \
			  -notes $notes \
			  -capacity $capacity\
			  -event_image $event_image\
			  -event_image_caption $event_image_caption\
			  -category_id "" \
			  -context_id $instance_id \
			  -package_id $instance_id]
	# END INSERTING NEW EVENT ######################################################################################################

	# CHECK IF EVENT IS REPEATING - CALL PROCEDURE TO INSERT REPEATING EVENTS IF IT IS #############################################
	if {$repeat_template_p == "t"} {
	    ctrl_event::repetition::repeat -event_id $event_id -frequency_type $frequency_type \
		-repeat_end_date_opt $repeat_end_date_opt \
		-frequency_day $frequency_day -frequency_week $frequency_week \
		-frequency_month $frequency_month -frequency_year $frequency_year -specific_day_frequency $specific_day_frequency \
		-specific_days_week $specific_days_week -specific_months $specific_months \
		-specific_days_month $specific_days_month -specific_dates_of_month_month $specific_dates_of_month_month \
		-specific_dates_of_month_year $specific_dates_of_month_year -repeat_month_opt1 $repeat_month_opt1 \
		-repeat_month_opt2 $repeat_month_opt2 \
		-repeat_end_date $repeat_end_date -event_object_id $event_object_id \
		-title $title -speakers $speakers -start_date $start_date -end_date $end_date -all_day_p $all_day_p \
		-location $location -notes $notes -capacity $capacity \
		-event_image $event_image -event_image_caption $event_image_caption -category_id "" \
		-context_id $instance_id -package_id $instance_id -add_event_p "t"

	    # Add Categories for repeat calendar event based on repeat template id
	    ctrl::cal::event_categories_recurrence_upd -repeat_template_id $event_id -event_categories $category_id -start_date $start_date
	} else {
	    # Add Categories for calendar event
	    ctrl::cal::event_categories_upd -event_id $event_id -event_categories $category_id
	}
	
    } errmsg]
    
    if {$fail_p != 0} {
	ad_return_error "Fail" $errmsg
	return
    }
} -edit_data {
    
    set fail_p [catch {
	
	ctrl_event::get -event_id $event_id -array event_info
	set repeat_template_id $event_info(repeat_template_id)
	if {[empty_string_p $repeat_template_id] || $update_all_future_events_p == "f"} {
	    #No Other Repeating Events, just edit this event
	    ctrl_event::update -event_id $event_id \
		-event_object_id $event_object_id \
		-repeat_template_p $repeat_template_p \
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
		-category_id ""
	    # Add Categories for calendar event
	    ctrl::cal::event_categories_upd -event_id $event_id -event_categories $category_id
	} else {
	    #Edit other repeating Events
	    if {[empty_string_p [string trim $event_image]] && $current_image == "<i>n/a</i>"} {
		set event_image ""
	    }

	    ctrl_event::update_recurrences -event_id $event_id \
		-event_object_id $event_object_id \
		-repeat_template_p $repeat_template_p \
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
		-category_id "" \
		-repeat_template_id $repeat_template_id 

	    # Add Categories for repeat calendar event based on repeat template id
	    ctrl::cal::event_categories_recurrence_upd -repeat_template_id $repeat_template_id -event_categories $category_id -start_date $start_date
	}
	
    } errmsg]
    
    if {$fail_p != 0} {
	ad_return_error "Fail" $errmsg
	return
    }
} -after_submit {

    ### INSERT CALENDAR-EVENT MAPPINGS #############################################################################################
    db_transaction {
        ctrl::cal::event::del -event_id $event_id
	foreach cal_id $cal_id_to_insert_list {
	    ctrl::cal::event::insert -cal_id $cal_id -event_id $event_id
	}
    } on_error {
	db_abort_transaction
    }
    ### END INSERTING CALENDAR-EVENT MAPPINGS #####################################################################################

    if {[empty_string_p $return_url]} {
	set return_url "${package_url}"
    } 

    if {$add_posting_p == 1} {
        set digest_package_url [site_node_closest_ancestor_package_url -package_key digest -default "/digest/"]
        set digest_id [drc::digest::dgsom::digest_id]
	set cal_id [lindex $cal_id_to_insert_list 0]
  	set cal_digest_id [ctrl::cal::digest::get_cal_digest_id -cal_id $cal_id -ext_digest_id $digest_id -ext_digest_url_root "digest.healthsciences.ucla.edu"]
        ad_returnredirect "${digest_package_url}ws/posting-add?[export_url_vars cal_digest_id digest_id event_id return_url]"
    } else {
	ad_returnredirect $return_url
   }
} -export {return_url}
# END SET UP EVENT FORM #####################################################################################################################
