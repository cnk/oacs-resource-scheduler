ad_page_contract {
	@author    nick@ucla.edu
	@creation-date	2004/02/16
	@cvs-id $Id: user-list.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {current_page:naturalnum 0}
    {row_num:naturalnum 15}
    {user_name:optional ""}
}

ad_form -name user_search -form {
	{user_name:text,optional {label "User Name"} {html {size 40}}}
	{search:text(submit) {label "Search"}}
}

set title "User List"

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]
permission::require_permission -object_id $package_id -privilege "admin"

set personnel_search_p [permission::permission_p -object_id $package_id -privilege "admin"]

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [ad_conn package_url] "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "User Index"]]

set link "$subsite_url" 
append link "institution/admin/personnel/user-to-personnel?"

set where_clause "where (lower(last_name) like lower('%$user_name%') or lower(first_names) like lower('%$user_name%')) and user_id = person_id and user_id = personnel_id(+)"
set correction [db_string number_of_rows "select count(distinct user_id) from users, persons, inst_personnel $where_clause order by user_id"]
set sql_query "select 	distinct qb.user_id, qb.first_names, qb.last_name, qb.personnel_p
	       from	(select qa.user_id, qa.first_names, qa.last_name, qa.personnel_p, rownum row_real
		 from	(select distinct user_id, per.first_names, per.last_name, count(ip.personnel_id) as personnel_p 
		 	 from persons per, users, inst_personnel ip
			 $where_clause
                   group by user_id, first_names, last_name
		       order by per.last_name) qa) qb"

set my_vars {}


set url "user-list?[export_vars $my_vars]"
set pag_results [ctrl_procs::util::pagination -total_items $correction -current_page $current_page -row_num $row_num -path $url]
    

set first_number [lindex $pag_results 0]
set last_number [lindex $pag_results 1]
set navigation_display [lindex $pag_results 2]

