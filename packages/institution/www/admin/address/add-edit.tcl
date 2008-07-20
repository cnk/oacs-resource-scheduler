# -*- tab-width: 4 -*-
# /packages/address/www/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing addresses.  When creating a
	address, <code>address_id</code> must not be passed.

	@param			address_id	(optional) the id of the address you wish to edit
	@param			party_id	(optional) the id of the party you wish to create an address for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{address_id:naturalnum,optional}
	{party_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"an"
set object_type_key		"address"
set object_type			"Address"
set object_type_pl		"Addresses"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null address_id]} {
	if {![exists_and_not_null party_id] &&
		[db_0or1row get_party_id {
			select	party_id
			  from	inst_party_addresses
			 where	address_id = :address_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $address_id -privilege "delete"]} {
		set address_delete_url	"delete?[export_vars {address_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $address_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set address_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $address_id}}]"
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null address_delete_url] || [exists_and_not_null address_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null party_id]} {
	# check for permission to create an address for this party
	permission::require_permission -object_id $party_id -privilege "create"

	set action					"Add"
	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid address when attempting to edit an address.
		Alternatively, you may indicate a party for which you wish to create
		an address.
	}
	ad_script_abort
}

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

set context			[list [list "../$object_type_key/" $object_type_pl] $action]
set reqd			{<b style="color: red">*</b>}
set none			[list {[<i>None</i>]}]

# BUILD FORM ###################################################################
#-set UNUSED_DEFAULT [db_string locale_language {select select sys_context('USERENV', 'NLS_TERRITORY') from dual}]	#'AMERICA'
set address_types	[db_list_of_lists address_types {}]
set states			[linsert [db_list_of_lists states {}] 0 $none]
set countries		[linsert [db_list_of_lists countries {}] 0 $none]

ad_form -name add_edit -export {action return_url step} -form {
	{address_id:key													}
	{party_id:integer(hidden)										}
	{description:text,optional			{label "Description:"}		}
	{address_type_id:integer(select)	{label "Type:$reqd"} 	{options {$address_types}}}
	{building_name:text,optional		{label "Building Name:"}	}
	{room_number:text,optional			{label "Room Number:"}		}
	{address_line_1:text				{label "Address Line 1:$reqd"}	}
	{address_line_2:text,optional		{label "Address Line 2:"}	}
	{address_line_3:text,optional		{label "Address Line 3:"}	}
	{address_line_4:text,optional		{label "Address Line 4:"}	}
	{address_line_5:text,optional		{label "Address Line 5:"}	}
	{city:text,optional					{label "City:"}				}
	{fips_state_code:text(select),optional	{label "State:"}		{options {$states}}}
	{zipcode:text,optional				{label "Zipcode:"}			}
	{zipcode_ext:text,optional			{label "Zipcode Ext:"}		}
	{fips_country_code:text(select),optional	{label "Country:"}	{options {$countries}}}
	{submit:text(submit)				{label $user_execute_action}}
	{required:text(inform)				{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "address" \
  -validate {
	# Make sure the supplied zipcode is consistent with the given state
	{fips_state_code
		{![exists_and_not_null zipcode] || [db_string state_and_zip_consistent {
				select	1
				  from	us_zipcodes
				 where	fips_state_code = :fips_state_code
				   and	zipcode			= :zipcode
				} -default 0]} {
			The zipcode you specified does not exist within the state you specified.
		  }
	}

	# Make sure zipcode_ext is either empty or 4 digits
	{zipcode_ext
		{[string length $zipcode_ext] == 0
			|| [regexp "\[0-9\]{4,4}" $zipcode_ext]}
		{<code>Zipcode Ext.</code> must be exactly four digits
			or it must be left empty.}
	}

} -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $address_id -privilege "write"
		db_1row address {}
		if {$user_id == $party_id} {
			set title		"$action Your $object_type \"$description\""
		} else {
			set title		"$action the $object_type \"$description\" owned by \"$owner_name\""
		}
	} else {
		# The user requested an 'Add' page
		# setup some default values
		set fips_country_code	"US"

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
		# create a new address
		set address_id [db_exec_plsql address_new {}]
	}
} -edit_data {
	permission::require_permission -object_id $address_id -privilege "write"
	db_transaction {
		db_dml address_edit {}
		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}
