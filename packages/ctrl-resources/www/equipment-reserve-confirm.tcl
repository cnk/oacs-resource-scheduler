ad_page_contract {
    A page that allows you confirm your reservation or fix any conflicts before confirming

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$

    @param request_id is passed in if editing
} {
    {resource_id:notnull}
    {request_id:notnull}
    {event_id:notnull}
    {context:optional ""}
    {return_url [get_referrer]}
    {title:notnull}
    {start_date:array,date ""}
    {end_date:array,date ""}
    {start_date_sql ""}
    {end_date_sql ""}
    {all_day_p ""}
    {repeat_template_p ""}
    {specific_days_week ""}
    {specific_days_month ""}
    {frequency_type ""}
    {frequency_day ""}
    {frequency_week ""}
    {frequency_month ""}
    {frequency_year ""}
    {specific_day_frequency ""}
    {specific_dates_of_month_month ""}
    {specific_dates_of_month_year ""}
    {specific_months ""}
    {repeat_month_opt1 ""}
    {repeat_month_opt2 ""}
    {repeat_end_date_opt ""}
    {repeat_end_date:array,date ""}
    {repeat_end_date_sql ""}
    {event_code ""}
}

set user_id    [auth::require_login]
set user_name  [person::name -person_id $user_id]
set page_title "Reservation confirm"
set resource_admin_p [permission::permission_p -object_id $resource_id -privilege "admin"]
crs::resource::get -resource_id $resource_id -column_array "resource_info"

set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

if {[empty_string_p $repeat_template_p]} {
    set repeat_template_p "f"
}

if {[empty_string_p $all_day_p]} {
    set all_day_p "f"
}

#Is this a new request or an update?
set updating_p [db_string check_exists {} -default 0]

#NOTE: You can't export date arrays on submit. The workaround is to create a string that has already
#parsed the date arrays into the needed sql string.  We only care about the sql string on submit and ignore the  date arrays. (jeff@ctrl)
if {[array size start_date] != 0} {
    #Fix the buggy minutes value for date arrays

    if {$all_day_p} {
        set start_date(short_hours) "12"
        set start_date(minutes) "00"
        set start_date(ampm) "am"
    } elseif {[string length $start_date(minutes)] == 1} {
        set start_date(minutes) "0$start_date(minutes)"
    }

    set start_date_sql "to_date('$start_date(date) $start_date(short_hours):$start_date(minutes) $start_date(ampm)','YYYY-MM-DD HH12:MI AM')"
}
if {[array size end_date] != 0} {
    #Fix the buggy minutes value for date arrays
    if {$all_day_p} {
        set end_date(short_hours) "11"
        set end_date(minutes) "55"
        set end_date(ampm) "pm"
    } elseif {[string length $end_date(minutes)] == 1} {
        set end_date(minutes) "0$end_date(minutes)"
    }

    set end_date_sql "to_date('$end_date(date) $end_date(short_hours):$end_date(minutes) $end_date(ampm)', 'YYYY-MM-DD HH12:MI AM')"
}

if {[array size repeat_end_date] != 0} {
    set repeat_end_date_sql "to_date('$repeat_end_date(date)', 'YYYY-MM-DD')"
}

#validate that the start_date < end_date
set start_end_date_conflict_p [db_string check_dates {} -default 0]
set resource_available_p [crs::reservable_resource::check_availability -event_id $event_id -resource_id $resource_id -start_date $start_date_sql -end_date $end_date_sql]

#if the resource is not available, gather extra information about previous reservation
if {!$resource_available_p && !$updating_p} {
    #get previous reservation
    set prev_reservations [db_list_of_lists get_prev_reservations {}]
    #get the top most person
    set conflicting_reserver_id [lindex [lindex $prev_reservations 0] 0]
    set conflicting_request_id [lindex [lindex $prev_reservations 0] 1]
    set conflicting_reserver_name [person::name -person_id $conflicting_reserver_id]
    set conflicting_reserver_email [cc_email_from_party $conflicting_reserver_id]
} else {
    set conflicting_request_id ""
    set conflicting_reserver_name ""
    set conflicting_reserver_email ""
}

if {![empty_string_p $context]} {
    lappend context $page_title
} else {
    set context [list [list $return_url "Equipment Details"] $page_title]
}
if {[empty_string_p $event_code]} {
    set event_code [crs::event::generate_event_code -event_id $event_id]
}

ad_form -name "confirm" -form {
    {warn:text(inform) {label {Confirm:}} {value {Please confirm your reservation or make any changes:}}}
    {sub:text(submit) {label {Make Reservation!}}}
} -on_submit {
    set repeat_template_id ""
    set monthly_option ""
    set invalid_recurrence_msg "The recurrence pattern is not valid"
    set fail_p 0
    #set the status, if the resource requires approval
    if {$resource_info(approval_required_p)} {
        if {$resource_admin_p} {
            set status "approved"
        } else {
            set status "pending"
        }
    } else {
        set status "approved"
    }
    db_transaction {
        #if we're not updating, remove the conflicting request
        if {![empty_string_p $conflicting_request_id]} {
            #cancel conflicting reservation, if it exists
            set all_conflicting_events [db_list get_conflicting_events {}]
            foreach event_id $all_conflicting_events {
                crs::event::update_status -event_id $event_id -status "cancelled"
            }
           crs::request::update_status -request_id $conflicting_request_id -status "cancelled"
            set start_date_pretty [db_string get_start_date_pretty {} -default ""]
            set admin_email [ad_system_owner]
            set email_subject "Reservation cancelled for $resource_info(name) on $start_date_pretty"
            set email_body "$conflicting_reserver_name,\n\n\nThis message is to inform you that an administrator has cancelled your reservation for the $resource_info(name) on $start_date_pretty.\n\nIf you have any questions about this action, please contact $admin_email."

            #email affected parties of cancelled reservations
            set fail_p [catch {ns_send_mail \
                                   $admin_email\
                                   $conflicing_reserver_email\
                                   $email_subject\
                                   $email_body } errmsg]
        }
        if {!$updating_p} {
            set event_id [crs::event::new -request_id $request_id \
                              -event_id "$event_id" \
                              -name "$title" \
                              -object_requested "$resource_id" \
                              -start_date $start_date_sql \
                              -end_date $end_date_sql \
                              -event_code $event_code\
                              -all_day_p $all_day_p \
                              -status $status\
                              -notes ""]
	    permission::grant -party_id $user_id -object_id $request_id -privilege read	
        } else {
            #do update
            crs::event::update \
                -event_id $event_id\
                -title $title\
                -start_date $start_date_sql\
                -end_date $end_date_sql\
                -all_day_p $all_day_p
	    permission::grant -party_id $user_id -object_id $request_id -privilege read	
        }
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
                set repeat_end_date_str [string range [db_string get_repeat_end_date {}] 0 15]
                set repeat_end_date_sql "to_date('$repeat_end_date_str', 'YYYY MM DD HH24 MI')"
            }
            # ADDING REPEATING EVENTS
            if {!$updating_p} {
                #add repeating pattern in repeating_events
                event_repetitions::pattern_add -repeat_template_id $event_id \
                    -frequency_type $frequency_type \
                    -frequency $frequency \
                    -specific_day_frequency $specific_day_frequency \
                    -specific_days $specific_days \
                    -specific_dates_of_month $specific_dates_of_month \
                    -specific_months $specific_months\
                    -end_date $repeat_end_date_sql
                #add all occurences to the event
                event_repetitions::repeating_events_add -event_id "" \
                    -event_object_id "$resource_id" \
                    -repeat_template_id $event_id \
                    -repeat_template_p "f" \
                    -title $title \
                    -start_date $start_date_sql \
                    -end_date $end_date_sql \
                    -all_day_p $all_day_p \
                    -location "" \
                    -notes "" \
                    -capacity "" \
                    -frequency_type $frequency_type \
                    -frequency $frequency \
                    -specific_day_frequency $specific_day_frequency \
                    -specific_days $specific_days \
                    -specific_dates_of_month $specific_dates_of_month \
                    -specific_months $specific_months \
                    -repeat_end_date $repeat_end_date_sql \
                    -category_id ""\
                    -monthly_option $monthly_option
            } else {
                #do update
            }
            # FINISHED ADDING REPEATING EVENTS
        }  
    } on_error {
        set fail_p 1
    }
    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
        ad_script_abort
    }
} -after_submit {
   ad_returnredirect "equipment-reservation-details?[export_url_vars request_id]"
} -export {
    resource_id
    event_id
    context
    return_url
    title
    all_day_p
    repeat_template_p
    specific_days_week
    specific_days_month
    frequency_type
    frequency_day
    frequency_week
    frequency_month
    frequency_year
    specific_day_frequency
    specific_dates_of_month_month
    specific_dates_of_month_year
    specific_months
    repeat_month_opt1
    repeat_month_opt2
    repeat_end_date_opt
    event_code
    start_date_sql
    end_date_sql
    repeat_end_date_sql
    request_id
}
