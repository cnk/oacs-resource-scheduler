# /packages/ctrl-calendar/www/profile-ae.tcl
ad_page_contract {

        This page allows you to add or edit a user profile

        @author:        shhong@mednet.ucla.edu
        @creation-date: 03/06/2006
        @cvs-id         $Id: 
} {
   {profile_id:naturalnum,optional}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

if {[exists_and_not_null profile_id]} {
   ### OLD
} else {
   ### NEW
   set profile_id [ctrl::cal::profile::add -user_id $user_id -package_id $package_id]
   permission::grant -party_id $user_id -object_id $profile_id -privilege admin
}

set calendar_options [ctrl::cal::option_list]

set root_path [ctrl::cal::category::root_info -info path -package_id $package_id]
set category_options [ctrl::category::option_list -path "${root_path}//Event Categories" -top_label "All" -top_value 0 -disable_spacing 2]

set email_period_options [list [list "Once a week on (select one)" "weekly"] [list "Daily" "daily"] [list "Stop sending me notifications" "none"]]

set email_day_options [list [list "Monday" "Monday"] [list "Tuesday" "Tuesday"] [list "Wednesday" "Wednesday"] [list "Thursday" "Thursday"] [list "Friday" "Friday"] [list "Saturday" "Saturday"] [list "Sunday" "Sunday"]]
set email_upto_options [list [list "Days" "day"] [list "Months" "month"] [list "Years" "year"] ]

ad_form -name add_edit_profile -method post -form {
   profile_id:key
   {calendar:text(checkbox),optional,multiple      {label Calendars}  {options $calendar_options} }
   {category:text(checkbox),optional,multiple      {label Categories} {options $category_options} }
   {email_period:text(radio),optional,multiple     {label Email}      {options $email_period_options} {value "none"}}
   {email_day:text(select),optional,multiple       {label Week}       {options $email_day_options} }
   {email_upto:text(text),optional      {label "Upto"}    {html {size 4 maxlength 4}} }
   {email_upto_type:text(select),optional,multiple      {label "Upto"}       {options $email_upto_options} }
   {submit:text(submit)                            {label "Submit"}}
} -validate {
   {email_upto {![empty_string_p $email_upto]} "This value is required"}
   {email_upto {[regexp {^[1-9]([0-9]*)$} $email_upto match]} "This value must be an integer number greater than 0"}
} -new_request {
   ### SETUP
   permission::require_permission -party_id $user_id -object_id $package_id -privilege read
} -new_data {
   ### INSERT   
   permission::require_permission -party_id $user_id -object_id $package_id -privilege read
} -edit_request {
   ### RETRIEVE   
   permission::require_permission -party_id $user_id -object_id $profile_id -privilege write
   set fail_p [catch {
   set calendar [ctrl::cal::profile::get_calendar_all -profile_id $profile_id]
   } errmsg]
   if {$fail_p != 0} {
      ad_return_error "Fail" $errmsg
      return
   }
   set fail_p [catch {
   set category [ctrl::cal::profile::get_category_all -profile_id $profile_id]
   } errmsg]
   if {$fail_p != 0} {
      ad_return_error "Fail" $errmsg
      return
   }
   db_0or1row email {}
   if {[empty_string_p $email_upto]} {
      set email_upto 7
      set email_upto_type "month"
   }
} -edit_data {
   ### UPDATE 
   ns_log Notice "VLC: PROFILE: $profile_id  CAL: $calendar  CAT: $category "   
   permission::require_permission -party_id $user_id -object_id $profile_id -privilege write
   set fail_p [catch {
      ctrl::cal::profile::update_calendar_filter -profile_id $profile_id -calendar $calendar
   } errmsg]
   if {$fail_p != 0} {
      ad_return_error "Fail" $errmsg
      return
   }
   set fail_p [catch {
      ctrl::cal::profile::update_category_filter -profile_id $profile_id -category $category
   } errmsg]
   if {$fail_p != 0} {
      ad_return_error "Fail" $errmsg
      return
   }
   set fail_p [catch {
      ctrl::cal::profile::update_email -profile_id $profile_id -email_period $email_period -email_day $email_day -email_upto $email_upto -email_upto_type $email_upto_type
   } errmsg]
   if {$fail_p != 0} {
      ad_return_error "Fail" $errmsg
      return
   }
} -after_submit {
   ### FINISH
   set subsite_id [ad_conn subsite_id]
   set filter_by [parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance -default "subsite"]
   rss_gen_report_cal_filter $user_id $filter_by
   ad_returnredirect "/calendar"

} 

if {[ad_form_new_p -key profile_id]} {
   set title "Add a Profile"
} else {
   set title "Edit a Profile"
}
