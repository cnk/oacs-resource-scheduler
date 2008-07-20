# -*- tab-width: 4 -*-
# /packages/title/www/delete.tcl
ad_page_contract {
	This is the delete-confirmation page for the title objects.

	@param	title_id			the id of the title you wish to delete

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/11/17
	@cvs-id			$Id: delete.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{gpm_title_id:naturalnum,notnull}
	{return_url [get_referrer]}
}

set object_type			"Title"
set object_type_plural	"Titles"
set context				[list [list "../title/" $object_type_plural] "Delete"]
set user_id				[ad_conn user_id]
set package_id			[ad_conn package_id]

# see if we are looking at a title that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row title {}] <= 0} {
	ad_return_complaint 1 "Title does not exist (it may exist in other contexts)."
	ad_script_abort
}

if {!$delete_p} {
	permission::require_permission -object_id $acs_rel_id -privilege "delete"
}

set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]

# set the page_title
if {$user_id == $personnel_id} {
	set page_title	"Delete Your $object_type \"$description\""
} else {
	set page_title	"Delete the $object_type \"$description\" owned by \"$owner_name\""
}

set can_change_this_title_p 0

# require 'write' on current title to allow editting:
if {$write_p} {
	set title_edit_url "add-edit?[export_vars {acs_rel_id title_id}]"
	incr can_change_this_title_p
} else {
	set title_edit_url ""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
	set title_permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $acs_rel_id}}]"
	incr can_change_this_title_p
} else {
	set title_permit_url ""
}


ad_form -name delete -export {return_url step} -form {
	{gpm_title_id:key}
	{title:text(inform)						{label "Title:"}			}
	{group_name:text(inform)				{label "Group:"}			}
	{pretty_title:text(inform)		   		{label "Display As:"}		}
	{status:text(inform)					{label "Status:"}			}
	{leader_p:text(inform)					{label "Leader?:"}			}
	{start_date:date(inform)				{label "Start Date"}		}
	{end_date:date(inform)					{label "End Date"}			}
	{title_priority_number:integer(inform)	{label "Display Order:"}	}
	{submit:text(submit)					{label "Delete"}			}
} -select_query_name "title" -on_request {
	db_1row title {}
	set group_url "../groups/detail?[export_vars {group_id}]"
} -on_submit {
	# NOTE: at this point, 'delete' permission was already checked above
	db_transaction {
		db_exec_plsql title_delete {}
	}
} -after_submit {
	# //TODO// use a return_url, use <code>subsite::util::return_url_stack
	# <param>url_list</param></code> see 'ad_maybe_redirect_for_registration'
	# and 'ad_redirect_for_registration' for an example of how to passively
	# extract a return_url and make a call to the proc seem transparent
	if {[empty_string_p $return_url] || [regexp -- "$gpm_title_id" $return_url]} {
		set return_url $party_detail_url
	}
	template::forward "$return_url"
}
