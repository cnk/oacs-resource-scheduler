
# -*- tab-width: 4 -*-
ad_page_contract {
	Interface for creating new and editting existing categories.  When creating a
	category, <code>category_id</code> must not be passed.

	@param	category_id			(optional) the id of the category you wish to edit
	@param	parent_category_id	(optional) to create a sub-category of this category, use this variable
	@param	show				(optional) the category to expand in the category-tree (passed along to tree.tcl)
	@param	hide				(optional) the category to collapse in the category-tree (passed along to tree.tcl)

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
} {
	{category_id:naturalnum,optional}
	{parent_category_id:naturalnum,optional}
	{show:integer,optional}
	{hide:integer,optional}
	{return_url [get_referrer]}
}

set user_id		[ad_conn user_id]
set peer_ip		[ad_conn peeraddr]
set package_id	[ad_conn package_id]

if {[exists_and_not_null category_id]} {
	# setup some more 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $category_id -privilege "delete"]} {
		set category_delete_url		"delete?[export_vars {category_id}]"
	}

	# Permit
	if {[permission::permission_p -object_id $category_id -privilege "admin"]} {
		set subsite_url	[site_node::get_url -node_id [ad_conn subsite_id]]
		set category_permit_url		"$subsite_url/permissions/one?[export_vars -override {{object_id $category_id}}]"
	}

	set tree_title				"Subcategory"
	set root_category_id		$category_id
	set roots					[db_map direct_subcategories_of]

	set action					"Edit"
	set n_children				0
	set can_delete_or_permit_p	[expr [exists_and_not_null category_delete_url] || [exists_and_not_null category_permit_url]]

	# If the user had a problem with input, this will make the page title read "Edit Your Submission":
	set category_name			"Your Submission"
} else {
	# check for permission to create a subcategory
	if {![exists_and_not_null parent_category_id]} {
		permission::require_permission -object_id $package_id -privilege "create"
	} else {
		permission::require_permission -object_id $parent_category_id -privilege "create"
	}

	set roots					"null"
	set action					"Add"
	set n_children				0
	set can_delete_or_permit_p	0
}

ad_form -name add_edit -form {
	{category_id:key}
	{parent_category_id:integer(hidden),optional}
	{parent_category_name:text(inform)	{label "Parent Category:"}}
	{name:text							{label "Name:"}}
	{plural:text						{label "Plural:"}}
	{description:text,optional			{label "Description:"}}
	{enabled_p:text(checkbox),optional	{label "Enabled:"}	{options {{"" "t"}}}}
	{profiling_weight:integer			{label "Profiling Weight:"}	}
	{return_url:text(hidden)			{value $return_url}}
} -select_query_name "category" \
  -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before being forwarded to the index page.
	if {$action == "Edit"} {
		permission::require_permission -object_id $category_id -privilege "write"
		db_1row category {}
		set category_name		"$name"

		set roots				[db_map direct_subcategories_of]
		set root_category_id	$category_id
		set tree_title			"Subcategory"
	} else {
		# The user requested an 'Add' page
		# setup some default values
		if {[exists_and_not_null parent_category_id]} {
			set parent_category_name [db_string parent_category_name {} -default ""]
			if {$parent_category_name == ""} {
				ad_return_complaint 1 {
					You cannot create a subcategory for the specified category
					since no such category exists.
				}
				ad_script_abort
			}
			set category_name	"a Subcategory to <i>$parent_category_name</i>"
		} else {
			set category_name	"a Top-level Category"
		}

		set n_children			0
		set enabled_p			"t"
		set profiling_weight	1
	}
} -on_submit {
	if {![exists_and_not_null enabled_p]} {
		set enabled_p "f"
	}
} -new_data {
	db_transaction {
		if {![exists_and_not_null parent_category_id]} {
			# create a root-level category
			set category_id [db_exec_plsql category_new {}]
		} else {
			# create a subcategory
			set category_id [db_exec_plsql subcategory_new {}]
		}
	} on_error {
		set error_p 1
	}

	if {[exists_and_not_null error_p]} {
		ad_return_complaint 1 {
			An error occurred while attempting to create the Category.
			There may already be a category with that name and parent-category.
		}
		ad_script_abort
	}
} -edit_data {
	permission::require_permission -object_id $category_id -privilege "write"
	db_transaction {
		db_dml category_edit {}
		db_dml category_update_last_modified {}
	}
} -after_submit {
	template::forward $return_url
}