# -*- tab-width: 4 -*-
#
# NOTE: great care should be taken in what values are passed to this template,
# specifically for the <code>items</code> variable, since it is <i>not</i>
# passed to the query using a bind variable.  This allows Oracle to optimize
# query execution time, minimizes the amount of data that must pass from TCL to
# Oracle (otherwise the data would be extensive lists of object-ids), and is
# very flexible.
#
# @param	items				A list of or a query returning a list of id&apos;
#									of personnel that should be	displayed.
# @param	allow_action_p		(optional) The set of all actions that may be
#									displayed in the list (from <code>view,
#									edit, delete, permit</code>)  This variable
#									is a TCL array, set an <code>action</code>
#									to <code>1</code> to enable it,
#									<code>0</code> to disable it.
#									If the array is not passed, it is assumed all actions
#									should be displayed when sufficient privileges exits.
#									If the array is passed, then it is assumed no actions
#									should ever be displayed in the list.
# @param	list_title			(optional) The title to use for the column
#									showing the <code>name</code> of each
#									personnel.
# @param	return_url			(optional) The url to return to (this is
#									typically the page that is including this
#									list.  Defaults to the index page for
#									personnel.
# @param	max					(optional) The maximum number of personnel to be displayed
#									//TODO//
# @param	if_none_put			(optional) The text to use if there are no personnel.
#									If omitted, nothing will be displayed.
#
# @author			helsleya@cs.ucr.edu (AH)
# @creation-date	2004-02-05
# @cvs-id			$Id: list.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
#

# Check for the 'canary' variable (detects attempts to access this template directly)
if {![info exists items]} {
	ad_return_error "Invalid Request" {
		This template may only be used as a component of another page.  If you
		arrived here as a result of clicking on a URL, please notify the
		webmaster.
	}
	ad_script_abort
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

# this variable is used to build proper URLs for managing permissions
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# this is the common part of all (well, almost all) urls on this page
set parent_url "[ad_conn package_url]admin/personnel/"

# setup the title of the first column of the table if none was passed in
if {![info exists list_title]} {
	set list_title "Personnel"
}

# 'personnel_action_url_exists_p' tells us whether the user is allowed to perform actions on the personnel.
#	An action URL is (typically) anything except 'view' or 'details'
set personnel_action_url_exists_p 0

# find out what kind of actions the enclosing page limits us to
if {![array exists allow_action_p]} {
	array set allow_action_p {
		view	1
		add		1
		edit	1
		delete	1
		permit	1
	}
} else {
	if {![info exists allow_action_p(view)]} {
		set allow_action_p(view)	0
	}
	if {![info exists allow_action_p(add)]} {
		set allow_action_p(add)		0
	}
	if {![info exists allow_action_p(edit)]} {
		set allow_action_p(edit)	0
	}
	if {![info exists allow_action_p(delete)]} {
		set allow_action_p(delete)	0
	}
	if {![info exists allow_action_p(permit)]} {
		set allow_action_p(permit)	0
	}
}


db_multirow -extend {
	action_url_exists_p
	unassociate_url
	title_edit_url
	edit_url
	delete_url
	permit_url
	detail_url
} personnel personnel {} {
	# read_p --> user can see this personnel
	# All results from the query should be readable, but just in case...
	if {!$read_p} {
		continue
	} elseif {$allow_action_p(view)} {
		# url for showing details about a particular personnel
		set detail_url	"${parent_url}detail?[export_vars {return_url personnel_id}]"
		# this is not an "action URL" so don't set personnel_action_url_exists_p
	}

	# write_p --> user can edit this personnel
	if {$allow_action_p(edit) && $write_p}	{
		set edit_url	"${parent_url}personnel-ae?[export_vars {personnel_id return_url}]"
		set action_url_exists_p				1
		set personnel_action_url_exists_p	1
	}

	# delete_p --> user can delete this personnel
	if {$allow_action_p(delete) && $delete_p && !$user_is_this_person_p}	{
		set delete_url	"${parent_url}personnel-delete?[export_vars -override {personnel_id {return_addr $return_url}}]"
		set action_url_exists_p				1
		set personnel_action_url_exists_p	1
	}

	# admin_p --> user can change the privileges on this personnel
	if {$allow_action_p(permit) && $admin_p && !$user_is_this_person_p}	{
		set permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $personnel_id} return_url}]"
		if {[info exists group_id]} {
			set unassociate_url		"${parent_url}personnel-group-delete?[export_vars {personnel_id group_id return_url}]"
			set title_edit_url		"${parent_url}../title/index?[export_vars {personnel_id}]"
		}
		set action_url_exists_p				1
		set personnel_action_url_exists_p	1
	}
}

