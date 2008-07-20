# -*- tab-width: 4 -*-
ad_page_contract {
	This is the delete-confirmation page for the group objects.
	It displays a tree of subgroups that will also be deleted
	when deleting the group.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/21
	@cvs-id			$Id: delete.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{group_id:naturalnum}
	{show:integer,optional}
	{hide:integer,optional}
	{return_url	[get_referrer]}
}

set context		[list [list "../groups/" "Groups"] "Delete"]
set title		"Delete Group"
set user_id		[ad_conn user_id]
set peer_ip		[ad_conn peeraddr]
set package_id	[ad_conn package_id]
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# see if we are looking at a group that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row group {}] <= 0} {
	ad_return_complaint 1 "Group does not exist (it may exist in other contexts)."
	return
}

if {!$delete_p} {
	permission::require_permission -object_id $group_id -privilege "delete"
}

set roots					[db_map direct_subgroups_of]
set root_group_id		    $group_id
set tree_title				"Subgroups:"

set group_edit_url			""
set subgroup_create_url		""
set group_permit_url		""

# do not allow creation of groups from the delete page (that would be weird)
array set allow_action_p {
	view	1
	edit	1
	delete	1
	permit	1
}

# require 'write' on current group to allow editting:
if {$write_p} {
	set group_edit_url "add-edit?[export_vars {group_id}]"
}

# require 'create' on current group to create sub-groups:
if {$create_p} {
	set subgroup_create_url	"add-edit?[export_vars -override {{parent_group_id $group_id}}]"
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set group_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $group_id}}]"
}

# See if the user can perform any actions on the current group.
set can_change_this_group_p [expr $create_p || $write_p || $admin_p]

ad_form -name delete -form {
	{group_id:key														}
	{group_name:text(inform)					{label "Name:"}			}
	{short_name:text(inform),optional			{label "Short Name:"}	}
	{parent_group_name:text(inform),optional	{label "Parent Group:"}	}
	{group_type_name:text(inform)				{label "Type:"} 		}
	{description:text(inform),optional			{label "Description:"}	}
	{submit:text(submit)						{label "Delete"}		}
	{return_url:text(hidden)					{value $return_url}}
} -on_submit {
	set action "$submit"
	set error_p 0
	db_transaction {
		# Delete rels associating the group to other groups, personnel, and
		#	anything else.
		db_exec_plsql	acs_rels_delete {}
		db_dml			jccc_group_delete {}
		db_exec_plsql	group_delete {}
		db_dml			touch_package_mtime {}
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if {$error_p} {
		ad_return_error "Error" "
			There was an error deleting the group.  Please note that you must
			unassociate all personnel who are in this group before you can
			delete the group. <p> $errmsg
		"
		ad_script_abort
	}
} -after_submit {
	if {[empty_string_p $return_url] || [regexp -- "$group_id" $return_url]} {
		if {[exists_and_not_null parent_group_id]} {
			set return_url "detail?[export_vars -override {{group_id $parent_group_id}}]"
		} else {
			set return_url "."
		}
	}
	template::forward $return_url
} -select_query_name group
