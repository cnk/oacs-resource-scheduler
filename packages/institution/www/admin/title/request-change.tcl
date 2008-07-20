# -*- tab-width: 4 -*-
# /web/ucla/packages/institution/www/admin/title/request-change.tcl
ad_page_contract {
	This page allows a personnel to request that a change be made to a title
	which they do not have privileges on but are nonetheless associated with.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2004-12-09 11:20
	@cvs-id			$Id: request-change.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} -query {
	{gpm_title_id:naturalnum,optional}
	{acs_rel_id:naturalnum,optional}
	{title_id:naturalnum,optional}
	{personnel_id:naturalnum,optional}
	{group_id:naturalnum,optional}
	{change}
	{step:integer,optional}
	{return_url	[get_referrer]}
}

set indefinite_article	"a"
set object_type			"Title"
set obj_type_pl			"Titles"
set object_key			"title"
append obj_mgmt_url		[util_current_location] [ad_conn package_url] "admin/$object_key/"
set context				[list $obj_type_pl]

set user_id				[ad_conn user_id]
set package_id			[ad_conn package_id]
set subsite_id			[ad_conn subsite_id]
set subsite_url			[site_node::get_url_from_object_id -object_id $subsite_id]	;# this variable is used to build proper URLs for managing permissions

# For building the form...
set none				[list {[<i>None</i>]}]
set reqd				{<b style="color: red">*</b>}

# Get details about the personnel and user.  If possible, also get details about
#	title and group, otherwise build widgets to let the user select these things.
if {[exists_and_not_null gpm_title_id]} {
	set acs_rel_id	""
	set title_id	""
	if {[db_0or1row title_details {}] != 1} {
		ad_return_complaint 1 "The person or title you wanted to change does not exist."
		return
	}
}

# Setup some words which can be integrated into the subject and message
switch -- $change {
	"create" -
	"add" {
		set change				"create"
		set change_past_tense	"created"
		set approve_url			{${obj_mgmt_url}add-edit?[export_vars {title_id personnel_id group_id}]}

		# Remember: any references to variables here will not be evaluated until ad_form is called below...
		set title_id_widget	{
			{user_selected_title_id:integer(select)
				{label "Title:$reqd"}
				{options {$titles}}
			}
		}
		set group_id_widget	{
			{user_selected_group_id:integer(select)
				{label "Group:$reqd"}
				{options {$groups}}
			}
		}
		set comments			"**Replace this with a description of the title that should be created.**"
	}

	"modify" -
	"edit" {
		set change				"modify"
		set change_past_tense	"modified"
		set approve_url			{${obj_mgmt_url}add-edit?[export_vars {gpm_title_id}]}

		# Remember: any references to variables here will not be evaluated until ad_form is called below...
		set title_id_widget		{ {user_selected_title_id:text(inform) {value ""}} }
		set group_id_widget		{ {user_selected_group_id:text(inform) {value "'$group_name' (to change this, request a new title instead)"}} }
		set comments			"**Replace this with a description of the change that should be made.**"
	}

	"delete" {
		set change				"delete"
		set change_past_tense	"deleted"
		set approve_url			{${obj_mgmt_url}delete?[export_vars {gpm_title_id}]}

		set title_id_widget		{ {user_selected_title_id:text(inform) {value ""}} }
		set group_id_widget		{ {user_selected_group_id:text(inform) {value ""}} }
	}

	"permit" {
	}

	default {
		ad_return_complaint 1 "The change you are requesting is not supported. ($change)"
		return
	}
}

if {[exists_and_not_null acs_rel_id]	&&
	[exists_and_not_null title_id]} {
	set gpm_title_id ""
	if {[db_0or1row title_details {}] != 1} {
		ad_return_complaint 1 "The person or title you wanted to change does not exist."
		return
	}

	if {$user_id == $personnel_id} {
		set user_is_personnel_p 1
	} else {
		set user_is_personnel_p 0
	}

	################################################################################
	# Setup the Messages: ##########################################################
	set subject "Faculty Database: Request to $change the $object_type '$title' of '$personnel_name' in the $group_type '$group_name'"

	set basic_message_preamble "
$user_name is requesting that the $object_type '$title' of
'$personnel_name' in the $group_type of '$group_name' be $change_past_tense.
"

	# Observer Message
	#-This email is to serve as a notice only.  You are not required to take any
	#-action for this request.
	append observer_message $basic_message_preamble "
If this request was made in error, please contact $user_name at
$user_email"

	if {$user_is_personnel_p} {
		append observer_message ".\n\n"
	} else {
		append observer_message ".\n\n"
		#append observer_message ", and $personnel_name at $personnel_email"
		#, \$group_admin_emails.\n\n"
	}

	# Administrator Message
	append administrator_message $basic_message_preamble "
As a Faculty Database administrator of the $group_type '$group_name', you
are permitted to make this change.  Please coordinate changes with any other
administrators as appropriate.

If this request is to be approved, you may begin carrying it out here:
	[subst $approve_url]

The above URL will show some details and you will be asked to confirm the change.

Please send any response to this request to $user_name at $user_email"

	if {$user_is_personnel_p} {
		append administrator_message ".\n\n"
	} else {
		append administrator_message " and notify $personnel_name at $personnel_email
as appropriate.\n\n"
	}
} elseif {[exists_and_not_null personnel_id]} {
	if {[db_0or1row observer_details {}] < 1} {
		ad_return_complaint 1 "The person you are requesting a new title for does not exist."
		return
	}

	# //TODO//
	set subject					"
$user_name is requesting that $indefinite_article $object_type be created for
'$personnel_name'.
"
	set observer_message		""
	set administrator_message	"[subst $approve_url]"

	# Setup options for the title widget (see above for widget declaration)
	set titles		[db_list_of_lists possible_titles {}]
	set titles		[tree::sorter::sort_list_of_lists -list $titles]

	# Setup options for the group widget (see above for widget declaration)
	set groups		[db_list_of_lists subsite_groups {}]
	set groups		[tree::sorter::sort_list_of_lists -list $groups]
	#-linsert $groups end [list {[<i>Other</i>]}]
} else {
	ad_return_complaint 1 "There is not enough information to make your request."
	return
}

# Require administrative privileges over the personnel which the title is for
# NOTE: This is not exactly the same as being a department admin with admin
#	privileges over the person (a case where they could probably make the change
#	instead of merely requesting that it be made).
if {!$admin_p} {
	permission::require_permission -object_id $personnel_id -privilege "admin"
}

################################################################################
# Recipients of Request: #######################################################
#	User who made request
#	Personnel who request was about (if different from user)
#	Group Admins who are not simply Faculty Database maintainers
#	CTRL
set observers		[list ]
set administrators	[db_list_of_lists group_administrative_contacts {}]

if {[llength $administrators] > 1} {
	linsert $administrators 0 [list {[<i>Pick One For Me</i>]}]
#-	set to_widget {{to:text(select),optional	{options {$administrators}}}}
	set to_widget {{to:text(inform) {value ""}}}
} else {
	set to_widget {{to:text(inform) {value ""}}}
}

set user_execute_action	"Send Request"
if {[exists_and_not_null step]} {
	append user_execute_action " & Return to Step $step"
}

set party_detail_url		[subsite::party_admin_detail_url -party_id $personnel_id]

################################################################################
# Build the Form ###############################################################
ad_form -name request_change -export {
	acs_rel_id
	title_id
	personnel_id
	group_id
	change
	return_url
} -form [append form_widgets $title_id_widget $group_id_widget $to_widget {
	{comments:text(textarea),optional	{label "Comments:"} {html {rows 10 cols 60}}}
	{action:text(submit)				{label $user_execute_action}}
}] -on_request {
} -validate {
#-	{to 1
#-		"The administrator you selected is not appropriate."
#-	}
} -on_submit {
	# Add comments to final message
	if {[exists_and_not_null comments]} {
		append administrator_message "\n\nThe comments of $user_name follow:\n\n" $comments
	}

	# Set Administrative Contact:
	#	if user did not make a choice, make a random choice
	#	else send only to that administrator and CTRL

	set recipients "fdb-support@ctrl.ucla.edu"
	foreach administrator $administrators {
		append admin_recipients "," [lindex $administrator 1]
	}

#-	ns_sendmail $admin_recipients $user_email $subject $administrator_message
#-	ns_sendmail $observers $user_email $subject $observer_message
	ns_sendmail "fdb-support@ctrl.ucla.edu" $user_email $subject $administrator_message
#	ns_returnnotice 200 $subject $administrator_message
#	ns_sendmail "helsleya@cs.ucr.edu" $user_email $subject $administrator_message
} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url [subsite::party_admin_detail_url -party_id $personnel_id]
	}

	template::forward $return_url
}

