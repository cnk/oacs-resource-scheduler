# /packages/room-reservation/tcl/crs-room-procs.tcl
ad_library {
    utilities for room reservation rooms

    @author: Jianming He <jmhek@cs.ucla.edu>
    @creation-date: 12/01/05
    @cvs-id $Id: $
}

namespace eval crs::room {}

ad_proc -public crs::room::new {
    {-name:required}
    {-object_type "crs_room"}
    {-resource_category_id:required}
    {-description ""}
    {-enabled_p "t"}
    {-services ""}
    {-property_tag ""}
    {-owner_id ""}
    {-parent_resource_id ""}
    {-how_to_reserve ""}
    {-approval_required_p ""}
    {-address_id ""}
    {-department_id ""}
    {-floor 0}
    {-room 0}
    {-gis ""}
    {-color ""}
    {-reservable_p "t"}
    {-reservable_p_note ""}
    {-special_request_p "f"}
    {-capacity ""}
    {-dimensions_width ""}
    {-dimensions_length ""}
    {-dimensions_height ""}
    {-dimensions_unit ""}
    {-new_email_notify_list ""}
    {-update_email_notify_list ""}
    {-package_id 0}
    {-creation_user 0}
    {-context_id ""}
} {
    create a new room
    @param room_id
    @param capacity
    @param demension_width
    @param demension_length
    @param demension_height
    @param demension_unit
} {
    if {$package_id == 0} {
	set package_id [ad_conn package_id]
    }
    if {$creation_user == 0} {
	set creation_user [ad_conn user_id]
    }
    if {[empty_string_p $context_id]} {
	set context_id [ad_conn package_id]
    }
    
    set error_p 0
    db_transaction {
	set room_id [db_exec_plsql room_new {}]
	set policy_id [crs::resv_resrc::policy::create_default -package_id $package_id -resource_id $room_id]
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint 1 "There was a problem creating the room. Please try again."
	ns_log notice "--- ERROR:  Problem creating room : $errmsg ---"
	ad_script_abort
    }
    
    return $room_id
}

ad_proc -public crs::room::update {
    {-room_id:required}
    {-name}
    {-resource_category_id}
    {-description}
    {-enabled_p}
    {-services}
    {-property_tag}
    {-how_to_reserve}
    {-approval_required_p}
    {-address_id}
    {-department_id}
    {-floor}
    {-room}
    {-gis}
    {-color}
    {-reservable_p}
    {-reservable_p_note}
    {-special_request_p}
    {-capacity}
    {-dimensions_width}
    {-dimensions_length}
    {-dimensions_height}
    {-dimensions_unit}
    {-new_email_notify_list}
    {-update_email_notify_list}
} {
    update room info
    @param room_id
} {
    # update reservable resource
    set error_p 0

    set update_list [list]
    set update_resource_text ""
    set resv_resource_count 0
    
    # ----------------------------------------------
    # construct string to call reservable_resource update
    # --------------------------------------------------
    set resv_resource_list [list name description resource_category_id enabled_p services property_tag \
				how_to_reserve approval_required_p address_id department_id \
				floor room gis color reservable_p reservable_p_note special_request_p \
                                new_email_notify_list update_email_notify_list]
    foreach var $resv_resource_list {
	if [info exists $var] {
	    append update_resource_text " -$var {[set $var]}"
	}
    }
    if ![empty_string_p $update_resource_text] {

	set update_resource_text "crs::reservable_resource::update -resource_id $room_id $update_resource_text"
    } 

    # -------------------------------------------------
    # build list of columns to update
    # --------------------------------------------------
    set update_var_list [list capacity dimensions_width dimensions_length dimensions_height dimensions_unit]
    set update_list [list]
    foreach var $update_var_list {
	if [info exists $var] {
	    lappend update_list " $var = :$var "
	}
    }

    if {[llength $update_list] > 0} {
	set update_string [join $update_list ", "]
    } else {
	set update_string ""
    }

    db_transaction {
	ctrl_procs::acs_object::update_object -object_id $room_id
	if {![empty_string_p $update_resource_text]} {
	    eval $update_resource_text
	}
	if {[llength $update_list] > 0} {
	    db_dml update_room {}
	}

    } on_error {
	set error_p 1
    }
    if {$error_p} {
	error $errmsg
    }

}


ad_proc -public crs::room::delete {
    {-room_id:required}
} {
    delete room and corresponding resource
    @param room_id
} {
    set error_p 0
    set image_ids [db_list get_images {}]
    set event_ids [db_list get_events {}]
    if {![empty_string_p $event_ids]} {
	ad_return_error "error" "There are event(s) $event_ids associated with this room. Please go back delete the event(s) first."
	ad_script_abort
    }

    db_transaction {
	# should toggle enable_p instead of deleting
	#foreach event_id $event_ids {
	#    crs::event::delete -event_id $event_id
	#}

	foreach image_id $image_ids {
	    crs::resource::delete_image -image_id $image_id
	}
	ctrl::subsite::object_rel_del -object_id $room_id
	db_exec_plsql delete_room {}
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	error $errmsg
    }
}


ad_proc -public crs::room::get {
    {-room_id:required}
    {-column_array "room"}
} {
    retrieve room info
} {
    upvar $column_array local_array
    db_0or1row get {} -column_array local_array
}

ad_proc -public crs::room::map {
    {-room_id:required}
    {-resource_id:required}
} {
    add a resource into a room
    call crs::resource::map
} {
    crs::resource::map -parent_resource_id $room_id -child_resource_id $resource_id
}

ad_proc -public crs::room::get_room_categories {
    {-package_id ""}
    {-top_label ""}
    {-top_value ""}
} {
    return categories of room
} {
    set path "//Room Types"
    return [crs::ctrl::category::option_list -path $path -package_id $package_id -top_label $top_label -top_value $top_value]
}


ad_proc -public crs::room::is_room_p {
    {-resource_id:required}
} {
    Return 1 if this resource is a room, 0 otherwise
} {
    return [db_string check {} -default 0]
}
 




