ad_page_contract {
    @author   nick@ucla.edu
    @creation-date    2004/03/24
    @cvs-id $Id: faculty-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
    {return_addr:trim,optional "detail?[export_vars personnel_id]"}
}

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

set subsite_url [site_node_closest_ancestor_package_url]
set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [ad_conn package_url] "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Faculty delete"]]

# require 'delete' to delete new personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set person_check 0
set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]

set title "Removing $first_names $last_name as a Faculty"
if {!$person_check} {
    ad_return_complaint 1 "This personnel does not exist"
    return
} else {
    set warning_text "Warning, you are about to remove $first_names $last_name as a Faculty"
    ad_form -name {faculty_delete} -form {
	{warning:text(inform)  {label "Warning"} {value $warning_text}}
    } -export {personnel_id return_addr} -action {faculty-delete-2} -method {post}
}
