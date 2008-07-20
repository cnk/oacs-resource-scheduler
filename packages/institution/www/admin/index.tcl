# -*- tab-width: 4 -*-
ad_page_contract {
	This is the main page for the institution package.  It presents the user
	with a tree of groups which they have permission to read in the current
	subsite as well as some controls for manipulating those groups as
	well as personnel.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/02/24
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{show:integer,optional}
	{hide:integer,optional}
}

set context		[list]
set title		"Faculty Editor"
set user_id		[ad_conn user_id]
set subsite_id	[ad_conn subsite_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

set subsite_trunks			[subsite::parties_sql -only -root -groups]
set n_children				[llength [db_list subsite_trunks $subsite_trunks]]

# //TODO// this doesn't properly account for the situation where there's more
#			than one subsite-root group
set group_id                [subsite::party_group_id -subsite_id $subsite_id]


set group_create_url		""
set group_edit_url			""
set group_permit_url		""
set group_delete_url		""

# require read-permission on the package to see this page
permission::require_permission -object_id $package_id -privilege "read"

# require 'create' on package-level to create a root-level group
set create_p					[permission::permission_p -object_id $package_id -privilege "create"]
if {$create_p} {
	set group_create_url		"groups/add-edit?"
	if {![empty_string_p $group_id]} {
		append group_create_url "parent_group_id=$group_id"
	}
	set personnel_create_url	"personnel/personnel-ae"
	set physician_create_url	"personnel/personnel-ae?[export_vars -override {{physician_p 1}}]"
	set user_list_url           "personnel/user-list"
}

set personnel_search_url	"personnel/index"
set group_search_url	"groups/groups-search"
# cannot edit or delete the root group (it actually doesn't exist)
set write_p					0
set delete_p				0

# Add a 'permit' URL if the user has 'admin' privileges
set admin_p					[permission::permission_p -object_id $package_id -privilege "admin"]
if {$admin_p} {
	set group_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $package_id}}]"
	set categories_url		[site_node_closest_ancestor_package_url -package_key categories]
}


# See if the user can perform any actions on the current group.
set can_change_this_group_p [expr $create_p || $delete_p || $write_p || $admin_p]

set publication_upload_url "publication/endnote-upload-info"
