# -*- tab-width: 4 -*-
ad_page_contract {
	Interface for creating new and editting existing groups.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/21
	@cvs-id			$Id: add-edit.tcl,v 1.6 2007/05/08 20:29:54 andy Exp $
} {
	{group_id:naturalnum,optional}
	{parent_group_id:naturalnum,optional}
	{return_url [get_referrer]}
}

set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set subsite_id			[ad_conn subsite_id]
set package_id			[ad_conn package_id]
set package_admin_p		[permission::permission_p -object_id $package_id -privilege admin]
set sitewide_admin_p	[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]

if {[info exists group_id]} {
	set action_overview "Edit"
	set action "Edit"

	# setup some more 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $group_id -privilege "delete"]} {
		set group_delete_url		"delete?[export_vars {group_id}]"
	}

	# Permit
	if {[permission::permission_p -object_id $group_id -privilege "admin"]} {
		set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set group_permit_url		"${subsite_url}permissions/one?[export_vars -override {{object_id $group_id}}]"
	}

	set possible_parents_filter	[db_map possible_parents_filter__no_descendants]
	set existing_parent_p		{group_id = (select parent_group_id from inst_groups where group_id = :group_id)}
	set can_delete_or_permit_p	[expr [exists_and_not_null group_delete_url] || [exists_and_not_null group_permit_url]]
} else {
	set action_overview "Create"

	# check for permission to create a subgroup
	if {![exists_and_not_null parent_group_id]} {
		set action "$action_overview a Top-level "
		permission::require_permission -object_id $package_id -privilege "create"
	} else {
		set action "$action_overview a Subgroup of "
		permission::require_permission -object_id $parent_group_id -privilege "create"
	}

	set possible_parents_filter	[db_map possible_parents_filter__any]
	set existing_parent_p		{0 = 0}
	set can_delete_or_permit_p	0
}

set title	"$action Group"
set context	[list [list "../groups/" "Groups"] $action_overview]
set reqd	{<b style="color: red">*</b>}
set none	[list {[<i>None</i>]}]

set group_types			[db_list_of_lists group_types {}]
set group_types			[tree::sorter::sort_list_of_lists -list $group_types]

# Possible parents should _always_ include current alias
set possible_parents	[db_list_of_lists possible_parents {}]
set possible_parents	[tree::sorter::sort_list_of_lists -list $possible_parents]
# scan tree for group_id == parent_group_id
if {[info exists group_id]
	&& [db_0or1row existing_groups_parent_group_id {
		select	parent_group_id						as parent_group_id,
				acs_object.name(parent_group_id)	as parent_group
		  from	inst_groups
		 where	group_id		= :group_id
		   and	parent_group_id	is not null
	}] == 1} {

	set found_current_parent_p 0
	foreach g $possible_parents {
		set g_group_id [lindex $g 1]
		if {$g_group_id == $parent_group_id} {
			set found_current_parent_p 1
			break
		}
	}

	# put the current parent in as a possible_parent at the top of the list
	if {!$found_current_parent_p} {
		set possible_parents		[linsert $possible_parents 0 [list $parent_group $parent_group_id]]
	}
}
if {$package_admin_p} {
	set possible_parents			[linsert $possible_parents 0 $none]
}

# //TODO// only display alias-for widget if the user is a package admin?
# Make sure current alias is in the list of possible aliases
set existing_parent_p "1=1"
set possible_parents_filter	[db_map possible_parents_filter__any]
set possible_aliases		[db_list_of_lists possible_parents {}]
set possible_aliases		[tree::sorter::sort_list_of_lists -list $possible_aliases]
set possible_aliases		[linsert $possible_aliases 0 $none]

if {[info exists group_id]
	&& [db_0or1row existing_groups_alias_for_group_id {
		select	alias_for_group_id					as alias_for_group_id,
				acs_object.name(alias_for_group_id)	as alias_for_group_name
		  from	inst_groups
		 where	group_id			= :group_id
		   and	alias_for_group_id	is not null
	}] == 1} {

	set found_current_alias_p 0
	foreach g $possible_aliases {
		set g_group_id [lindex $g 1]
		if {$g_group_id == $alias_for_group_id} {
			set found_current_alias_p 1
			break
		}
	}

	# put the current alias in as a possible_alias at the top of the list
	if {!$found_current_alias_p} {
		# NOTE: when package_admin_p == 1, the 'None' item was inserted, so we want to linsert at index 1, not index 0
		set possible_aliases	[linsert $possible_aliases $package_admin_p [list $alias_for_group_name $alias_for_group_id]]
	}
}

ad_form -name add_edit -form {
	{group_id:key}
	{group_name:text						{label "Name:$reqd"}	}
	{short_name:text,optional
		{label "Short Name:"}
		{tooltip {This is a short version of the name of the group.  Sometimes it is appropriate to place an acronym here.  Other times, it is most appropriate to use the same value as is in the 'Name' field.}}
		{help_url ../../doc}										}
	{parent_group_id:integer(select),optional
											{label "Parent Group: "}
											{options {$possible_parents}}}
	{group_type_id:integer(select)			{label "Type:$reqd"}	{options {$group_types}}}
	{group_priority_number:integer			{label "Priority: "}	{value 0}}
	{description:text(textarea),optional	{label "Description:"}	{html {rows 10 cols 50}}}
	{keywords:text,optional					{label "Keywords:"}		}
	{alias_for_group_id:integer(select),optional
											{label "Alias For Group: "}
											{options {$possible_aliases}}}
	{return_url:text(hidden)				{value $return_url}}
	{required:text(inform)					{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "group" \
  -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before being forwarded to the index page.
	if {$action == "Edit"} {
		permission::require_permission -object_id $group_id -privilege "write"
		#-set parent_group_url "detail?[export_vars -override {{group_id $parent_group_id}}]"
	} else {
		# The user requested an 'Add' page
		# setup some defaults
	}
} -new_data {
	# //TODO// verify 'read' permission on group_type_id

	db_transaction {
		if {![exists_and_not_null parent_group_id]} {
			# create a root-level group
			set group_id [db_exec_plsql group_new {}]
		} else {
			# create a subgroup
			set group_id [db_exec_plsql subgroup_new {}]
		}

		# update description
		db_dml update_group_description {} -clobs [list $description]
	} on_error {
		set error_p 1
	}

	# output a nice error message if the name was not unique WRT the parent group
	if {[exists_and_not_null error_p]} {
		if {[regexp -nocase "unique constraint.*inst_grp_shrt_nm_prnt_un\\) violated" \
				 $errmsg]} {

			if {[exists_and_not_null parent_group_id]} {
				db_1row type_info {}
				ad_return_complaint 1 "
					There is already a <i>$sibling_group_type_name</i> with the short-name
					<i>$short_name</i> in the <i>$parent_group_type_name</i> named <i>$parent_name</i>.
					Please choose another name for your new <i>$group_type_name</i>.
				"
			} else {
				db_1row root_type_info {}
				ad_return_complaint 1 "
					There is already a top-level <i>$sibling_group_type_name</i> with the short-name
					<i>$short_name</i>.  Please choose another name for your new <i>$group_type_name</i>.
				"
			}
			ad_script_abort
		}

		ad_return_error "Unexpected" "
			An unexpected error occurred while processing your request.  The
			website maintainers have been notified of the problem.
		"
		ad_script_abort
	}
} -edit_data {
	permission::require_permission -object_id $group_id -privilege "write"

	db_transaction {
		db_exec_plsql reconcile_compositon_rels {}
		db_dml group_edit {} -clobs [list $description]
		db_dml acs_group_update {}
		db_dml object_modified {}
	} on_error {
		set error_p 1
	}

	# output a nice error message if the name was not unique WRT the parent group
	if {[exists_and_not_null error_p]} {
		if {[regexp -nocase "unique constraint.*inst_grp_shrt_nm_prnt_un\\) violated" \
				 $errmsg]} {
			if {[exists_and_not_null parent_group_id]} {
				db_1row type_info {}
				ad_return_complaint 1 "
					There is already a <i>$sibling_group_type_name</i> with the short-name
					<i>$short_name</i> in the <i>$parent_group_type_name</i> named <i>$parent_name</i>.
					Please choose another name for the <i>$group_type_name</i> you were editing.
				"
			} else {
				db_1row root_type_info {}
				ad_return_complaint 1 "
					There is already a top-level <i>$sibling_group_type_name</i> with the short-name
					<i>$short_name</i>.  Please choose another name for the <i>$group_type_name</i>
					you were editing.
				"
			}
			ad_script_abort
		}

		ad_return_error "Unexpected" "
			An unexpected error occurred while processing your request.  The
			website maintainers have been notified of the problem.
		"
		ad_script_abort
	}

} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url "detail?[export_vars {group_id}]"
	}
	template::forward $return_url
}
