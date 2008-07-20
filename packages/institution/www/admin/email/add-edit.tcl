# -*- tab-width: 4 -*-
# /packages/email/www/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing emails.  When creating an
	email address, <code>email_id</code> must not be passed.

	@param			email_id	(optional) the id of the email address you wish to edit
	@param			party_id	(optional) the id of the party you wish to create an email address for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{email_id:naturalnum,optional}
	{party_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"an"
set object_type_key		"email"
set object_type			"Email Address"
set object_type_pl		"Email Addresses"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null email_id]} {
	if {![exists_and_not_null party_id] &&
		[db_0or1row get_party_id {
			select	party_id
			  from	inst_party_emails
			 where	email_id = :email_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $email_id -privilege "delete"]} {
		set email_delete_url	"delete?[export_vars {email_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $email_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set email_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $email_id}}]"
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null email_delete_url] || [exists_and_not_null email_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null party_id]} {
	# check for permission to create an email address for this party
	permission::require_permission -object_id $party_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid email-id when attempting to edit an email address.
		Alternatively, you may indicate a party for which you wish to create
		an email.
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
set email_types				[db_list_of_lists email_types {}]
set email_type_cat_id		[category::find -path [list "Contact Information" "Email"]]

if {[permission::permission_p -object_id "$email_type_cat_id" -privilege "admin"]} {
	set email_type_create_url	"/categories/add-edit?[export_vars -override {{parent_category_id $email_type_cat_id}}]"
	set email_type_create_html "
		<small>
			<a	title=\"Click here to create a new Email Address Type.\"
				href=\"$email_type_create_url\">(Create a new Email Address Type)
			</a>
		</small>
	"
} else {set email_type_create_html ""}

ad_form -name add_edit -export {action return_url step} -form {
	{email_id:key}
	{party_id:integer(hidden)}
	{description:text,optional		{label "Description:"}			}
	{email_type_id:integer(select)	{label "Type:$reqd"}	{options {$email_types}}
		{after_html "$email_type_create_html"}
	}
	{email:text						{label "Email Address:$reqd"}	}
	{submit:text(submit)			{label $user_execute_action}}
	{required:text(inform)			{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "email" \
  -validate {
} -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $email_id -privilege "write"
		db_1row email {}
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
			set title		"$action an $object_type For Yourself"
		} else {
			set title		"$action an $object_type owned by \"$owner_name\""
		}
	}

	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]
} -on_submit {
} -new_data {
	db_transaction {
		# create a new email address
		set email_id [db_exec_plsql email_new {}]
	}
} -edit_data {
	permission::require_permission -object_id $email_id -privilege "write"
	db_transaction {
		db_dml email_edit {}
		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}
