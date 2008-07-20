ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id    $Id: publication-map-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {publication_id:integer,notnull}
    {combine_method:integer 0}
    {letter:trim,optional ""}
    {first_name:trim,optional ""}
    {last_names:trim,optional ""}
    {employee_id:integer,optional ""}
    {current_page:naturalnum 0}
    {row_num:naturalnum 10}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

# require 'create' to create new publication-personnel map
permission::require_permission -object_id $package_id -privilege "create"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] [list [set subsite_url]institution/publication/publication-map?[export_vars publication_id] "Personnel Map Search "] "Personnel Map Results"]]

set title "Search Results for Personnel Publication Map"
set link "publication-map-3?publication_id=$publication_id&"

# if combine method equals 0, do all, if equals 1 do any.
if {$combine_method == 0} {
    set where_conjuction "and"
} else {
    set where_conjuction "or"
}

# basic where clause for joins to work
set where_clause "where per.person_id = ip.personnel_id"

# used to determine if entered any of the if's or not
set where_bool 0

if {![empty_string_p $letter]} {
    set filter "'[string tolower $letter]%'"
    append where_clause " and lower(last_name) like $filter"
} else {
    if {![empty_string_p $first_name]} {    
	if {!$where_bool} {
	    append where_clause " and (lower(per.first_names) = lower(:first_name)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(per.first_names) = lower(:first_name) "
	}
    } 
    if {![empty_string_p $last_names]} {    
	if {!$where_bool} {
	    append where_clause " and (lower(per.last_name) = lower(:last_names)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(per.last_name) = lower(:last_names) "
	}
    } 
    if {![empty_string_p $employee_id]} {    
	if {!$where_bool} {
	    append where_clause " and (ip.employee_id = :employee_id"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction ip.employee_id = :employee_id "
	}
    } 
}
if {$where_bool} {
    append where_clause ")"
}

# creating bounds for page select function
set correction [db_string number_of_rows "select count(*) from persons per, inst_personnel ip $where_clause order by ip.personnel_id"]

set sql_query "select 	qb.personnel_id, qb.first_names, qb.last_name
	       from 	(select	qa.personnel_id, qa.first_names, qa.last_name, rownum row_real
			from	(select distinct ip.personnel_id, per.first_names, per.last_name
				from persons per, inst_personnel ip
				$where_clause
				order by ip.personnel_id) qa) qb"

set my_vars {combine_method publication_id letter first_name last_names employee_id}
set url "[set subsite_url]institution/publication/publication-map-2?[export_vars $my_vars]"
set pag_results [ctrl_procs::pagination -total_items $correction -current_page $current_page -row_num $row_num -path $url]

set first_number [lindex $pag_results 0]
set last_number [lindex $pag_results 1]
set navigation_display [lindex $pag_results 2]
