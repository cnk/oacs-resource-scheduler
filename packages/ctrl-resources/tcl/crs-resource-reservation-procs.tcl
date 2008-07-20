# /packages/room-reservation/tcl/crs-resource-reservation-procs.tcl
ad_library {
    Utilities for room reservation policy/conflict checking

    @author: Kellie (kellie@ctrl.ucla.edu)
    @creation-date: 09/29/2006
    @cvs-id $Id: $
}

namespace eval crs::resource::reservation {}

#This finds conflicted reservations
ad_proc -public crs::resource::reservation::previous_reservation {
    {-start_date:required}
    {-end_date:required}
    {-room_id:required}
} {
    check for conflicted reservations
    return conflicted values: request_id, reserver_name, reserver_email
} {    
    set prev_reservations [db_list_of_lists get_prev_reservations {}]
    set conflicting_request_id [list]
    set conflicting_reserver_name [list]
    set conflicting_reserver_email [list]
    
    #get all the conflicting person
    foreach conflict_list $prev_reservations {
	lappend conflicting_request_id [lindex $conflict_list 1]
	lappend conflicting_reserver_name [person::name -person_id [lindex $conflict_list 0]]
	lappend conflicting_reserver_email [cc_email_from_party [lindex $conflict_list 0]]
    }
    return [list $conflicting_request_id $conflicting_reserver_name $conflicting_reserver_email]
}

ad_proc -public crs::resource::reservation::check_internal_equipment {
    {-start_date_sql:required}
    {-end_date_sql:required}
    {-room_eq_check:required}
    {-already_reserved_eq:required}
} {
    
} {
    #For each piece of internal equipment, display conflicts and remove conflicting entries from the list
    set internal_eq_list [list]
    set items_to_remove [list]

    foreach res_id $room_eq_check {
	crs::resource::get -resource_id $res_id -column_array "res_info"
	lappend internal_eq_list $res_info(name)

	if {[lsearch $already_reserved_eq $res_id] != -1 || \
	    [crs::reservable_resource::check_availability -resource_id $res_id -start_date $start_date_sql -end_date $end_date_sql]} {
	    #item is available
	} else {
	    #item is not available
	    lappend items_to_remove $res_id
	}
    }
    
    return [list $internal_eq_list $items_to_remove]
}

ad_proc -public crs::resource::reservation::check_external_equipment {
    {-start_date:required}
    {-end_date:required}
    {-gen_eq_check:required}
} {
 
} {
    #For each piece of external equipment, display conflicts and remove conflicting entries from the list
    set external_eq_list [list]
    set items_to_remove [list]

    foreach res_id $gen_eq_check {
	crs::resource::get -resource_id $res_id -column_array "res_info"
	if {[lsearch $already_reserved_eq $res_id] != -1 || \
	    [crs::reservable_resource::check_availability -resource_id $res_id -start_date $start_date_sql -end_date $end_date_sql]} {
	    #item is available
	    lappend external_eq_list $res_info(name)
	} else {
	    #item is not available
	    lappend external_eq_list "$res_info(name) (<font color=red>This item is not available in your specified period </font> )"
	    lappend items_to_remove $res_id
	}
    }

    return [list $external_eq_list $items_to_remove]
}
