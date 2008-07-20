# -*- tab-width: 4 -*-
# /web/ucla/packages/institution/www/admin/title/request-add.tcl
ad_page_contract {
	Allows someone to request that a new title be created.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-03-08 15:29 PST
	@cvs-id			$Id: request-add.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} -query {
	personnel_id:naturalnum
}

set indefinite_article	"an"
set object_type_key		"title"
set object_type			"Title"
set object_type_pl		"Titles"
set context				[list $object_type_pl]

set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_id			[ad_conn subsite_id]
set subsite_url			[site_node_closest_ancestor_package_url]

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]
db_1row					basic_info {}

# For building the form ########################################################
set none				[list {[<i>None</i>]}]
set other				[list {[<i>Other...</i>]}]
set reqd				{<b style="color: red">*</b>}
set one_reqd			{<b style="color: red">**</b>}

set titles				[db_list_of_lists possible_titles {}]
set titles				[tree::sorter::sort_list_of_lists -list $titles]
set titles				[linsert $titles end $other]

set groups				[db_list_of_lists subsite_groups {}]
set groups				[tree::sorter::sort_list_of_lists -list $groups]
set groups				[linsert $groups end $other]

set user_execute_action	"Send Request"
if {[exists_and_not_null step]} {
	append user_execute_action " & Return to Step $step"
}

ad_form -name request_add -export {
	personnel_id
	return_url
	step
} -form {
	{user_selected_title_id:integer(select),optional
		{label "Title:$one_reqd"}
		{options {$titles}}
		{html {onChange {
			var other	= this.form.user_typed_title;

			if(this.selectedIndex == (this.options.length-1)) {
				this.disabled		= (other.value != '');
				other.style.display	= '';
			} else {
				this.disabled		= (other.value != '');
				other.style.display	= 'none';
			}
		}}}
	}
	{user_typed_title:text,optional
		{label "Title:$one_reqd"}
		{html {	style		{display: none}
				onChange	{this.form.user_selected_title_id.disabled = (this.value.length > 0);}}
		}
	}

	{user_selected_group_id:integer(select),optional
		{label "Group:$one_reqd"}
		{options {$groups}}
		{html {onChange {
			var other	= this.form.user_typed_group;

			if(this.selectedIndex == (this.options.length-1)) {
				this.disabled		= (other.value != '');
				other.style.display	= '';
			} else {
				this.disabled		= (other.value != '');
				other.style.display	= 'none';
			}
		}}}
	}
	{user_typed_group:text,optional
		{label "Group:$one_reqd"}
		{html {	style		{display: none}
				onChange	{this.form.user_selected_group_id.disabled = (this.value.length > 0);}}
		}
	}

	{comments:text(textarea),optional	{label "Comments:"} {html {rows 10 cols 60}}}
	{action:text(submit)				{label $user_execute_action}}

	{required:text(inform)				{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
	{one_required:text(inform)			{label "&nbsp;"} {value "Fields marked with <q>$one_reqd</q> are required."}}
} -validate {
	{user_selected_title_id
		{[exists_and_not_null user_selected_title_id]
		 || [exists_and_not_null user_typed_title]} {
			 <font color="maroon">You must select a title from the pull-down
			 menu to the left, or select <q>\[<i>Other</i>\]</q> and type in
			 the name of a title that is not in the list in the field provided.
			 </font>
		}
	}
	{user_selected_group_id
		{[exists_and_not_null user_selected_group_id]
		 || [exists_and_not_null user_typed_group]} {
			 <font color="maroon">You must select a group from the pull-down
			 menu to the left, or select <q>\[<i>Other</i>\]</q> and type in the
			 name of a group that is not in the list in the field provided.
			 </font>
		}
	}
} -on_submit {
	# //TODO//
	# Compose user input into a message
	# Determine recipients
	# Send to confirmation page
	# Send Email
	# Start a Workflow Instance
} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url $party_detail_url
	}
	template::forward $return_url
}
