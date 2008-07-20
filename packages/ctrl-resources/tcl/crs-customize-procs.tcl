ad_library {

    @author KH
    @cvs-id $Id$
    @creation-date 2006-08-02
}

namespace eval crs::customize {}


ad_proc -public crs::customize::get_user_most_resv_room {
    -package_id
    -user_id 
} {
    Returns the list of the most recent rooms reserved by user
} {
    if ![info exists package_id] {
	set package_id [ad_conn package_id]
    }
    if ![info exists user_id] {
	set user_id [ad_conn user_id]
    }
    set max_list_count [parameter::get -package_id $package_id -parameter user_recent_room_count -default 3]
    return [util_memoize "crs::customize::get_most_reserved_list -package_id $package_id -type room -user_id $user_id -no_row $max_list_count"]
}

ad_proc -public crs::customize::get_pkg_most_resv_room {
    -package_id
} {
    if ![info exists package_id] {
	set package_id [ad_conn package_id]
    }
    set max_list_count [parameter::get -package_id $package_id -parameter pkg_recent_room_count -default 3]
    return [util_memoize "crs::customize::get_most_reserved_list -package_id $package_id -type room  -no_row $max_list_count"]
}



ad_proc -private crs::customize::get_most_reserved_list {
    -type:required 
    -package_id
    -user_id
    -after_date
    {-no_row 3} 
} {

    /** TODO: 
        Add support for the type field to search only reservable equipments
    **/
    Returns a list of resources that have been reserved the most. Each element is a list of room_id and room_name
    preceding one.  

    @param package_id the package
    @param user_id the user that made the reservation
    @param after_date factor only reservations after this date, the date format is yyyy-mm-dd
    @param type room or equipment 
    @param no_row the max number to return
} {

    if ![info exists package_id] {
	set package_id [ad_conn package_id]
    }

    if ![info exists subsite_id] {
        set subsite_id [ad_conn subsite_id]
    }

    set filter_list [list]
    if [info exists user_id] {
	lappend filter_list [db_map user_filter]
    }

    if [info exists after_date] {
	lappend filter_list [db_map after_date_filter]
    }
    if {[llength $filter_list] > 0} {
	set filter_sql "and [join $filter_list " and "]"
    } else {
	set filter_sql ""
    }

    set return_list [list]
    db_foreach get {**SQL**} {
	set list [split $room_id_name "|"]

	lappend return_list [list [lindex $list 0] [lindex $list 1]] 
    }
    return $return_list
}
