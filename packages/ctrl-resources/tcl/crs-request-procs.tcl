# /packages/ctrl-resources/tcl/crs-request-procs.tcl
ad_library {
    utilities for requesting resources

    @author: Jeff Wang (jcwang@cs.ucsd.edu)
    @creation-date: 12/12/05
    @cvs-id $Id: $
}

namespace eval crs::request {}

ad_proc -public crs::request::exists_p {
    {-request_id:required} 
} {
    Return 1 if request exists
    Return 0 if it doesn't
} {
    return [db_string exists_p {} -default 0]
}

ad_proc -public crs::request::new {
    {-request_id:required}
    {-repeat_template_id ""}
    {-repeat_template_p "f"}
    {-name:required}
    {-description ""}
    {-status "pending"}
    {-reserved_by ""}
    {-requested_by ""}
    {-package_id ""}
    {-context_id ""}
} {
    Create a new request
} {

    if {[empty_string_p $reserved_by]} {
	set reserved_by [ad_conn user_id]
    }
    if {[empty_string_p $requested_by]} {
	set requested_by [ad_conn user_id]
    }

    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }
    if [empty_string_p $context_id] {
	set context_id $package_id
    }
    set error_p 0
    db_transaction {
	#add a new request
	set request_id [db_exec_plsql new_request {}]
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint 1 "There was a problem adding your request.  Please try again. $errmsg"
	ns_log notice "---ERROR: Problem adding request in crs::request::new .  The error was $errmsg. ---"
	ad_script_abort
    }

    return $request_id
}

ad_proc -public crs::request::add_resv {
    {-request_id:required}
    {-name:required}
    {-status "pending"}
    {-reserved_by ""}
    {-date_reserved "sysdate"}
    {-event_code ""}
    {-resv_resource_id:required}
    {-start_date:required}
    {-end_date:required}
    {-all_day_p:required}
    {-notes:required ""}
} {
    Add an reservation to this request
    @return 1 , otherwise throw an error
} {
    # check that request is still in pending mode
    get -request_id $request_id -column_array request_info
    if ![string equal $request_info(status) "pending"] {
	error "Unable to add reservation because request is in '$request_info(status)' state"
    }
    if [crs::request::check_conflict -resv_resource_id $resv_resource_id -start_date $start_date -end_date $end_date] {
	error "Conflicting reservation exist"
    }

    set event_id [crs::event::new \
		      -request_id $request_id\
		      -status $status\
		      -date_reserved $date_reserved\
		      -event_code $event_code\
		      -reserved_by $reserved_by\
		      -object_requested $reservable_resource_id \
		      -name $name\
		      -start_date $start_date\
		      -end_date  $end_date\
		      -all_day_p $all_day_p\
		      -notes $notes]
    return $event_id
}


ad_proc -public crs::request::check_conflict {
    {-resv_resource_id:required}
    {-all_day_p:required}
    {-start_date:required}
    {-all_day_date ""}
    {-end_date:required}
    {-ignore_event_id ""}
} {
    Check if there is an conflict when adding a reservation for a resource
    @param resv_resource_id
    @param start_date - date format "yyyy-mm-dd hh24:mi"
    @param end_date - date format "yyyy-mm-dd hh24:mi"
    @param ignore_event_id - ignore a specific event_id when checking for conflicts
    @return 1 if conflicts, 0 none
} {
ns_log notice "END DATE==>$end_date"

    if {$all_day_p} {
	set exist_p [db_string resv_exist_all_day_p {} -default 0]
    } else {
	set exist_p [db_string resv_exist_p {} -default 0]
    }
    return $exist_p
}


ad_proc -public crs::request::delete {
    {-request_id:required}
} {
    Delete this request and all of it's events
} {
    set event_list [db_list get_events {}]
    db_transaction {
	foreach event_id $event_list {
	    crs::event::delete -event_id $event_id
	}
	db_exec_plsql do_delete {}
    }
}

ad_proc -public crs::request::get {
    {-request_id:required}
    {-column_array "request"}
} {
    retrieve request info
    @param request_id
    @param column_array
} {

    upvar $column_array local_array
    set selection [db_0or1row get_info {} -column_array local_array]
    if {!$selection} {
	return 0
    } else {
	return 1
    }
}

ad_proc -public crs::request::update {
    {-request_id:required}
    {-name ""}
    {-description ""}
    {-status ""}
    {-reserved_by ""}
    {-requested_by ""}
} {
    Update request information

} {

    if {[empty_string_p $reserved_by]} {
	set reserved_by [ad_conn user_id]
    }
    if {[empty_string_p $requested_by]} {
	set requested_by [ad_conn user_id]
    }

    set error_p 0
    db_transaction {
	db_dml update_request {}
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint "There was a problem updating the request. Please try again."
	ns_log notice "---ERROR: Problem updating status .  The error was $errmsg. ---"
	ad_script_abort
    }

    ### SEND EMAIL IF NECESSARY TO ADMIN	
    #if {[string equal $status "pending"]} {
    #	crs::email::notify_admin_of_request -request_id $request_id -action "update"
    #}
    ### SEND EMAIL TO RESERVER OF CHANGES
    crs::email::notify_user_of_request -request_id $request_id -action "update"

}

ad_proc -public crs::request::update_status {
    {-request_id:required}
    {-status:required}
} {
    Update the status of this request

    @param status pending, approve, deny,cancelled
} {
    set error_p 0
    db_transaction {
	db_dml do_update {}
	db_dml do_event_update {}
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint "There was a problem updating the status. Please try again."
	ns_log notice "---ERROR: Problem updating status .  The error was $errmsg. ---"
	ad_script_abort
    }

    ### SEND EMAIL IF NECESSARY TO ADMIN	
    if {[string equal $status "pending"] || [regexp cnsi [subsite::get_url]]} {
	crs::email::notify_admin_of_request -request_id $request_id -action "update"
    }
    ### SEND EMAIL TO RESERVER OF CHANGES
    crs::email::notify_user_of_request -request_id $request_id -action "update"

    return
}

ad_proc -public crs::request::get_room_for_request {
    {-request_id:required}
} {
    Get the room_id for this request
} {
    return [db_string get_room {} -default 0]
}

ad_proc -public crs::request::get_non_room_resources {
    {-request_id:required}
} {
    Get all the non-room reservable resources for this room
} {
    return [db_list get_res {}]
}

ad_proc -public crs::request::get_repeat_template_id {
    {-request_id:required}
} {
    Get repeat_template_id based on request id
} {
    return [db_string get_repeat_template_id {}]
}
