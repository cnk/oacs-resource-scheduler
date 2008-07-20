# -*- tab-width: 4 -*-

ad_page_contract {
	
	@author		whao@ctrl.ucla.edu
	@creation-date	2006/06/14
	@cvsid		$Id:
	
} {
    {current_page:naturalnum 0}
    {row_num:naturalnum 5}
    {group_name:optional ""}
}


ad_form -name group -form {
	{group_name:text,optional {label "Group Name"} {html {size 50}}}
	{search:text(submit) {label "Search"}}
}

db_0or1row get_total_items {}
#Pagination 

set url "groups-search?[export_vars $group_name]"
set page_list [ctrl_procs::util::pagination -total_items $total_items -current_page $current_page -row_num $row_num -path $url]
set lower_bound [lindex $page_list 0]
set upper_bound [lindex $page_list 1]
set pagination_nav_bar [lindex $page_list 2]
db_multirow groups_search get_groups_search {}

set page_title "Find a Group:"
set context_bar [ad_context_bar $page_title]

