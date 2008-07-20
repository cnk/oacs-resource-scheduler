#packages/institution/www/sttp/index-ae.tcl

ad_page_contract {
    Index page for Mentorship Program

    @author reye@mednet.ucla.edu
    @creation-date 2004-10-27
    @cvs-id: $Id
} {
    {order_by:optional}
    {order_dir:optional}
}

set package_id   [ad_conn package_id]
set admin_p      [permission::permission_p -object_id $package_id -privilege "admin"]
set any_admin_p  [inst_permissions::admin_p]

if {$any_admin_p || $admin_p} {
    set admin_url "sttp-poster-date-ae"
}

set title "Faculty Mentor Recruitment List for Summer 2005"

if { ![exists_and_not_null order_by] } {
    set order_by short_name 
}
if { ![exists_and_not_null order_dir] } {
    set order_dir asc
}

set n_requested 0
set n_received 0
db_multirow sttp_selection sttp_selection {} {
    if {[empty_string_p $n_requested]} {
	set n_requested 0
    } else {
	set n_requested $n_requested
    }

    if {[empty_string_p $n_received]} {
	set n_received 0
    } else {
	set n_received $n_received
    }

}

## Action links for admin ###
set sttp_add "sttp-mentor-ae"
set sttp_delete "sttp-delete"
set sttp_edit "sttp-mentor-ae"

