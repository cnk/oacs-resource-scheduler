# -*- tab-width: 4 -*-
# /packages/party-image/www/delete.tcl
ad_page_contract {
	This is the delete-confirmation page for the party_image objects.

	@param	image_id			the id of the party_image you wish to delete

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/13
	@cvs-id			$Id: delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{image_id:naturalnum,notnull}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set object_type_key	"party-image"
set object_type		"Party Image"
set object_type_pl	"Party Images"
set action			"Delete"
set context			[list [list "../$object_type_key/" $object_type_pl] $action]
set user_id			[ad_conn user_id]
set package_id		[ad_conn package_id]

# see if we are looking at a party_image that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row party_image {}] <= 0} {
	ad_return_complaint 1 "Party Image does not exist (it may exist in other contexts)."
	ad_script_abort
}

if {!$delete_p} {
	permission::require_permission -object_id $image_id -privilege "delete"
}

set party_detail_url		[subsite::party_admin_detail_url -party_id $party_id]
set image_view_url			"[ad_conn package_url]party-image-view?[export_vars {image_id}]"
set image_view_html			"<img src=\"$image_view_url\"/><br>"

# set the title
if {$user_id == $party_id} {
	set title	"$action Your $object_type \"$description\""
} else {
	set title	"$action the $object_type \"$description\" owned by \"$owner_name\""
}

set can_change_this_party_image_p 0

# require 'write' on current party_image to allow editting:
if {$write_p} {
	set party_image_edit_url "add-edit?[export_vars {image_id}]"
	incr can_change_this_party_image_p
} else {
	set party_image_edit_url ""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
	set party_image_permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $image_id}}]"
	incr can_change_this_party_image_p
} else {
	set party_image_permit_url ""
}

ad_form -name delete -export {return_url step} -form {
	{image_id:key}
	{image_file:text(inform)		{label "Image:"}	{before_html $image_view_html}}
	{description:text(inform)		{label "NAME:"}	}
	{image_type_name:text(inform)	{label "Type:"} 		}
	{format:text(inform)			{label "Format:"}}
	{submit:text(submit)			{label $action}}
} -on_request {
	set format [cr_registered_type_for_mime_type $format]
#	ns_returnnotice 200 "OK" $format
} -on_submit {
	# NOTE: at this point, 'delete' permission was already checked above
	db_transaction {
		db_exec_plsql party_image_delete {}
	} on_error {
		set error_p 1
	}

	# report any error
	if {[exists_and_not_null error_p]} {
		ad_return_complaint 1 {
			An error occured while attempting to delete the party-image.
			Perhaps other objects are still associated with the party-image
			or the party_image has been deleted by another user already while
			you were confirming your action.
		}
		ad_script_abort
	}
} -after_submit {
	# //TODO// use a return_url, use <code>subsite::util::return_url_stack
	# <param>url_list</param></code> see 'ad_maybe_redirect_for_registration'
	# and 'ad_redirect_for_registration' for an example of how to passively
	# extract a return_url and make a call to the proc seem transparent
	if {[empty_string_p $return_url] || [regexp -- "$image_id" $return_url]} {
		set return_url $party_detail_url
	}
	template::forward $return_url
} -select_query_name party_image