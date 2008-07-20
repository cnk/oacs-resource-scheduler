# -*- tab-width: 4 -*-
# /packages/address/www/delete.tcl
ad_page_contract {
	This is the delete-confirmation page for the address objects.

	@param	address_id			the id of the address you wish to delete

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/13
	@cvs-id			$Id: delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{address_id:naturalnum,notnull}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set object_type_key	"address"
set object_type		"Address"
set object_type_pl	"Addresses"
set action			"Delete"
set context			[list [list "../$object_type_key/" $object_type_pl] $action]
set user_id			[ad_conn user_id]
set package_id		[ad_conn package_id]

# see if we are looking at a address that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row address {}] <= 0} {
	ad_return_complaint 1 "Address does not exist (it may exist in other contexts)."
	ad_script_abort
}

if {!$delete_p} {
	permission::require_permission -object_id $address_id -privilege "delete"
}

set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]

# set the title
if {$user_id == $party_id} {
	set title	"$action Your $object_type \"$description\""
} else {
	set title	"$action the $object_type \"$description\" owned by \"$owner_name\""
}

set can_change_this_address_p 0

# require 'write' on current address to allow editting:
if {$write_p} {
	set address_edit_url "add-edit?[export_vars {address_id}]"
	incr can_change_this_address_p
} else {
	set address_edit_url ""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
	set address_permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $address_id}}]"
	incr can_change_this_address_p
} else {
	set address_permit_url ""
}

ad_form -name delete -export {return_url step} -form {
	{address_id:key}
	{description:text(inform)		{label "Description:"}		}
	{address_type_name:text(inform)	{label "Type:"} 			}
	{building_name:text(inform)		{label "Building Name:"}	}
	{room_number:text(inform)		{label "Room Number:"}		}
	{address_line_1:text(inform)	{label "Address Line 1:"}	}
	{address_line_2:text(inform)	{label "Address Line 2:"}	}
	{address_line_3:text(inform)	{label "Address Line 3:"}	}
	{address_line_4:text(inform)	{label "Address Line 4:"}	}
	{address_line_5:text(inform)	{label "Address Line 5:"}	}
	{city:text(inform)				{label "City:"}				}
	{state_name:text(inform)		{label "State:"}			}
	{zipcode:text(inform)			{label "Zipcode:"}			}
	{zipcode_ext:text(inform)		{label "Zipcode Ext:"}		}
	{country_name:text(inform)		{label "Country:"}			}
	{submit:text(submit)			{label $action}}
} -on_submit {
	# NOTE: at this point, 'delete' permission was already checked above
	db_transaction {
		db_exec_plsql address_delete {}
	} on_error {
		set error_p 1
	}

	# report any error
	if {[exists_and_not_null error_p]} {
		ad_return_complaint 1 {
			An error occured while attempting to delete the address.
			Perhaps other objects are still associated with the address
			or the address has been deleted by another user already while
			you were confirming your action.
		}
		ad_script_abort
	}
} -after_submit {
	# //TODO// use a return_url, use <code>subsite::util::return_url_stack
	# <param>url_list</param></code> see 'ad_maybe_redirect_for_registration'
	# and 'ad_redirect_for_registration' for an example of how to passively
	# extract a return_url and make a call to the proc seem transparent
	if {[empty_string_p $return_url] || [regexp -- "$address_id" $return_url]} {
		set return_url $party_detail_url
	}
	template::forward "$return_url"
} -select_query_name address
