# -*- tab-width: 4 -*-
# /packages/certification/www/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing certifications.  When creating a
	certification, <code>certification_id</code> must not be passed.

	@param			certification_id	(optional) the id of the certification you wish to edit
	@param			party_id			(optional) the id of the party you wish to create a certification for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{certification_id:naturalnum,optional}
	{party_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"a"
set object_type_key		"certification"
set object_type			"Certification"
set object_type_pl		"Certifications"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null certification_id]} {
	if {![exists_and_not_null party_id] &&
		[db_0or1row get_party_id {
			select	party_id
			  from	inst_certifications
			 where	certification_id = :certification_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url		[subsite::party_admin_detail_url -party_id $party_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $certification_id -privilege "delete"]} {
		set certification_delete_url	"delete?[export_vars {certification_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $certification_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set certification_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $certification_id}}]"
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null certification_delete_url] || [exists_and_not_null certification_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null party_id]} {
	# check for permission to create a certification for this party
	permission::require_permission -object_id $party_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid certification when attempting to edit a certification.
		Alternatively, you may indicate a party for which you wish to create
		a certification.
	}
	ad_script_abort
}

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

set context			[list [list "../$object_type_key/" $object_type_pl] $action]
set reqd			{<b style="color: red">*</b>}

# a default value for dates
set now				[template::util::date::today]

# BUILD FORM ###################################################################
set certification_types	[db_list_of_lists certification_types {}]

ad_form -name add_edit -export {action return_url step} -form {
	{certification_id:key}
	{party_id:integer(hidden)}
	{certification_type_id:integer(select)	{label "Type:$reqd"}	{options {$certification_types}}}
	{certifying_party:text,optional			{label "Certifying Party:"}}
	{certification_credential:text,optional	{label "Certification Credential:"}}
	{start_date:date,optional				{label "Effective (Start) Date:"}}
	{certification_date:date,optional		{label "Certification Date:"}}
	{expiration_date:date,optional			{label "Expiration Date:"}}
	{submit:text(submit)					{label $user_execute_action}}
	{required:text(inform)					{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -validate {
	# Make sure expiration-date is after start-date
	{expiration_date	{![exists_and_not_null start_date]
				||	![exists_and_not_null expiration_date]
				||	[expr [clock scan [join [lrange $start_date 0 2] "-"]] \
					<=	  [clock scan [join [lrange $expiration_date 0 2] "-"]]]} {
			[clock format [clock scan [join [lrange $start_date 0 2] "-"]] -format "%B %e, %Y"]
			is not prior to
			[clock format [clock scan [join [lrange $expiration_date 0 2] "-"]] -format "%B %e, %Y"].
			<br>The <q>Start Date</q> must be prior to <q>Expiration Date</q>.
		}
	}
} -edit_request {
	db_1row certification {}

	# convert dates from SQL form to list-form
	set start_date			[split $start_date "-"]
	set certification_date	[split $certification_date "-"]
	set expiration_date		[split $expiration_date "-"]
} -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $certification_id -privilege "write"
		db_1row certification {}
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
	# convert dates from list-form back to default SQL form
	set start_date			[join [lrange $start_date 0 2] "-"]
	set certification_date	[join [lrange $certification_date 0 2] "-"]
	set expiration_date		[join [lrange $expiration_date 0 2] "-"]
} -new_data {
	db_transaction {
		# create a new certification
		set certification_id [db_exec_plsql certification_new {}]
	}
} -edit_data {
	permission::require_permission -object_id $certification_id -privilege "write"
	db_transaction {
		db_dml certification_edit {}
		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}