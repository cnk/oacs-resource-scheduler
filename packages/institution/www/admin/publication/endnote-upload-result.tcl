# /packages/institution/www/admin/publication/endnote-upload-result.tcl

ad_page_contract {

    @author nick@ucla.edu
    @creation-date 2004/04/06
    @cvs-id $Id: endnote-upload-result.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

} {}

if [template::util::is_nil success_list]        { set success_list ""}
if [template::util::is_nil failure_list]        { set failure_list ""}
if [template::util::is_nil personnel]           { set personnel ""}
if [template::util::is_nil no_title_counter]    { set no_title_counter 0}
if [template::util::is_nil personnel_id]        { set personnel_id 0}

set success_list [split $success_list ","]
set failure_list [split $failure_list ","]

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

set title "EndNote Publication Upload Results"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] [set title]]]

set successes [llength $success_list]
set success_upload ""
if {$successes} {

    foreach upload $success_list {
	if {![empty_string_p $upload]} {
	    append success_upload "<li>$upload</li>"
	}
    }
}

set failures [llength $failure_list]
set failure_upload ""
if {$failures} {
    foreach failure $failure_list {
	if {![empty_string_p $failure]} {
	    append failure_upload "<li>$failure</li>"
	}
    }
}

set personnel_map ""
if {[llength $personnel] > 0} {
    foreach person $personnel {
	set name [db_string get_personnel_name "select first_names || ' ' || last_name as name from persons where person_id = :person"]
	if {![empty_string_p $personnel_map]} {
	    append personnel_map ", $name"
	} else {
	    append personnel_map "$name"
	}
    }
}

set sitewide_admin_p	[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]
