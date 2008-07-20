# /packages/ctrl-events/tcl/ctrl-event-object-procs.tcl

ad_library {
    
    Procedures to insert, edit, delete CTRL Event Objects
    
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/05/2005
    @cvs-id $Id: ce-object-procs.tcl,v 1.4 2006/11/29 23:16:24 kellie Exp $
} 

namespace eval ctrl_event::object {}

ad_proc -public ctrl_event::object::new {
    {-event_object_id:required}
    {-name:required}
    {-object_type_id:required}
    {-description ""}
    {-url ""}
    {-image ""}
    {-creation_ip ""}
} {
    Add a new ctrl_event object
    
    @param event_object_id
    @param name
    @param object_type_id
    @param description
    @param url
    @param image
} {
    set error_p 0
    
    db_transaction {
	set context_id [ad_conn package_id]
	set context_id [ad_conn package_id]
	set event_object_id [db_exec_plsql add {}]
	if {![empty_string_p $image]} {
	    ctrl_event_image::ctrl_event_object_image -event_object_id $event_object_id -image $image
	}
	
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error "$errmsg"
    }

    return $event_object_id
}

ad_proc -public ctrl_event::object::update {
    {-event_object_id:required}
    {-name:required}
    {-object_type_id:required}
    {-description ""}
    {-url ""}
    {-image ""}
} {
    Update a ctrl_event_object object

    @param event_object_id
    @param name
    @param object_type_id
    @param description
    @param url
    @param image
} {
    set error_p 0    
    db_transaction {
	ctrl_procs::acs_object::update_object -object_id $event_object_id
	db_dml update {}

	if {![empty_string_p $image]} {
	    ctrl_event_image::ctrl_event_object_image -event_object_id $event_object_id -image $image
	}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }
}

ad_proc -public ctrl_event::object::delete {
    {-event_object_id:required}
} {
    Delete a ctrl_event object

    @param event_object_id
} {
    set error_p 0
    db_transaction {
	db_dml remove_mapping {}	
	db_exec_plsql remove {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }    
}

ad_proc -public ctrl_event::object::map {
    {-event_object_id:required}
    {-event_id:required}
    {-tag:required}
} {
    Map an event object to an event

    @param event_object_id
    @param event_id
} {
    set error_p 0
    db_transaction {
	db_dml add {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }        
}

ad_proc -public ctrl_event::object::unmap {
    {-event_object_id:required}
    {-event_id:required}
} {
    Unmap an event object to an event
    @param event_object_id
    @param event_id
} {
    set error_p 0
    db_transaction {
	db_dml remove {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }        
}

ad_proc -public ctrl_event::object::map_update {
    {-event_object_id:required}
    {-event_id:required}
    {-tag:required}
} {
    Map an event object to an event

    @param event_object_id
    @param event_id
} {
    set error_p 0
    db_transaction {
	db_dml update {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }        
}

ad_proc -public ctrl_event::object::image_display {
    {-event_object_id:required}
} {
    Return the image, if any
} {
    set package_url [site_node_closest_ancestor_package_url -package_key ctrl-events -default "/events/"]

    set selection [db_0or1row image_display {}]

    if {!$selection} {
	return ""
    } else {
        set image ""
        if {![empty_string_p $image_height] && ![empty_string_p $image_width]} {	    
            append image "<img width=[expr $image_width] height=[expr $image_height] src=$package_url/object-image-display?[export_url_vars event_object_id] border=0>"
        }
	return $image
    }
}

ad_proc -public ctrl_event::object::image_delete {
    {-event_object_id:required}
} {
    Delete an image
} {
    set error_p 0
    db_transaction {
	db_dml image_delete {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	error $errmsg
    }
}

ad_proc -public ctrl_event::object::unique_p {
    {-name:required}
    {-object_type_id:required}
    {-event_object_id:required}
} {
    Check for unique name and object
} {
    return [db_string check_unique {} -default 0]
}

ad_proc -public ctrl_event::object::unique_tag_p {
    {-event_id:required}
    {-event_object_id:required}
    {-tag:required}
} {
    Check for unique name and object
} {
    return [db_string check_unique {} -default 0]
}

ad_proc -public ctrl_event::object::tag {
    {-event_id:required}
    {-event_object_id:required}
} {
    Return Tag for event object if mapping exists
} {
    return [db_string tag {} -default ""]
}
