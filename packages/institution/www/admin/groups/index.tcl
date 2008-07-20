# -*- tab-width: 4 -*-
ad_page_contract {
	This is the main page for the groups objects in the institution package.
	It presents the user with a tree of groups which they have permission to
	read in the current context.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/21
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{show:integer,optional}
	{hide:integer,optional}
}

set context		[list "Groups"]
set title		"Top-Level Groups"
set user_id		[ad_conn user_id]
set subsite_id	[ad_conn subsite_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

set subgroup_create_url			""
set group_edit_url				""
set group_permit_url			""
set group_delete_url			""

set not_really_top_level_p		[subsite::for_any_party_p -subsite_id $subsite_id]
if {$not_really_top_level_p} {
	set create_p				0
	set write_p					0
	set delete_p				0
	set admin_p					0
} else {
	# if we were not given a group_id, then we should 'look at' the root group
	permission::require_permission -object_id $package_id -privilege "read"

	# require 'create' on package-level to create a root-level group
	set create_p				[permission::permission_p -object_id $package_id -privilege "create"]
	if {$create_p} {
		set subgroup_create_url	"add-edit?"
	}

	# cannot edit or delete the root group (it actually doesn't exist)
	set write_p					0
	set delete_p				0

	# Add a 'permit' URL if the user has 'admin' privileges
	# //WARNING// successfully changing this with the ACS-permissions
	# interface will actually change permissions on the package instance,
	# since there is no root group_id we can use.  We may want to leave
	# this out...
	set admin_p					[permission::permission_p -object_id $package_id -privilege "admin"]
	if {$admin_p} {
		set group_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $package_id}}]"
	}
}

set subsite_trunks				[subsite::parties_sql -only -root -groups]
set actual_object_type			"Package<br><small>(control who may create/delete top-level groups)</small>"

# See if the user can perform any actions on the current group.
set can_change_this_group_p [expr $create_p || $delete_p || $write_p || $admin_p]
