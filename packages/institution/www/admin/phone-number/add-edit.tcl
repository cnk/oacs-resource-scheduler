# -*- tab-width: 4 -*-
# /packages/institution/www/phone-number/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing phones.  When creating a
	phone-number, <code>phone_id</code> must not be passed.

	@param			phone_id	(optional) the id of the phone-number you wish to edit
	@param			party_id	(optional) the id of the party you wish to create an phone-number for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 03:27:05 andy Exp $
} {
	{phone_id:naturalnum,optional}
	{party_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"a"
set object_type_key		"phone-number"
set object_type			"Phone Number"
set object_type_pl		"Phone Numbers"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null phone_id]} {
	if {![exists_and_not_null party_id] &&
		[db_0or1row get_party_id {
			select	party_id
			  from	inst_party_phones
			 where	phone_id = :phone_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $phone_id -privilege "delete"]} {
		set phone_delete_url	"delete?[export_vars {phone_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $phone_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set phone_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $phone_id}}]"
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null phone_delete_url] || [exists_and_not_null phone_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null party_id]} {
	# check for permission to create an phone-number for this party
	permission::require_permission -object_id $party_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid phone-number-id when attempting to edit an phone-number.
		Alternatively, you may indicate a party for which you wish to create a phone-number.
	}
	ad_script_abort
}

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

set context			[list [list "../$object_type_key/" $object_type_pl] $action]
set reqd			{<b style="color: red">*</b>}

# BUILD FORM ###################################################################
set phone_types	[db_list_of_lists phone_types {}]

ad_form -name add_edit -export {action return_url step} -form {
	{phone_id:key														}
	{party_id:integer(hidden)											}
	{description:text,optional			{label "Description:"}			}
	{phone_type_id:integer(select)		{label "Type:$reqd"}		{options {$phone_types}}}
	{phone_number:text					{label "Phone Number:$reqd"}	}
	{phone_priority_number:integer		{label "Priority: "}		{value 0}}
	{submit:text(submit)				{label $user_execute_action}}
	{required:text(inform)				{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "phone" \
  -validate {
} -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $phone_id -privilege "write"
		db_1row phone {}
		if {$user_id == $party_id} {
			set title		"$action Your $object_type \"$description\""
		} else {
			set title		"$action the $object_type \"$description\" owned by \"$owner_name\""
		}
	} else {
		# The user requested an 'Add' page
		# setup some default values

		# this goes in the page title
		set owner_name [db_string party_name {select acs_object.name(:party_id) from dual}]
		if {$user_id == $party_id} {
			set title		"$action a $object_type For Yourself"
		} else {
			set title		"$action a $object_type owned by \"$owner_name\""
		}
	}

	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]
} -on_submit {
} -new_data {
	db_transaction {
		# create a new phone-number
		set phone_id [db_exec_plsql phone_new {}]
	}
} -edit_data {
	permission::require_permission -object_id $phone_id -privilege "write"
	db_transaction {
		db_dml phone_edit {}
		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}
