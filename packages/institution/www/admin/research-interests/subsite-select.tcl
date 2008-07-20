# /packages/institution/www/admin/research-interests/index.tcl

ad_page_contract {
    
    This page displays the subsites for which a user can add research interests
    
    @param personnel_id
    @param subsite_id

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/11/12
    @cvs-id $Id: subsite-select.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:naturalnum,notnull}
} 

set user_id [ad_verify_and_get_user_id]
set this_subsite_id  [ad_conn subsite_id]

set subsite_url	[site_node_closest_ancestor_package_url]

### Personnel Info
set person_check [db_0or1row person_info {}]
if {!$person_check} {
    ad_return_error "Error" "The personnel id passed to this page is invalid.  Please contact your <a href=\"mailto:[ad_host_administrator]\">system administrator</a> if you
    have any questions. Thank you."
    return
}
### End Personnel Info

set title "Update Research Interests for $first_names $last_name"
set context_bar	[ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [ad_conn package_url]admin/personnel/ "Personnel Index"] \
	[list [ad_conn package_url]admin/personnel/detail?[export_url_vars personnel_id] "Detail for $first_names $last_name"] \
	$title]]

set main_subsite_id		[ctrl_procs::subsite::get_main_subsite_id]
set subsite_list "[list [list "Default" [ctrl_procs::subsite::get_main_subsite_id]]] [db_list_of_lists personnel_subsite_list {}]"

db_multirow -extend {
    select_subsite_url
} personnel_subsite_list personnel_subsite_list {} {
    set select_subsite_url "../research-interests/?[export_vars {personnel_id subsite_id}]"
}
