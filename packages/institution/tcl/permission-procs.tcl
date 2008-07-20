# /packages/institution/tcl/permission-procs.tcl

ad_library {

    Institution Permission Procedures

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/10/31
    @cvs-id $Id: permission-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
}

namespace eval inst_permissions {}
ns_share -init {set inst_admin_filters_installed 0} inst_admin_filters_installed

if {!$inst_admin_filters_installed} {
    set inst_admin_filters_installed 1
    ad_register_filter preauth GET */institution/admin/* inst_permissions::admin_auth
    ad_register_filter preauth HEAD */institution/admin/* inst_permissions::admin_auth
    ad_register_filter preauth POST */institution/admin/* inst_permissions::admin_auth
}

ad_proc inst_permissions::admin_auth {} {
    Called by filter to check if user is site wide admin or inst group admin
    and has permission to access [inst_url_stub]/admin/*
} {
    set user_id [ad_maybe_redirect_for_registration]
    if {![inst_permissions::admin_p]} {
	ad_return_error "Error" "You must be a Faculty Editor Administrator  to access the Faculty Editor Admin pages.
        Your account does not have access to this page. Please contact <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> to gain access."
	return filter_return
    }
    return filter_ok
}

ad_proc -public inst_permissions::admin_p {} {
    Returns 1 if the current user is any type of admin within the institution package
    Returns 0 if the current user is not an admin
} {
    set user_id [ad_conn user_id]
    # Need more checks here for other P+ object types and make sure object is accessible in current subsite
    return [db_string inst_admin_p {} -default 0]
}

ad_proc -public inst_permissions::group_admin_p {} {
    Returns 1 if the current user is a group admin within the institution package
    Returns 0 if the current user is not a group admin
} {
    set user_id [ad_conn user_id]
    return [db_string inst_group_admin_p {} -default 0]
}
