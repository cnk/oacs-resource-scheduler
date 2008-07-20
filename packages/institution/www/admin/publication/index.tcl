# /packages/institution/www/admin/publication/index.tcl

ad_page_contract {

    Publications Administration

    @author         avni@ctrl.ucla.edu (AK)
    @creation-date  1/24/2006
    @cvs-id $Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

} {
    {current_page:naturalnum 0}
    {row_num:naturalnum 10}
    {search_keyword:trim ""}
    {search_status:trim ""}
}

set user_id [ad_maybe_redirect_for_registration]
# AMK - ADD PERMISSION CHECK

set title "Publication Administration"
set subsite_url [site_node_closest_ancestor_package_url]
set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
					  [list [set subsite_url]institution/ "Faculty Editor"] \
					  [list [set subsite_url]institution/admin/ "Faculty Editor Administration"] \
					  "$title"]]

### BEGIN SEARCH ###########################################################################################################
### SEARCH FORM
set search_status_options [list [list "All Publications" ""] [list "Single Match in Pubmed (Not Imported)" "1"] \
			       [list "Multiple Matches in Pubmed (Not Imported)" "2"] \
			       [list "Publications Imported from Pubmed" "3"] \
			       [list "No Matches in Pubmed" "0"]]

ad_form -name search_form -form {
    {search_keyword:text,optional                {label "Keyword Search: "} {value $search_keyword}}
    {search_status:text(select),optional         {label "Status: "} {options {$search_status_options}} {value $search_status}}
    {submit:text(submit)                         {label "Search"} {value "Search"}}
}
### END SEARCH FORM

### BEGIN SEARCH CONSTRAINT
set search_constraint ""
set no_row_message "No Publications"

if {![empty_string_p $search_keyword]} {
    append search_constraint " and lower(ip.title || ' ' || ip.authors || ' ' || ip.publication_name) like '%[string tolower $search_keyword]%'"
    set no_row_message "No publications found matching your search."
}

if {![empty_string_p $search_status]} {
    set no_row_message "No publications found matching your search."
    switch $search_status {
	0 {
	    append search_constraint " and not exists (select 1 from inst_external_pub_id_map iepim where iepim.inst_publication_id=ip.publication_id)"
	}
	1 {
	    append search_constraint " and exists (select 1 from inst_external_pub_id_map iepim where iepim.inst_publication_id=ip.publication_id
                 and iepim.data_imported_p='f' having count(*) = 1)"
	}
	2 {
	    append search_constraint " and exists (select 1 from inst_external_pub_id_map iepim where iepim.inst_publication_id=ip.publication_id
                 and iepim.data_imported_p='f' having count(*) > 1)"
	}
	3 {
	    append search_constraint " and exists (select 1 from inst_external_pub_id_map iepim where iepim.inst_publication_id=ip.publication_id
                 and iepim.data_imported_p='t' having count(*) >= 1)"
	}
	default {
	}
    }
}

### END SEARCH CONSTRAINT
### END SEARCH ##########################################################################################################

### BEGIN ADMIN URL
set admin_url "[ad_urlencode [ad_conn package_url]admin/publication/?[export_url_vars search_keyword search_status current_page row_num]]"
### END ADMIN URL

### BEGIN PAGINATION
set total_count [db_string number_of_rows "select count(*) from inst_publications ip where 1=1 $search_constraint"]
set url "[ad_conn package_url]admin/publication/?[export_url_vars search_keyword search_status]"
set pag_results [ctrl_procs::util::pagination -total_items $total_count -current_page $current_page -row_num $row_num -path $url]

set first_number [lindex $pag_results 0]
set last_number [lindex $pag_results 1]
set navigation_display [lindex $pag_results 2]
### END PAGINATION

set sql_query "select * from (
   select rownum as rownumber,
          publication_id,
          publication_title,
          authors from (
   select ip.publication_id,
          ip.title as publication_title,
          ip.authors
     from inst_publications ip
    where 1=1 $search_constraint
    order by ip.publication_id desc)
where rownum    <= $last_number)
where rownumber >= $first_number"

db_multirow results results_query "$sql_query"

