ad_page_contract {
    Page to add and edit a policy for a reservable resource

    @param policy_id the policy id
    @param resource_id the reservable resource that the policy belongs to
} {
    policy_id:naturalnum,optional
    resource_id:naturalnum,notnull
    resource_type:notnull
    {return_url ""}
}

# -- Retrieve session information 
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# -- Build the appropriate labels and titles for the page
if [string equal $resource_type room] {
    set exist_p [crs::room::get -room_id $resource_id -column_array room_info]
    set resource_title "Room Info"
} else {
    crs::reservable_resource::get -resource_id $resource_id -column_array resv_resource_info
    set resource_title "Equipment Info"
}

if [ad_form_new_p -key policy_id] {
    set title "Create New policy"    
    set all_day_period_start "09 00"
    set all_day_period_end "17 00"
} else {
    # ----------------------------------------------------------------------
    # Retrieve policy information 
    # ----------------------------------------------------------------------
    set default_policy_exist_p [crs::resv_resrc::policy::get -by id \
				    -policy_id $policy_id]

    set title "Edit $policy_info(policy_name) policy"
    set cnsi_context_bar [crs::cnsi::context_bar -page_title $title -manage_p 1]

    set all_day_period_start $policy_info(all_day_period_start)
    set all_day_period_end $policy_info(all_day_period_end)

    regsub ":" $all_day_period_start " " all_day_period_start 
    regsub ":" $all_day_period_end " " all_day_period_end 
}

# -- Construct return url if it is empty
if [empty_string_p $return_url] {
    if [string equal $resource_type room] {
	set return_url "room?[export_url_vars room_id=$resource_id]"
    } else {
	set return_url "resv-resource?[export_url_vars resource_id]"
    }
} 


# -- specify the options for priority level
set priority_level_list [list {0 0} {1 1} {2 2} {3 3} {4 4} {5 5}]

# -----------------------------------------------------------
# Currently the default policy is used by the reservation system
# There might be rare situations where we want to update the chanages,
# so we'll leave it only to the side wide administrator
# -----------------------------------------------------------
if [acs_user::site_wide_admin_p] {
    set policy_name_mode edit
} else {
    set policy_name_mode display
}

ad_form -name policy_form -form {
    {policy_id:key(crs_resv_policy_seq) {label {Policy Identifier}}}
    {policy_name:text(text) {mode $policy_name_mode} {html {size 25 maxlength 50}} {label {Policy Name}}}
    {latest_resv_date:date(date) {label {Latest Date for Reservations}} {format "Mon dd yyyy"}}
    {time_interval_after_resv_date_day:naturalnum(text) {html {size 2 maxlength 4}} {label day(s)} {value 0}}
    {time_interval_after_resv_date_hour:naturalnum(text) {html {size 2 maxlength 4}} {label hour(s)} {value 0}}
    {time_interval_after_resv_date_min:naturalnum(text) {html {size 2 maxlength 4}} {label minute(s)} {value 0}}
    {time_interval_before_start_dte_day:naturalnum(text) {html {size 2 maxlength 4}} {label day(s)} {value 0}}
    {time_interval_before_start_dte_hour:naturalnum(text) {html {size 2 maxlength 4}} {label hour(s)} {value 0}}
    {time_interval_before_start_dte_min:naturalnum(text) {html {size 2 maxlength 4}} {label minute(s)} {value 0}}
    {resv_period_before_start_date_day:naturalnum(text) {html {size 2 maxlength 4}} {label day(s)} {value 0}}
    {resv_period_before_start_date_hour:naturalnum(text) {html {size 2 maxlength 4}} {label hous(s)} {value 0}}
    {resv_period_before_start_date_min:naturalnum(text) {html {size 2 maxlength 4}} {label minute(s)} {value 0}}
    {all_day_period_start:date,to_sql(sql_date) {label "All Day Period Starts From: "} {format "HH12:MI AM"} {help} {values $all_day_period_start}}
    {all_day_period_end:date,to_sql(sql_date) {label "All Day Period Ends At: "} {format "HH12:MI AM"} {help} {values $all_day_period_end}}
    {priority_level:naturalnum(select) {options $priority_level_list} {label {Priority}}}
} -new_request {
    # --------------------------------------------------------------------------
    # Check that user has admin permission on room 
    # -------------------------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $package_id \
	-privilege create

    # --------------------------------------------------------------------------
    # Set the default date of latest for reservations end date 
    # -------------------------------------------------------------------------
    set five_years_later [clock format [clock scan "5 years" -base [clock seconds]]  -format "%Y %m %d"]
    set year [lindex $five_years_later 0]
    set month [lindex $five_years_later 1]
    set day [lindex $five_years_later 2]

    set date_field [template::util::date::now]
    template::util::date::set_property year date_field $year
    template::util::date::set_property month date_field $month
    template::util::date::set_property day date_field $day
    set latest_resv_date $date_field
} -edit_request {

    permission::require_permission -party_id $user_id -object_id $resource_id \
	-privilege write

    # ----------------------------------------------------------------------
    # Popluate the form widgets with the policy info
    # ----------------------------------------------------------------------
    set policy_name $policy_info(policy_name) 
    set date_list [split $policy_info(latest_resv_date) "-"]
    set latest_resv_date [template::util::date::now]
    set latest_resv_date [template::util::date::set_property year $latest_resv_date [lindex $date_list 0]]
    set latest_resv_date [template::util::date::set_property month $latest_resv_date [lindex $date_list 1]]
    set latest_resv_date [template::util::date::set_property day $latest_resv_date [lindex $date_list 2]]
    
    crs::resv_resrc::policy::util::get_interval_info -interval_seconds $policy_info(time_interval_after_rsv_dte)
    set time_interval_after_resv_date_day $interval_info(day)
    set time_interval_after_resv_date_hour $interval_info(hour)
    set time_interval_after_resv_date_min $interval_info(minute)

    crs::resv_resrc::policy::util::get_interval_info -interval_seconds $policy_info(time_interval_before_start_dte)
    set time_interval_before_start_dte_day $interval_info(day)
    set time_interval_before_start_dte_hour $interval_info(hour)
    set time_interval_before_start_dte_min $interval_info(minute)

    crs::resv_resrc::policy::util::get_interval_info -interval_seconds $policy_info(resv_period_before_start_date)
    set resv_period_before_start_date_day $interval_info(day)
    set resv_period_before_start_date_hour $interval_info(hour)
    set resv_period_before_start_date_min $interval_info(minute)

    set priority_level $policy_info(priority_level)

} -on_submit {
    # ----------------------------------------------------------------------
    # Convert the time intervals to seconds 
    # ----------------------------------------------------------------------
    set day_seconds 86400
    set hour_seconds 3600
    set minute_seconds 60

    set time_interval_after_resv_date [expr $time_interval_after_resv_date_day*$day_seconds+ \
					   $time_interval_after_resv_date_hour*$hour_seconds+ \
					   $time_interval_after_resv_date_min*$minute_seconds]
    
    set time_interval_before_start_dte [expr $time_interval_before_start_dte_day*$day_seconds+ \
					  $time_interval_before_start_dte_hour*$hour_seconds+ \
					  $time_interval_before_start_dte_min*$minute_seconds]
    
    set resv_period_before_start_date [expr $resv_period_before_start_date_day*$day_seconds+ \
					   $resv_period_before_start_date_hour*$hour_seconds+ \
					  $resv_period_before_start_date_min*$minute_seconds]

    set latest_year [template::util::date::get_property year $latest_resv_date]
    set latest_month [template::util::date::get_property month $latest_resv_date]
    set latest_day [template::util::date::get_property day $latest_resv_date]
    set latest_resv_date "$latest_year-$latest_month-$latest_day"

} -new_data {
    # --------------------------------------------------------------------------
    # Check that user has admin permission on room 
    # -------------------------------------------------------------------------
    permission::require_permission -party_id $user_id -object_id $package_id \
	-privilege create

    set failed_p 0
    db_transaction {
	crs::resv_resrc::policy::add -policy_id $policy_id -resource_id $resource_id  \
	    -policy_name $policy_name \
	    -latest_rev_date $latest_rev_date \
	    -time_interval_after_resv_date  $time_interval_after_resv_date \
	    -time_interval_before_start_dte $time_interval_before_start_dte \
	    -resv_period_before_start_date $resv_period_before_start_date \
	    -priority_level $priority_level -all_day_period_start $all_day_period_start \
	    -all_day_period_end $all_day_period_end
    } on_error {
	set failed_p 1
    }

    if $failed_p {
	ad_return_error "System Error" "Sorry we are not able process your question due to <pre> $errmsg </pre>"
	ad_script_abort
    }

} -edit_data {
    permission::require_permission -party_id $user_id -object_id $resource_id \
	-privilege write

    set failed_p 0
    db_transaction {
	crs::resv_resrc::policy::update -policy_id $policy_id -policy_name $policy_name\
	    -latest_resv_date $latest_resv_date \
	    -time_interval_after_resv_date  $time_interval_after_resv_date \
	    -time_interval_before_start_dte $time_interval_before_start_dte \
	    -resv_period_before_start_date $resv_period_before_start_date \
	    -priority_level $priority_level -all_day_period_start $all_day_period_start \
	    -all_day_period_end $all_day_period_end
    } on_error {
	set failed_p 1
    }

    if $failed_p {
	ad_return_error "System Error" "Sorry we are not able process your question due to <pre> $errmsg </pre>"
	ad_script_abort
    }

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -cancel_label {
Cancel
} -cancel_url $return_url \
    -export [list resource_id return_url resource_type]


ad_return_template

 
