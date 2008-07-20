# -*- tab-width: 4 -*-
# /packages/categories/www/index.tcl
ad_page_contract {
	This is the main page for the categories package.  For other kinds of
	objects, a page such as this might be called 'one' or 'detail'.  Thus,
	for non-tree structured data, not specifying the category_id would be
	cause to complain to the user, but here it is fine.

	@param	category_id			(optional) the id of the category you wish to view -- leave out to see top-level categories
	@param	show				(optional) the category to expand in the category-tree (passed along to tree.tcl)
	@param	hide				(optional) the category to collapse in the category-tree (passed along to tree.tcl)

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/04
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
} {
	{category_id:naturalnum,optional}
	{show:integer,optional}
	{hide:integer,optional}
}

set title		"Categories"
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

# this variable is used to build proper URLs for managing permissions
set subsite_url	[site_node::get_url -node_id [ad_conn subsite_id]]

# if we were not given a category_id, then we should 'look at' the root category
if {![info exists category_id]} {
	permission::require_permission -object_id $package_id -privilege "read"

	# require 'create' on package-level to create a root-level category
	set create_p					[permission::permission_p -object_id $package_id -privilege "create"]
	if {$create_p} {
		set subcategory_create_url	"add-edit?"
	} else {
		set subcategory_create_url	""
	}

	# cannot edit or delete the root category (it actually doesn't exist)
	set write_p						0
	set category_edit_url			""
	set delete_p					0
	set category_delete_url			""

	# Add a 'permit' URL if the user has 'admin' privileges
	# //WARNING// successfully changing this with the ACS-permissions
	# interface will actually change permissions on the package instance,
	# since there is no root category_id we can use.  We may want to leave
	# this out...
	set admin_p				[permission::permission_p -object_id $package_id -privilege "admin"]
	if {$admin_p} {
		set category_permit_url		"$subsite_url/permissions/one?[export_vars -override {{object_id $package_id}}]"
	} else {
		set category_permit_url		""
	}
	set name "Top Level Categories"
	set roots [db_map default_root_categories]
	set actual_object_type		"Package<br><small>(control who may create/delete top-level categories)</small>"
	set n_children [llength [db_list default_root_categories {}]]
} else {
	# see if we are looking at a category that exists in the current
	# context, and if so get its attributes and permissions
	if {[db_0or1row category {}] <= 0} {
		ad_return_complaint 1 "Category does not exist (it may exist in other contexts)."
		ad_script_abort
	}
	set parent_category_url "?[export_vars -override {{category_id $parent_category_id}}]"

	# require 'read' on current category to see anything:
	if {!$read_p} {
		permission::require_permission -object_id $category_id -privilege "read"
	}

	# require 'write' on current category to allow editing:
	if {$write_p} {
		set category_edit_url		"add-edit?[export_vars {category_id}]"
	} else {
		set category_edit_url		""
	}

	# require 'create' on current category to create sub-categories:
	if {$create_p} {
		set subcategory_create_url	"add-edit?[export_vars -override {{parent_category_id $category_id}}]"
	} else {
		set subcategory_create_url	""
	}

	# require 'delete' on current category to delete it and all subcategories
	if {$delete_p} {
		set category_delete_url		"delete?[export_vars {category_id}]"
	} else {
		set category_delete_url		""
	}

	# Add a 'permit' URL if the user has 'admin' privileges
	if {$admin_p} {
		set category_permit_url		"$subsite_url/permissions/one?[export_vars -override {{object_id $category_id}}]"
	} else {
		set category_permit_url		""
	}

	# roots is an sql-query (be careful) or comma-delimited list of values
	set roots				[db_map direct_subcategories_of]
	set root_category_id	$category_id
	set actual_object_type	"Category"
}

# See if the user can perform any actions on the current category.
set can_change_this_category_p [expr $create_p || $delete_p || $write_p || $admin_p]
