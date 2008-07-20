ad_library {

        Procedures to add and delete a user profile

        @author  shhong@mednet.ucla.edu (SH)
        @creation-date  02/24/06
        @cvs-id $Id: 
}

namespace eval ctrl::cal::profile {}

ad_proc -public ctrl::cal::profile::add {
    {-user_id:required}
    {-package_id ""}
} {                   
    Procedure to add a profile
        
    @param user_id is the onwer of the profile 
    @param package_id is the package where the profile belongs (optional)

    @return profile_id
} {
   set profile_name "Calendar Profile"
   set var_list [list \
                   [list profile_name "Calendar Profile"]\
                   [list owner_id $user_id]\
                   [list package_id $package_id]]
   set error_p 0
   db_transaction {
      if {![db_0or1row check {}]} {
         set profile_id [package_instantiate_object \
                         -var_list $var_list \
                         "ctrl_ccal_profile" ]
      }
   } on_error {
        set error_p 1
   }
   if {$error_p} {
        ad_return_error "Error adding a calendar profile" "<p>An unexpected error occurred while adding a calendar profile:</p><p>$errmsg</p>"
        ad_script_abort
   }
   return $profile_id
}       

ad_proc -public ctrl::cal::profile::delete {
                {-profile_id:required}
} {
    Delete a profile

    @param profile_id
} {
    set error_p 0
    db_transaction {
        db_exec_plsql profile {}
    } on_error {
        set error_p 1
    }

    if {$error_p} {
        ad_return_error "Error deleting a calendar profile" "<p>An unexpected error occurred while deleting a calendar profile:</p><p>$errmsg</p>"
        ad_script_abort
    }
}

ad_proc -public ctrl::cal::profile::add_filter {
                {-profile_id:required}
                {-cal_id:required}
                {-category_id:required}
} {
   Procedure to add a filter to a profile

   @param profile_id is the calendar profile id
   @param cal_id is the calendar id to map
   @param category_id is the category id to map
   
} {
   set profile_type ""
   if {$cal_id > 0 && $category_id > 0} {
      set profile_type "cal_category"  
   } elseif {$cal_id > 0} {
      set profile_type "calendar"  
   } elseif {$category_id > 0} {
      set profile_type "category"  
   } 
   if {![empty_string_p $profile_type]} {
      set error_p 0
      db_transaction {
         if {![db_0or1row check_$profile_type {}]} {
            db_dml $profile_type {}
         }
      } on_error {
         set error_p 1
      } 
      if {$error_p} {
         ad_return_error "Error adding a profile filter" "<p>An unexpected error occurred while adding a profile filter:</p><p>$errmsg</p>"
         ad_script_abort
      }
   }
   return "$profile_type"
}

ad_proc -public ctrl::cal::profile::delete_filter_by_id {
                {-filter_id:required}
} {
        Procedure to delete a filter from a profile
} {  
   set error_p 0
   db_transaction {
         db_dml filter {}
   } on_error {
       set error_p 1
   }
   if {$error_p} {
         ad_return_error "Error deleting a profile filter" "<p>An unexpected error occurred while deleting a profile filter:</p><p>$errmsg</p>"
         ad_script_abort
   }
}

ad_proc -public ctrl::cal::profile::delete_filter_by_category {
                {-profile_id:required}
                {-category_id:required}
} {
        Procedure to delete a category filter from a profile
} {  
   set error_p 0
   db_transaction {
         db_dml filter {}
   } on_error {
       set error_p 1
   }
   if {$error_p} {
         ad_return_error "Error deleting a profile category filter" "<p>An unexpected error occurred while deleting a profile category filter:</p><p>$errmsg</p>"
         ad_script_abort
   }
}

ad_proc -public ctrl::cal::profile::delete_filter_by_calendar {
                {-profile_id:required}
                {-cal_id:required}
} {
        Procedure to delete a calendar filter from a profile
} { 
   set error_p 0
   db_transaction {
         db_dml filter {}
   } on_error {
       set error_p 1
   }
   if {$error_p} {
         ad_return_error "Error deleting a profile calendar filter" "<p>An unexpected error occurred while deleting a profile calendar filter:</p><p>$errmsg</p>"
         ad_script_abort
   }
}



ad_proc -public ctrl::cal::profile::get_category {
                {-profile_id:required}
} {
	Procedure to return category id of the profile type category only.
} {
   set result ""
   db_foreach ids {} {
      lappend result $category_id
   }
   return $result
}

ad_proc -public ctrl::cal::profile::get_calendar {
                {-profile_id:required}
} {
	Procedure to return calendar ids of profile type calendar only.
} {
   set result ""
   db_foreach ids {} {
      lappend result $cal_id
   }
   return $result
}

ad_proc -public ctrl::cal::profile::get_category_all {
                {-profile_id:required}
} {
	Procedure to return category ids of profile type category only.  If it is empty, it returns 0 to mean all categories.
} {
   set result [ctrl::cal::profile::get_category -profile_id $profile_id]
   if {[empty_string_p $result]} {
       set result 0
   }
   return $result
}

ad_proc -public ctrl::cal::profile::get_calendar_all {
                {-profile_id:required}
} {
	Procedure to return calendar ids of profile type calendar only.  If it is empty, it returns 0 to mean all calendars.
} {
   set result [ctrl::cal::profile::get_calendar -profile_id $profile_id]
   if {[empty_string_p $result]} {
       set result 0
   }
   return $result
}

ad_proc -public ctrl::cal::profile::update_category_filter {
	{-profile_id:required}
        {-category ""}
} {
	Procedure to update the profile type category.
} {
   set error_p 0
   db_transaction {
      set cur_category_list [ctrl::cal::profile::get_category -profile_id $profile_id]
      if {[llength $category] > 0 && [lsearch -glob $category 0] == -1} {
         foreach cur_category_id $cur_category_list {
            if {[lsearch -glob $category $cur_category_id] == -1} {
               ctrl::cal::profile::delete_filter_by_category -profile_id $profile_id -category_id $cur_category_id 
            }
         }
         foreach new_category_id $category {
            if {[lsearch -glob $cur_category_list $new_category_id] == -1} {
               ctrl::cal::profile::add_filter -profile_id $profile_id -cal_id 0 -category_id $new_category_id
            }
         }
      } else {
         foreach cur_category_id $cur_category_list {
            ctrl::cal::profile::delete_filter_by_category -profile_id $profile_id -category_id $cur_category_id 
         }
      }
   } on_error {
      set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error updating the profile category" "<p>An unexpected error occurred while updating the profile category:</p><p>$errmsg</p>"
      ad_script_abort
   }
}

ad_proc -public ctrl::cal::profile::update_calendar_filter {
        {-profile_id:required}
        {-calendar ""}
} {
	Procedure to update the profile type calendar.
} {
   set error_p 0
   db_transaction {
      set cur_calendar_list [ctrl::cal::profile::get_calendar -profile_id $profile_id]
      if {[llength $calendar] > 0 && [lsearch -glob $calendar 0] == -1} {
         foreach cur_calendar_id $cur_calendar_list {
            if {[lsearch -glob $calendar $cur_calendar_id] == -1} {
               ctrl::cal::profile::delete_filter_by_calendar -profile_id $profile_id -cal_id $cur_calendar_id          
            }
         }
         foreach new_calendar_id $calendar {
            if {[lsearch -glob $cur_calendar_list $new_calendar_id] == -1} {
               ctrl::cal::profile::add_filter -profile_id $profile_id -category_id 0 -cal_id $new_calendar_id
            }
         }
      } else {
         foreach cur_calendar_id $cur_calendar_list {
            ctrl::cal::profile::delete_filter_by_calendar -profile_id $profile_id -cal_id $cur_calendar_id          
         }
      }
   } on_error {
      set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error updating the profile calendar" "<p>An unexpected error occurred while updating the profile calendar:</p><p>$errmsg</p>"
      ad_script_abort
   }
}

ad_proc -public ctrl::cal::profile::display {
        {-label:required}
} {
	Procedure to extract space character from a label to display a hierarchy level.
} {
   set result "" 
   for {set i 0} {$i < [string length $label]} {incr i} { 
      if {[string range $label $i $i] == " "} {
         append result "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      } else {
         break
      } 
   }
   return $result
}

ad_proc -public ctrl::cal::profile::update_email {
        {-profile_id:required}
        {-email_period:required}
        {-email_day:required}
        {-email_upto:required}
        {-email_upto_type:required}
} {
	Procedure to update the profile email.
} {
   if {$email_period == "weekly"} {
      set set_email_day ",email_day = :email_day"
   } else {
      set set_email_day ",email_day = null"
   }
   set error_p 0
   db_transaction {
      db_dml email {}
   } on_error {
      set error_p 1
   }
   if {$error_p} {
      ad_return_error "Error updating the email profile" "<p>An unexpected error occurred while updating the email profile:</p><p>$errmsg</p>"
      ad_script_abort
   }
}

ad_proc -public ctrl::cal::profile::send_email {
	{-user_id:required}
	{-email:required}
} {
	Procedure to send profile emails.
} {
if {[ns_config -exact "ns/server/drc/module/nssock" hostname] == "drc.ctrl.ucla.edu"} {
   ### Checking for weedkly or daily time period against the email_sent date column in ccal_profiles
   if {[db_0or1row profile_email {}]} {
      set sql_where_event "" 
      switch $email_upto_type {
         "day"   {set sql_where_event " and trunc(z.start_date) <= ( sysdate + $email_upto ) "}
         "month" {set sql_where_event " and trunc(z.start_date) <= add_months(sysdate, $email_upto ) "}
         "year"  {set sql_where_event " and trunc(z.start_date) <= add_months(sysdate, $email_upto * 12) "}
      }
      set send_p "f"
      set email_msg ""
      switch $email_period {
         "weekly" {if {$email_day == $today_day && ([empty_string_p $email_sent] || $email_sent < $today)} {
                      set send_p "t"
                   }
                   set email_msg "weekly on $email_day"
                  }
         "daily"  {if {[empty_string_p $email_sent] || $email_sent < $today} {
                      set send_p "t"
                   }
                   set email_msg "daily"
                  }
      }
      set category_msg ""
      set calendar_msg ""
      if {$send_p == "t"} {
         ### If time period has been verified, generate email
         set sql_where ""
         set sql_category ""
         set sql_calendar ""
         set from_category ""
         ### Retrieve calendars and categories from user profile
         ### Subcategorization is not supported at this time
         db_foreach profile_calendar_category {} {
            switch $profile_type {
               "calendar"     {if {![empty_string_p $sql_calendar]} {append sql_calendar ","}
                               append sql_calendar $cal_id
                               if {![empty_string_p $calendar_msg]} {append calendar_msg ","}
                               append calendar_msg $calendar_name}
               "category"     {if {![empty_string_p $sql_category]} {append sql_category ","}
                               append sql_category $category_id
                               if {![empty_string_p $category_msg]} {append category_msg ","}
                               append category_msg $category_name}
            }
         }
         if {![empty_string_p $sql_calendar]} {
            append sql_where " and a.cal_id in ($sql_calendar) "
         }
         if {![empty_string_p $sql_category]} {
            append sql_where " and c.event_id = b.event_id and c.category_id in ($sql_category) "
            set from_category " , ctrl_calendar_event_categories c "
         }

         set this [ad_url]
         set items ""
         ### Retrieve events based on the user profile
         db_foreach events {} {
            set event_link "${this}/calendar/events/event-view?event_id=$event_id&cal_id=$cal_id"
            append items "\n********************************************************************************\n"
            append items "Title : $event_title\nDescription: $event_notes\nLocation : $event_location\nStart Date: $event_start_date\nEnd Date: $event_end_date\nWeb Link : $event_link\n"
         }
         if {![empty_string_p $items]} {
            append items "\n********************************************************************************\n"
            set email_from "drc-support@ctrl.ucla.edu"
            set email_subject "DGSOM Portal Calendar"
            if {[empty_string_p $calendar_msg]} {set calendar_msg "All"}
            if {[empty_string_p $category_msg]} {set category_msg "All"}
            set fail_p [catch {
               ns_sendmail "$email" "$email_subject <$email_from>" "$email_subject" "$email_subject\n\nYou have choosen to receive notifications $email_msg of the following calendars ($calendar_msg) and categories ($category_msg).\n$items" 
               
            } errmsg]
            if {$fail_p != 0} {
               ad_return_error "Fail" $errmsg
               return
            }
         }
         db_dml email_sent {}
      }
   }
}
}

### Call from user-profile-init.tcl every hour
ad_proc -private ctrl::cal::profile::send_email_all {
} {
	Procedure to send profile emails for all users
} {
   db_foreach users {} {
      ctrl::cal::profile::send_email -user_id $user_id -email $email
   }
}

 
