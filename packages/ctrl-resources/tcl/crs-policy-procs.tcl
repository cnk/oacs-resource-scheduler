ad_library {
    Procs to define policies for reservable resources 

    @author KH
    @cvs-id $Id$
    @creation-date 2006-06-13
}

namespace eval crs::resv_resrc::policy {} 

ad_proc -public crs::resv_resrc::policy::new_id {} {
    Allocates a new policy id
} {
    return [db_nextval crs_resv_policy_seq]
}

ad_proc -public crs::resv_resrc::policy::add {
    {-policy_id ""}
    -resource_id:required
    -policy_name:required 
    {-latest_resv_date ""} 
    {-time_interval_after_resv_date 0}
    {-time_interval_before_start_dte 0}
    {-resv_period_before_start_date 0}
    {-priority_level 0}
    {-all_day_period_start ""}
    {-all_day_period_end ""}
    -user_id
} {
    Create a policy for a particular resource. The proc does not check whether 
    the fields are consistent. 

    @param policy_id the policy id
    @param resource_id the resource id
    @param policy_name the policy name
    @param latest_resv_date the latest date that reservations maybe made, if 
           not value is passed in then 5 years is set as the default.
    @param time_interval_after_resv the time interval that a reservation maybe 
           modified. A 0 value indicates that this field is not used.
    @param time_interval_before_start_date the time interval prior to the start
           date that a reservation maybe modified
    @param resv_period_start_date new reservations are allowed up to the time 
           period before the start date
    @return the policy id if successful, throws an error otherwise
} {
    
    if ![info exists user_id] {
	set user_id [ad_conn user_id]
    }
    if [empty_string_p $policy_id] {
	set policy_id [new_id]
    }
    db_dml insert_row {**SQL**}
    
    return $policy_id
}


ad_proc -public crs::resv_resrc::policy::update {
    -policy_id:required
    -policy_name
    -latest_resv_date
    -time_interval_after_resv_date
    -time_interval_before_start_dte
    -resv_period_before_start_date
    -priority_level
    -all_day_period_start
    -all_day_period_end
    -user_id
} {
    Update the policy information

    @param policy_id the policy to update
    @param policy_name update policy name to this
    @param latest_resv_date the latest date the future to allow reservations
    @param time_interval_after_resv_date the time interval that a reservation 
           maybe modified. A 0 value indicates that this field is not used.
    @param time_interval_before_start_dte the time interval prior to the start
           date that a reservation maybe modified
    @param resv_period_before_start_date new reservations are allowed up to the time 
           period before the start date
    @return the policy id if successful, throws an error otherwise
} {
    if ![info exists user_id] {
	set user_id [ad_conn user_id]
    }

    set field_update_list [list {policy_name policy_name} {latest_resv_date latest_resv_date} \
			       {time_interval_after_rsv_dte time_interval_after_resv_date} \
			       {time_interval_before_start_dte time_interval_before_start_dte} \
			       {resv_period_before_start_date resv_period_before_start_date} \
			       {priority_level priority_level} {all_day_period_start all_day_period_start} \
			       {all_day_period_end all_day_period_end} ]

    set update_list [list]
    foreach field_info $field_update_list {
	set column_name [lindex $field_info 0]
	set field_name [lindex $field_info 1]
	if [info exists $field_name] {
	    if {[string equal $field_name all_day_period_start] || [string equal $field_name all_day_period_end]} {
		lappend update_list "$column_name = [set $field_name]"
	    } else {
		lappend update_list "$column_name = :$field_name"
	    }
	}
    }

    if {[llength $update_list]  < 1} {
	error "At least one of the fields must be updated"
    }

    db_dml update_row {**SQL**}
    return $policy_id
}

ad_proc -public crs::resv_resrc::policy::get {
    -by:required
    -policy_id
    -resource_id
    -policy_name 
    {-column_array policy_info}
} {
    Search for the policy info either by "id" or "name"
    if id is specified then policy id is required otherwise
    if name is specified then resource_id and policy_name 

    @return 1 if exist and  the policy and place the values in column_array 
            0 otherwise
    @param by search policy by id or name
    @param policy_id the policy id
    @param resource_id the resource id
    @param policy_name the policy name
} {
    upvar $column_array policy_info

    switch $by {
	"id" {
	    if ![info exists policy_id] {
		error "The policy id parameter is required"
	    }
	    set where_clause "policy_id = :policy_id"
	    set result [db_0or1row retrieve {**SQL**} -column_array policy_info]
	}
	"name" {
	    if {![info exists resource_id] || ![info exists policy_name]}  {
		error "The resource id and policy name is required"
	    }
	    set where_clause "resource_id = :resource_id and policy_name = :policy_name"
	    set result [db_0or1row retrieve {**SQL**} -column_array policy_info]
	}
	default {
	    error "Valid values for by are 'id' or 'policy_name'"
	}
    }
    return $result
}


ad_proc -private crs::resv_resrc::policy::create_default {
    -package_id:required
    -resource_id:required
} {
    Creates a default policy for the reservable resource
} {

    # Creates the default policy for a resource
    set time_interval_after_resv_date [parameter::get -package_id $package_id \
					   -parameter time_interval_after_resv_date \
					   -default 0]
    set time_interval_before_start_date [parameter::get -package_id $package_id \
					     -parameter time_interval_before_start_date \
					     -default 0]
    set resv_period_before_start_date [parameter::get -package_id $package_id \
					   -parameter resv_period_before_start_date \
					   -default 0]
    set priority_level [parameter::get -package_id $package_id -parameter policy_priority_level \
			    -default 0]
    
    set policy_id [crs::resv_resrc::policy::add -resource_id $resource_id \
		       -policy_name default -time_interval_after_resv_date  $time_interval_after_resv_date \
		       -time_interval_before_start_dte $time_interval_before_start_date \
		       -resv_period_before_start_date $resv_period_before_start_date \
		       -priority_level $priority_level]
    return $policy_id
}


ad_proc -public crs::resv_resrc::policy::assign_to_group {
    -group_id:required
    -policy_id:required
    {-user_id ""}
} {
    Assign the policy to the group

    @param group_id the group id
    @param policy_id the policy
    @return 1 if successful,  error otherwise
} {
    if [empty_string_p $user_id] {
	set user_id [ad_conn user_id]
    }

    # -- Assign policy to group if it is not assigned yet
    set exist_p [db_string group_with_policy {**SQL**} -default 0]
    if !$exist_p {
	set failed_p 0
	db_transaction {
	    db_dml add_policy_to_group {**SQL**} 
	} on_error {
	    set exist_p [db_string group_with_policy {**SQL**} -default 0]
	    if !$exist_p {
		set failed_p 1
	    }
	}
	if $failed_p {
	    error $errmsg
	}
    }
    return 1
}

ad_proc -public crs::resv_resrc::policy::remove_from_group {
    -group_id:required
    -policy_id:required

} {
    Remove the policy from the group

    @param group_id the group id
    @param policy_id the policy
    @return 1 if successful,  error otherwise
} {
    db_dml unassign_policy_group {**SQL**}
}

ad_proc -public crs::resv_resrc::policy::check_compliance {
    -user_id:required
    -resource_id:required
    -request_date:required
    -reservation_start_date:required
    -reservation_end_date:required
    {-action "new"}
} {
    check compliance of reservation with policy
    
    @param group_id
    @param resource_id
    @param request_date
    @param reservation_start_date
    @param reservation_end_date
} {
    set policy_id [db_exec_plsql get_policy {}]

    if {[exists_and_not_null policy_id]} {
	set flag [db_exec_plsql check_compliance {}]
	return $flag
    } else {
	return 1
    }
}
