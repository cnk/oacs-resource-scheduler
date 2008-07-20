# -*- tab-width: 4 -*-
# /packages/institution/www/title/detail.tcl

ad_page_contract {
	This is the detail page for the title objects in the institution package.

	@param			gpm_title_id	the gpm_title_id of the title you wish to see.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/11/11
	@cvs-id			$Id: detail.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{gpm_title_id:naturalnum}
}

set object_type			"Title"
set object_type_plural	"Titles"
set context				[list [list "../title/" $object_type_plural] "Details"]
set user_id				[ad_conn user_id]
set package_id			[ad_conn package_id]
set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# see if we are looking at a title that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row title {}] <= 0} {
	ad_return_complaint 1 "Title does not exist (it may exist in other contexts)."
	return
}

# set the title
if {$user_id == $personnel_id} {
	set page_title	"Details About Your $object_type \"$description\""
} else {
	set page_title	"Details About the $object_type \"$description\" owned by \"$owner_name\""
}

# require 'read' on current title to see anything:
if {!$read_p} {
	permission::require_permission -object_id $gpm_title_id -privilege "read"
	return
}

# provide a link to the group if the user can administer the group
if {$group_admin_p} {
	set group_url			"../groups/detail?[export_vars {group_id}]"
}

# require 'write' on current title to allow editting:
if {$write_p} {
	set title_edit_url	"add-edit?[export_vars {gpm_title_id}]"
} else {
	set title_edit_url	""
}

# require 'delete' on current title to delete it
if {$delete_p} {
	set title_delete_url	"delete?[export_vars {gpm_title_id}]"
} else {
	set title_delete_url	""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set title_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $gpm_title_id}}]"
} else {
	set title_permit_url	""
}

# See if the user can perform any actions on the current title.
set can_change_this_title_p [expr $create_p || $delete_p || $write_p || $admin_p]
