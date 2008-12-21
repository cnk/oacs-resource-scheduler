# /packages/ctrl-events/www/admin/event-object-list.tcl

ad_page_contract {
    Display all event objects

    @author kellie@ctrl.ucla.edu
    @creation-date 11/14/2006
    @cvs-id $Id
} {
    {row_num:naturalnum 10}
    {current_page:naturalnum 0}
    {search_name:trim ""}
    {search_description:trim ""}
    {search_object_type:multiple ""}
    {order_by:optional}
    {order_dir:optional}
    {event_id:naturalnum,optional}
} 

set error_p [catch {
    regsub -all {\{} $search_object_type "" search_object_type
    regsub -all {\}} $search_object_type "" search_object_type

    set package_id [ad_conn package_id]
    
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
	set event_title "for $events(title)"
	set add_event_object_link "event-object-ae?[export_url_vars event_id]"
	set map_event_object_link "event-object-map?[export_url_vars event_id]"
	set event_p "t"
    }
    
    set page_title "Event Objects Administration $event_title"
    set context_bar [ad_context_bar $page_title]

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
	set event_tag ", tag, event_object_group_id "
	set event_table ", ctrl_events_event_object_map e "
	set event_table_constraint " and e.event_object_id = o.event_object_id and e.event_id = $event_id " 
    } else {
	set event_tag ""
	set event_table ""
	set event_table_constraint ""
    }
    # --------------------------------------------------------------------------------------------------
    # END Event constraint
    # --------------------------------------------------------------------------------------------------
        
    set add_link "event-object-ae"
    set view_all_link "event-object-list"
    set unmap_objects_link "event-object-unmap?[export_vars event_id]"
} errmsg ]

if {$error_p} {
    ad_return_error "Error" "$errmsg"
    ad_script_abort
}

set error_p [catch {
    # Pagination
    db_1row sql_total_items {}
    
    set page_list [ctrl_procs::util::pagination -total_items $total_items -current_page $current_page -row_num $row_num -path "event-object-list?[export_url_vars order_by order_dir search_name search_description search_object_type event_id]"]
    set lower_bound [lindex $page_list 0]
    set upper_bound [lindex $page_list 1]
    set pagination_nav_bar [lindex $page_list 2]
    
    db_multirow -extend {edit_link view_link delete_link url_link remove_link} event_objects event_objects {} {
	set edit_link "event-object-ae?[export_url_vars event_object_id event_id]"
	set view_link "event-object-view?[export_url_vars event_object_id event_id]"
	set delete_link "event-object-delete?[export_url_vars event_object_id event_id]"
	set remove_link "event-object-unmap?[export_url_vars event_object_id event_id]"
	if [exists_and_not_null event_id] {
	    set tag_link "event-object-ae?[export_url_vars event_object_id event_id]"
	}
	
	# Format URL Link
	if {[string equal [string tolower [string range $url 0 3]] "http"]} {
	    set url_link $url
	} elseif {[string equal [string tolower [string range $url 0 7]] "<a href="]} {
	    set url_link ""
	} else {
	    set url_link "http://$url"
	}    
    }
} errmsg ]

if {$error_p} {
    ad_return_error "Error" "$errmsg"
    ad_script_abort
}
