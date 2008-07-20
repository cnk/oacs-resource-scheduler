# -*- tab-width: 4 -*-
ad_page_contract {
	This is the delete-confirmation page for the category objects.
	It displays a tree of subcategories that will also be deleted
	when deleting the category.

	@param	category_id			the id of the category you wish to delete
	@param	show				(optional) the category to expand in the category-tree (passed along to tree.tcl)
	@param	hide				(optional) the category to collapse in the category-tree (passed along to tree.tcl)

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/13
	@cvs-id			$Id: delete.tcl,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
} {
	{category_id:naturalnum}
	{show:integer,optional}
	{hide:integer,optional}
	{return_url [get_referrer]}
}

set action		"Delete"
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

# see if we are looking at a category that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row category {}] <= 0} {
	ad_return_complaint 1 "Category does not exist (it may exist in other contexts)."
	ad_script_abort
}

if {!$delete_p} {
	permission::require_permission -object_id $category_id -privilege "delete"
}

set roots					[db_map direct_subcategories_of]
set root_category_id		$category_id
set tree_title				"Subcategory"

# do not allow creation of categories from the delete page (that would be weird)
array set allow_action_p {
	view	1
	edit	1
	delete	1
	permit	1
}

# require 'write' on current category to allow editting:
if {$write_p} {
	set category_edit_url "add-edit?[export_vars {category_id}]"
} else {
	set category_edit_url ""
}

# require 'create' on current category to create sub-categories:
if {$create_p} {
	set subcategory_create_url "add-edit?[export_vars -override {{parent_category_id $category_id}}]"
} else {
	set subcategory_create_url ""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set subsite_url	[site_node::get_url -node_id [ad_conn subsite_id]]
	set category_permit_url "$subsite_url/permissions/one?[export_vars -override {{object_id $category_id}}]"
} else {
	set category_permit_url ""
}

# See if the user can perform any actions on the current category.
set can_change_this_category_p [expr $create_p || $write_p || $admin_p]

ad_form -name delete -export {return_url} -form {
	{category_id:key}
	{parent_category_name:text(inform),optional	{label "Parent Category:"}}
	{name:text(inform)							{label "Name:"}}
	{plural:text(inform)						{label "Plural:"}}
	{description:text(inform)					{label "Description:"}}
	{enabled_p:text(inform),optional			{label "Enabled:"} {options {{"" "t"}}}}
	{profiling_weight:integer(inform)			{label "Profiling Weight:"}}
	{submit:text(submit)						{label "Delete"}}
} -on_submit {
	# NOTE: at this point, 'delete' permission was already checked above
	db_transaction {
		db_exec_plsql category_delete {}
	} on_error {
		set error_p 1
	}

	# report any error
	if {[exists_and_not_null error_p]} {
		ad_return_complaint 1 {
			An error occured while attempting to delete the category.
			Perhaps other objects are still associated with the category
			or the category has been deleted by another user already while
			you were confirming your action.
		}
		ad_script_abort
	}
} -after_submit {
	# //TODO// use a return_url, use <code>subsite::util::return_url_stack
	# <param>url_list</param></code> see 'ad_maybe_redirect_for_registration'
	# and 'ad_redirect_for_registration' for an example of how to passively
	# extract a return_url and make a call to the proc seem transparent
	if {[empty_string_p $return_url] || [regexp -- "$category_id" $return_url]} {
		set return_url "."
	}
	template::forward $return_url
} -select_query_name category
