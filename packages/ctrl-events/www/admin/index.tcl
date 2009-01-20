# /packages/ctrl-events/www/admin/index.tcl

ad_page_contract {

    Display Events
    Allow Users to pick which category to display

    @author Avni Khatri (avni@avni.net), modified-by David Hao (whaoy@yahoo.com)
    @creation-date 10/24/2005, 02/28/2006
    @cvs-id $Id: index.tcl,v 1.1 2006/08/02 22:50:43 avni Exp $
} {
    {row_num:naturalnum 10}
    {current_page:naturalnum 0}
    {order_by:optional}
    {order_dir:optional}
    {color_red:optional "sdated"}
    {category_id:naturalnum "0"}
} -properties {
    event_list:multirow
}

set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set user_id [ad_conn user_id]

if {[catch {package require ctrl-tasks}]} {
} else {
}
package provide ctrl-tasks 1.0

set subsite_url [site_node_closest_ancestor_package_url]
set context_id [ad_conn package_id]

if {$category_id != 0 && ![empty_string_p $category_id]} {
    # Make sure category exists
    set category_exists_p [ctrl_event::category::exists_p $category_id]
    if {!$category_exists_p} {
	ad_return_error "Error" "You have selected an event category that
        no longer exists in the database. Please contact your system administrator
        if you have any questions."
	return
    }
    set category_constraint_clause "and ce.category_id = :category_id"
    set category_name [ctrl_event::category::get_info $category_id "name"]
} else {
    set category_constraint_clause ""
    set category_name ""
}

set page_title "Events Administration"

if {![exists_and_not_null order_by] } {
    set order_by "start_date_sort desc, title"
}
if {![exists_and_not_null order_dir] } {
    set order_dir asc
}

#Pagination (by David) 
db_1row sql_total_items {}

set page_list [ctrl_procs::util::pagination -total_items $total_items -current_page $current_page -row_num $row_num -path "index?order_by=$order_by&order_dir=$order_dir"]
# Oracle wants an upper and lower bounds
set lower_bound [lindex $page_list 0]
set upper_bound [lindex $page_list 1]
# Postgres wants a limit and offset (i.e. lower_bound)
set row_offset [expr $lower_bound - 1]
set row_limit [expr $upper_bound - $lower_bound]
set pagination_nav_bar [lindex $page_list 2]

db_multirow -extend {rsvp_ok} event_list event_list_query {} {
    set rsvp_ok [db_0or1row event_rsvp_query {}]
}

set category_options "{{All Events} {}} [ctrl_event::category::option_list -path "" -package_id $package_id -top_label "All Events"]"

ad_form -name event_category_list -form {
    {category_id:integer(select)   {label "Category: "} {value $category_id} {options $category_options}}
    {submit_filter:text(submit)    {label "Go"}}
} -select_query_name event_list_query

set event_add_link "<a href=\"event-ae\">Add An Event</a>"
set event_object_link "Event Objects"
