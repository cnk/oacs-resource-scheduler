# /package/ctrl-events/www/admin/event-object-ae.tcl
ad_page_contract {
    @author: kellie@ctrl.ucla.edu
    @creation-date: 11/08/2006
    @cvs-id $Id
} {
    {event_object_id:optional,integer}
    {event_id:optional,integer}
}

set error_p [catch {
    set tag ""
    set package_id [ad_conn package_id]
    set package_url [ad_conn package_url]
    if {![exists_and_not_null event_id]} {
	set event_id ""
	set event_title ""
	set event_id_p 0
    } else {
	if {![ctrl_event::exists_p -event_id $event_id]} {
	    ad_return_error "Error" "Invalid Event ID"
	    ad_script_abort
	}
	ctrl_event::get -array events -event_id $event_id
        set event_title "for $events(title) event"
	set event_id_p 1
    }
    
    if {[ad_form_new_p -key event_object_id]} {
	set current_image ""
	set page_title "Add Event Object"
    } else {
	set page_title "Edit Event Object"
	set current_image [ctrl_event::object::image_display -event_object_id $event_object_id]
	if {[empty_string_p [string trim $current_image]]} {
	    set current_image "<i>n/a</i>"
	    set delete_image_link ""
	} else {
	    set delete_image_link "<a href=object-image-delete?[export_vars event_object_id]>Remove this Image</a>"
	}
    }
    
    set context_bar "[ad_context_bar ""][ad_context_bar_html [list [list "event-object-list?[export_vars event_id]" "Event Objects"] $page_title]]"
    set object_type_options " {} [ctrl_event::category::option_list -path "CTRL Events Objects" -package_id $package_id]"
} errmsg ]

if {$error_p} {
    ad_return_error "Error" "$errmsg"
    ad_script_abort
}    

ad_form -name "add_edit_event_object" -method post -html {enctype multipart/form-data} -form {
    event_object_id:key
    {name:text(text) {label "Name: "}}
    {tag:text(text),optional {label "Tag: "} {value $tag}}
    {object_type_id:integer(select) {label "Object Type: "} {options $object_type_options}}
    {description:text(textarea),optional {label "Description: "} {html {rows 4 cols 40}}}
    {url:text(text),optional {label "URL: "} {html {cols 90}}}
    {image:text(file),optional {label "Upload Image: "}}
    {current_image:text(inform) {label "Current Image: "} {value $current_image}}
    {event_id:text(hidden) {label "Event ID"} {value $event_id}}
    {submit:text(submit) {label "Submit"}}
} -validate { 
    {name {![ctrl_event::object::unique_p -name $name -object_type_id $object_type_id -event_object_id $event_object_id]} "There is already a $name object"}
    {tag {![empty_string_p $tag] || !$event_id_p} "Tag is required"}
    {tag {[llength [split $tag " "]] <= 1} "Tag is one word with no space only"}
} -new_request {
    set tag ""
} -edit_request {
    set error_p [catch {
    if {[info exists event_object_id]} {
	set selection [db_0or1row get_object_data {}]
	if {!$selection} {
	    ad_return_error "Error" "An invalid event_object_id has been passed to this page. Please contact    
            the system administrator at <a href=\"mailto:[ad_host_administrator]\">[ad_host_administrator]</a>   
            if you have any questions. Thank you."
            ad_script_abort
	}
	if {$event_id_p} {    
	    set tag [ctrl_event::object::tag -event_id $event_id -event_object_id $event_object_id]
	} else {
	    set tag ""
	}
    }
} errmsg ]

if {$error_p} {
        ad_return_error "Error" "$errmsg"
        ad_script_abort
}

} -on_submit {

    set error_p [catch {
	if {[ad_form_new_p -key event_object_id]} {
	    set event_object_id [ctrl_event::object::new -event_object_id $event_object_id \
				     -name $name \
				     -object_type_id $object_type_id \
				     -description $description \
				     -url $url \
				     -image $image]
	} else {

	    if {[empty_string_p [string trim $image]] && $current_image == "<i>n/a</i>"} {set image ""}
	    
	    ctrl_event::object::update -event_object_id $event_object_id \
		-name $name \
		-object_type_id $object_type_id \
		-description $description \
		-url $url \
		-image $image
	}

	# Map to an event if event_id exists
	if [exists_and_not_null event_id] {	
	    if {[ctrl_event::object::unique_tag_p -event_id $event_id -event_object_id $event_object_id -tag $tag]} {
		ad_return_error "Error" "Tag $tag already exist $event_title"
		ad_script_abort	    
	    } else {
		if {[ad_form_new_p -key event_object_id]} {		
		    ctrl_event::object::map -event_object_id $event_object_id -event_id $event_id -tag $tag
		} else {
		    ctrl_event::object::map_update -event_object_id $event_object_id -event_id $event_id -tag $tag
		}
	    }
	}

    } errmsg ]
    
    if {$error_p} {
	ad_return_error "Error" "$errmsg"
	ad_script_abort
    }
    
} -after_submit {
    ad_returnredirect "${package_url}admin/event-object-view?[export_url_vars event_object_id event_id]"
}
