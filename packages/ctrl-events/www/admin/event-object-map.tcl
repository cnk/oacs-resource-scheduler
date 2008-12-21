# /packages/ctrl-events/www/admin/event-object-map.tcl

ad_page_contract {
    Map event object to events

    @author kellie@ctrl.ucla.edu
    @creation-date 11/14/2006
    @cvs-id $Id
} {
    {event_id}
    {search_name:trim ""}
    {search_description:trim ""}
    {search_object_type:multiple ""}
} 

set error_p [catch {
    regsub -all {\{} $search_object_type "" search_object_type
    regsub -all {\}} $search_object_type "" search_object_type

    set package_id [ad_conn package_id]
    set package_url [ad_conn package_url]
    
    if {![exists_and_not_null order_by]} {set order_by "name"}
    if {![exists_and_not_null order_dir]} {set order_dir "asc"}

    if {![exists_and_not_null event_id]} {
	set event_id ""
	set event_title ""
	set add_event_object_link ""
	set map_event_object_link ""
	set event_p "f"
    } else {
	ctrl_event::get -array events -event_id $event_id
	set event_title "for $events(title) event"
	set add_event_object_link "event-object-ae?[export_url_vars event_id]"
	set map_event_object_link "event-object-map?[export_url_vars event_id]"
	set event_p "t"
    }
    
    set page_title "Event Objects Administration $event_title"
    set context_bar "[ad_context_bar ""][ad_context_bar_html [list [list "event-object-list?[export_vars event_id]" "Event Objects"] $page_title]]"

    # Event Objects
    set object_type_options "[ctrl_event::category::option_list -path "CTRL Events Objects" -package_id $package_id]"
    
    # --------------------------------------------------------------------------------------------------
    # Create Search Constraints
    # --------------------------------------------------------------------------------------------------
    set search_constraint ""
    
    if {![empty_string_p $search_name]} {append search_constraint " and lower(o.name) like '%[string tolower $search_name]%'"}
    if {![empty_string_p $search_description]} {append search_constraint " and lower(o.description) like '%[string tolower $search_description]%'"}
    set i 0
    foreach o_id $search_object_type {
	if {$i==0} {
	    append search_constraint " and ((c.category_id=$o_id)"
	} else {
	    append search_constraint " or (c.category_id=$o_id)"
	}
	incr i
    }
    if {$i>0} {append search_constraint ")"}
    # --------------------------------------------------------------------------------------------------
    # END Create Search Constraints
    # --------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------
    # Event constraint
    # --------------------------------------------------------------------------------------------------
    if [exists_and_not_null event_id] {
	set event_table ", ctrl_events_event_object_map e "
	set event_table_constraint " and e.event_object_id (+)= o.event_object_id and (e.event_id <> :event_id or e.event_id is null)"
    } else {
	set event_table ""
	set event_table_constraint ""
    }
    # --------------------------------------------------------------------------------------------------
    # END Event constraint
    # --------------------------------------------------------------------------------------------------

    set event_objects_list [db_list_of_lists event_objects {}]
} errmsg ]

if {$error_p} {
    ad_return_error "Error" "$event_id<br>$errmsg"
    ad_script_abort
}

ad_form -name "event_object_map" -method post -html {enctype multipart/form-date} -form {
    {event_id:text(hidden) {value $event_id}}
    {event_object_id:text(radio) {options $event_objects_list}}    
    {tag:text(text) {label "Tag"}}
    {event_object_group_id:integer(text)}
    {submit:text(submit) {label "Map Event and Objects"}}
} -validate {
    {tag {[llength [split $tag " "]]==1} "Tag is one word with no space only"}
} -on_submit {
    set error_p [catch {
	# check for unique tag
	if {[ctrl_event::object::unique_tag_p -event_id $event_id -event_object_id $event_object_id -tag $tag]} {
	    ad_return_error "Error" "Tag $tag already exist $event_title"
	    ad_script_abort	    
	} else {

	    # check for unique event_id, event_object_id, event_object_group_id
	    if {[ctrl_event::object::unique_group_id_p -event_id $event_id -event_object_id $event_object_id -event_object_group_id $event_object_group_id]} {
		ad_return_error "Error" "Group ID $group_id already exist $event_title"
		ad_script_abort	    
	    } else {
		ctrl_event::object::map -event_object_id $event_object_id -event_id $event_id \
		    -tag $tag -event_object_group_id $event_object_group_id
	    }
	}
    } errmsg ]

    if {$error_p} {
	ad_return_error "Error" "$event_id<br>$errmsg"
	ad_script_abort
    }
} -after_submit {
    ad_returnredirect "[ad_conn package_url]admin/event-object-list?[export_url_vars event_id]"
}
