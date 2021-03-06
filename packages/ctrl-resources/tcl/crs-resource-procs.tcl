# /packages/room-reservation/tcl/cr-resource-procs.tcl
ad_library {
    utilities for room reservation resources

    @author: Jianming He <jmhek@cs.ucla.edu>
    @creation-date: 12/01/05
    @cvs-id $Id: $
}

namespace eval crs::resource {}
namespace eval crs::reservable_resource {}

ad_proc -public crs::resource::rel_add {
    {-subsite_id:required}
    {-object_id:required}
} {
    create a new resource relation
    @param subsite_id
    @param object_id = resource_id
} {
    set error_p 0
    db_transaction {
        db_exec_plsql resource_rel_new {}
    } on_error {
        set error_p 1
    }
    if {$error_p} {
        ad_return_complaint 1 "There was a problem creating the resource relationship. Please try again."
        ad_script_abort
    }
}

ad_proc -public crs::resource::rel_del {
    {-rel_id:required}
} {
    delete a resource relation
    @param rel_id
} {
    set error_p 0
    db_transaction {
        db_exec_plsql resource_rel_del {}
    } on_error {
        set error_p 1
    }
    if {$error_p} {
        ad_return_complaint 1 "There was a problem deleting the resource relationship. Please try again."
        ad_script_abort
    }
}

ad_proc -public crs::resource::new {
    {-name:required}
    {-object_type "crs_resource"}
    {-resource_category_id:required}
    {-description ""}
    {-enabled_p "t"}
    {-services ""}
    {-property_tag ""}
    {-package_id 0}
    {-quantity 1}
    {-owner_id ""}
    {-parent_resource_id ""}
} {
    create a new non-reservable resource 
    @param name
    @param resource_category_id
    @param description
    @param enabled_p
    @param property_tag
    @param package_id
    @param quantity
    @param owner_id
    @param parent_resource_id
} {

    # create a new resource, get resource_id
    if {$package_id == 0} {
	set package_id [ad_conn package_id]
    }

    set var_list [list [list name $name] \
                       [list resource_category_id $resource_category_id] \
		       [list description $description] \
                       [list enabled_p $enabled_p] \
		       [list services $services] \
                       [list property_tag $property_tag] \
		       [list package_id $package_id] \
                       [list owner_id $owner_id] \
		       [list parent_resource_id $parent_resource_id] \
                       [list quantity $quantity]]

    # set object_type "ctrl_resource"
    set error_p 0
    db_transaction {
	set resource_id [package_instantiate_object -var_list $var_list $object_type]
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem creating this resource $errmsg"
	ad_script_abort
    }
    return $resource_id
}

ad_proc -public crs::reservable_resource::new {
    {-name:required}
    {-object_type "crs_reservable_resource"}
    {-resource_category_id:required}
    {-description ""}
    {-enabled_p "t"}
    {-services ""}
    {-property_tag ""}
    {-how_to_reserve ""}
    {-approval_required_p ""}
    {-address_id ""}
    {-department_id ""}
    {-floor ""}
    {-room ""}
    {-gis ""}
    {-package_id 0}
    {-quantity 1}
    {-owner_id ""}
    {-parent_resource_id ""}
} {
    create a new reservable resource
    @param name
    @param object_type
    @param resource_category_id
    @param description
    @param enable_p
    @param services
} {

    if {$package_id == 0} {
	set package_id [ad_conn package_id]
    }
    # create a new resource, get resource_id
    set var_list [list [list name $name] [list resource_category_id $resource_category_id] \
		      [list description $description] [list enabled_p $enabled_p] \
		      [list services $services] [list property_tag $property_tag] \
		      [list how_to_reserve $how_to_reserve] [list approval_required_p $approval_required_p] \
		      [list address_id $address_id] [list department_id $department_id] \
		      [list floor $floor] [list room $room] [list gis $gis] \
		      [list package_id $package_id] [list owner_id $owner_id] \
		      [list parent_resource_id $parent_resource_id] [list quantity $quantity]]
    # set object_type "ctrl_resource"
    set failed_p 0
    db_transaction {
	set resource_id [package_instantiate_object -var_list $var_list $object_type]
	set policy_id [crs::resv_resrc::policy::create_default -package_id $package_id -resource_id $resource_id]
    } on_error {
	set failed_p 1
    }
    if $failed_p {
	error $errmsg
    }
    return $resource_id
}

ad_proc -public crs::resource::update {
    {-resource_id:required}
    {-name}
    {-resource_category_id}
    {-description}
    {-enabled_p}
    {-services}
    {-property_tag}
    {-quantity 1}
    {-owner_id}
    {-parent_resource_id}
} {
    update resource info (both reservable and non-reservable)
    @param resource_id
    @param name
    @param resource_category_id
} {
    set error_p 0
    set update_list [list]
 
    set update_var_list [list name description resource_category_id enabled_p property_tag services \
			     quantity owner_id parent_resource_id]

    foreach var $update_var_list {
	if {[info exists $var]} {
	    lappend update_list " $var = :$var "
	}
    }

    if {[llength $update_list] > 0} {
	set update_string [join $update_list ", "]
    } else {
	set update_string ""
    }

    if {![empty_string_p $update_string]} {
	ctrl_procs::acs_object::update_object -object_id $resource_id
	db_dml update_resource {**SQL**}
    }
}

ad_proc -public crs::reservable_resource::update {
    {-resource_id:required}
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
    {-quantity 1}
    {-owner_id}
    {-parent_resource_id}
    {-new_email_notify_list}
    {-update_email_notify_list}
} {
    update reservable resource info
    @param resource_id
    @param name
    @param resource_category_id
} {
    set error_p 0

    set update_list [list]
    

    set update_resource_text ""
    set resource_list [list name description resource_category_id enabled_p services property_tag owner_id \
			   parent_resource_id quantity]
    foreach var $resource_list {
	if [info exists $var] {
	    append update_resource_text " -$var {[set $var]}"
	}
    }

    if ![empty_string_p $update_resource_text] {
	set update_resource_text "crs::resource::update -resource_id $resource_id $update_resource_text"
    }

    set update_var_list [list how_to_reserve approval_required_p department_id floor gis color reservable_p reservable_p_note special_request_p room new_email_notify_list update_email_notify_list]

    set update_list [list]
    foreach var $update_var_list {
	if {[info exists $var]} {
	    lappend update_list " $var = :$var "
	}
    }

    if {[llength $update_list] > 0} {
	set update_string_2 [join $update_list ", "]
    } else {
	set update_string_2 ""
    }
    set error_p 0
    db_transaction {
	ctrl_procs::acs_object::update_object -object_id $resource_id
	if ![empty_string_p $update_resource_text] {
	    eval $update_resource_text
	}
	if {[llength $update_list] > 0} {
	    db_dml update_reservable_resource {}
	}
    } on_error {
	set error_p 1
    }

    if $error_p {
	error $errmsg
    }
}


ad_proc -public crs::resource::delete {
    {-resource_id:required}
} {
    delete resource
    @param resource_id
} {
    set error_p 0
    set image_ids [db_list get_images {}]
    db_transaction {
	foreach image_id $image_ids {
	    crs::resource::delete_image -image_id $image_id
	}
	db_exec_plsql delete {}
    } on_error {
	set error_p 1
    }
    if {$error_p} {
	ad_return_complaint 1 "There was a problem deleting the resource. $errmsg"
	ad_script_abort
    }
}

ad_proc -public crs::resource::get {
    {-resource_id:required}
    {-column_array "resource"}
} {
    retrieve resource info
    @param resource_id
    @param column_array
} {
    upvar $column_array local_array
    db_0or1row get {} -column_array local_array
}

ad_proc -public crs::reservable_resource::get {
    {-resource_id:required}
    {-column_array "resv_resource_info"}
} {
    retrieve resource info
    @param resource_id
    @param column_array
} {
    upvar $column_array local_array
    db_0or1row get {} -column_array local_array
}

ad_proc -public crs::reservable_resource::delete {
    {-resource_id:required}
} {
    delete resource
    @param resource_id
} {
    set error_p 0
    set image_ids [db_list get_images {}]
    db_transaction {
	foreach image_id $image_ids {
	    crs::resource::delete_image -image_id $image_id
	}
	db_exec_plsql delete {}
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was a problem deleting the reservable resource. $errmsg"
	ad_script_abort
    }
}

ad_proc -public crs::resource::map {
    {-parent_resource_id:required}
    {-child_resource_id:required}
} {
    associate child resource to parent resource
    @param parent_resource_id
    @param child_resource_id
} {
    db_dml add_resource_map {}
}

ad_proc -public crs::resource::search {
    {-name}
    {-description}
    {-resource_category_id}
    {-services}
    {-property_tag}
} {
    search resource by keyword
    return in a list of resource_id
} {
    set where_list [list]
    if {[info exists name]} {
	lappend where_list " name = :name "
    }
    if {[info exists description]} {
	lappend where_list " description like %:name% "
    }
    if {[info exists resource_category_id]} {
	lappend where_list " resource_category_id = :resource_category_id "
    }
    if {[info exists services]} {
	lappend where_list " services like %:services% "
    }
    if {[info exists property_tag]} {
	lappend where_list " property_tag = :property_tag "
    }

    if {[llength $where_list] > 0} {
	set where_string [join $where_list "and "]
    } else {
	set where_string ""
    }

    set resource_ids [db_list search {}]
    return $resource_ids
}

ad_proc -public crs::resource::find_child_resources {
    {-resource_id:required}
} {
    find every child resource 
    @param resource_id
} {
    return [db_list get_child_resources {}]
}

ad_proc -public crs::reservable_resource::check_availability {
    {-resource_id:required}
    {-event_id ""}
    {-repeat_template_id ""}
    {-start_date:required}
    {-end_date:required}
    {-all_day_p}
} {
    check availability of a resource for an event
    @param resource_id
    @param exclude the current event_id from the check, useful when editing reservations and you want to check conflicts except your own
    @param start_date
    @param end_date
    @param all_day_p
} {
    if {![empty_string_p $event_id]} {
	set event_clause " and event_id!=:event_id"
    } else {
	set event_clause ""
    }

    if {![empty_string_p $repeat_template_id]} {
	set template_clause " and (repeat_template_id!=:repeat_template_id or repeat_template_id is null)"
    } else {
	set template_clause ""
    }

    return [db_string check {} -default 1]
}

ad_proc -public crs::resource::add_image {
    {-resource_id:required}
    {-resource_image:required}
    {-image_name ""}
} {
    add image to the resource
    @param resource_id
    @param resource_image
} {

    set content_tmpfilename [ns_queryget resource_image.tmpfile]
    set image_file_type [ns_guesstype $resource_image]
    set extension [string tolower [file extension $resource_image]]


    # determining the dimensions of the image
    if {[string equal $extension ".jpeg"] || [string equal $extension ".jpg"] || [string equal $extension ".jpe"]} {
	catch { set dimensions [ns_jpegsize $content_tmpfilename] }
    } elseif {[string equal $extension ".gif"]} {
	catch { set dimensions [ns_gifsize $content_tmpfilename]}
    }

    if {[exists_and_not_null dimensions]} {
	set image_width [lindex $dimensions 0]
	set image_height [lindex $dimensions 1]
    } else {
	set image_width ""
	set image_height ""
    }

    if {[empty_string_p $image_name]} {
	set temp [split $resource_image "\\"]
	set image_name [lindex $temp [expr [llength $temp] - 1]]
    }

    if {![empty_string_p $image_width] && ![empty_string_p $image_height]} {
       db_transaction {
   	  set image_id [db_exec_plsql add_image {}]
          db_dml image_upload {} -blob_files [list $content_tmpfilename]
       }
    }
}

ad_proc -public crs::resource::delete_image {
    {-image_id:required}
} {
    delete the image
} {
    db_exec_plsql delete_image {}
}


ad_proc -public crs::resource::get_resource_categories {
    {-package_id ""}
    {-top_label ""}
    {-top_value ""}
} {
    return categories of general resource
} {
    set path "//Equipment Types"
    return [crs::ctrl::category::option_list -path $path -package_id $package_id]	
}

ad_proc -public crs::resource::get_ctrl_addresses {

} {
    return list of addresses
} {
    set address_list [db_list_of_lists get_address_lists {}]
    set address_options [list]

    foreach address $address_list {
	set address_id [lindex $address 0]
	set description [lindex $address 1]
	set address_line_1 [lindex $address 2]
	set listing_options "$descripton; $address_line_1"
	lappend address_options [list $listing_options $address_id]
    }
    return $address_options
}
