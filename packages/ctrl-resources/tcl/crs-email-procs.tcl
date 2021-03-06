# /packages/ctrl-resources/tcl/crs-email-procs.tcl

ad_library {

    Procs for handling crs emails
    
    @author avni@ctrl.ucla.edu
    @creation-date 06/22/2006
    @cvs-id $Id$
}

namespace eval crs::email {}

ad_proc -public crs::email::send {
    {-to_user:required}
    {-from_user:required}
    {-subject:required}
    {-body:required}
} {
    Send an email out
} {    
    set extraheaders ""

    if {[ad_looks_like_html_p $body]} {
        set extraheaders [ns_set create]
        ns_set put $extraheaders "Content-type" "text/html" 
    }
    if [catch {ns_sendmail $to_user $from_user $subject $body $extraheaders} errmsg] {
	error "There was an error sending email:<p>$errmsg"
    }
    return
}

ad_proc -public crs::email::notify_admin_of_request {
    {-request_id:required}
    {-action "new"}
    {-adp_template "/packages/ctrl-resources/resources/email-text-admin.adp"}
} {
    Notify Admin of Reservation Creation or Modification
} {
    set adp_template "[acs_root_dir]$adp_template"

    crs::request::get -request_id $request_id -column_array request_info   
#    set test [crs::request::get -request_id $request_id -column_array request_info]
#    if !{$test} {
#	ad_return_complaint 1 $request_id
#	ad_script_abort
#    }

    set request_name $request_info(name)
    set request_status $request_info(status)

    switch $action {
	new {
	    set subject "[string totitle $request_status] Reservation Creation: $request_name"
	    set action_verb "created"
	    set notification_var "new_email_notify_list"
	}
	update {
	    set subject "[string totitle $request_status] Reservation Modification: $request_name"
	    set action_verb "modified"
	    set notification_var "update_email_notify_list"
	}
	default {
	    error "Invalid action passed to the proc"
	    return
	}
    }

    set resource_id [crs::request::get_room_for_request -request_id $request_id]
    if {!$resource_id} {
	set resource_id [lindex [crs::request::get_non_room_resources -request_id $request_id] 0]
    } 

    crs::reservable_resource::get -resource_id $resource_id -column_array "resource_info"
    set notification_list [split $resource_info($notification_var) ","]
    
    set from_user "[ad_system_owner]"
    
    #set url "[ctrl::subsite::best_url]resources/reservation-details?[export_url_vars request_id]"
    #set url "[ctrl::subsite::best_url]reservation-details?[export_url_vars request_id]"
    set url "[util_current_location][ad_conn package_url]reservation-details?[export_url_vars request_id]"
    set body "The following request has been $action_verb."

    if {![string equal "$request_status" "pending"]} {
	append body "It requires approval in order to be scheduled. "
    }

    set body [template::adp_compile -file $adp_template]
    set body [template::adp_eval body]

    foreach to_user $notification_list {
	set to_user [string trim $to_user]
	if {[util_email_valid_p $from_user] && [util_email_valid_p $to_user]} {
	    ns_log notice "CRS -> SENDING RESERVATION EMAIL; FROM - $from_user; TO - $to_user SUBJECT - $subject"
	    crs::email::send -to_user $to_user -from_user $from_user -subject $subject -body $body
	}
    }

    return
}

ad_proc -public crs::email::notify_user_of_request {
    {-request_id:required}
    {-action "update"}
    {-adp_template "/packages/ctrl-resources/resources/email-text-user.adp"}
} {
    Notify User of Reservation Creation or Modification
} {
    set adp_template "[acs_root_dir]$adp_template"

    set test [crs::request::get -request_id $request_id -column_array request_info]
    if !{$test} {
	ad_return_complaint 1 $request_id
	ad_script_abort
    }

    set request_name $request_info(name)
    set request_description $request_info(description)

    switch $action {
	creation {
	    set subject "[string totitle $request_info(status)] Reservation Creation: $request_name"
	    set action_verb "created"
	    set notification_var "new_email_notify_list"
	}
	update {
	    set subject "[string totitle $request_info(status)] Reservation Modification: $request_name"
	    set action_verb "modified"
	    set notification_var "update_email_notify_list"
	}
	delete {
	    set subject "Reservation Deletion: $request_name"
	    set action_verb "deleted"
	    set notification_var "update_email_notify_list"
	}
	default {
	    error "Invalid action passed to the proc"
	    return
	}
    }

    set reserved_by_id $request_info(reserved_by_id)
    set reserved_by_email [cc_email_from_party $reserved_by_id]

    set resource_id [crs::request::get_room_for_request -request_id $request_id]
    
    if {!$resource_id} {
	set resource_id [lindex [crs::request::get_non_room_resources -request_id $request_id] 0]
    } 
    
    crs::reservable_resource::get -resource_id $resource_id -column_array "resource_info"
    set notification_list $resource_info($notification_var)
    
    set from_user "[ad_system_owner]"
    set to_user "$reserved_by_email"

    set url "[util_current_location][ad_conn package_url]reservation-details?[export_url_vars request_id]"

    set body [template::adp_compile -file $adp_template]
    set body [template::adp_eval body]

    if {[util_email_valid_p $from_user] && [util_email_valid_p $to_user]} {
	crs::email::send -to_user $to_user -from_user $from_user -subject $subject -body $body
    }

    return
}

ad_proc -public crs::email::test2 {
    {-request_id:required}
    {-action "new"}
    {-adp_template "/packages/ctrl-resources/resources/email-text-admin.adp"}
} {
    Notify Admin of Reservation Creation or Modification
} {
    set url "[util_current_location][ad_conn package_url]reservation-details?[export_url_vars request_id]"
    return $url
}
