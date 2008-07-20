# /packages/title/www/add-edit.tcl							-*- tab-width: 4 -*-
ad_page_contract {
	Interface for creating new and editting existing titles.  When creating an
	title, <code>gpm_title_id</code> must not be passed.

	@param			gpm_title_id	(optional) the id of the title you wish to edit

	@param			personnel_id		(optional) the id of the personnel you wish to create a title for
	@param			group_id			(optional) the id of the party you wish to create a title for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{gpm_title_id:naturalnum,optional}
	{acs_rel_id:naturalnum,optional}
	{personnel_id:naturalnum,optional}
	{group_id:naturalnum,optional}
	{title_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}
set indefinite_article	"an"
set object_type_key		"title"
set object_type			"Title"
set object_type_pl		"Titles"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_id			[ad_conn subsite_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null gpm_title_id]} {	;# if this is the submit part of an ADD or the request or submit part of an EDIT...
	if {![exists_and_not_null personnel_id] &&
		[db_0or1row get_personnel_id {
			select	r.object_id_two		as personnel_id,
					gpm.acs_rel_id,
					gpm.title_id
			  from	inst_group_personnel_map	gpm,
					acs_rels					r
			 where	gpm.gpm_title_id	= :gpm_title_id
			   and	gpm.acs_rel_id		= r.rel_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $gpm_title_id -privilege "delete"]} {
		set title_delete_url	"delete?[export_vars {gpm_title_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $gpm_title_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set title_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $gpm_title_id}}]"
	}

	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null title_delete_url] || [exists_and_not_null title_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null group_id]} {
	# check for permission to create a title for this party
	permission::require_permission -object_id $group_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} elseif {[exists_and_not_null personnel_id]} {
	# check for permission to create a title for this party
	permission::require_permission -object_id $personnel_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid title-id when attempting to edit a title.
		Alternatively, you may indicate a party for which you wish to create
		a title.
	}
	ad_script_abort
}

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

set context				[list [list "../$object_type_key/" $object_type_pl] $action]
set none				[list {[<i>None</i>]}]
set now					[template::util::date::today]	;# a default value for dates
set reqd				{<b style="color: red">*</b>}

# BUILD FORM ###################################################################
set title_types			[db_list_of_lists title_types {}]
set title_types			[tree::sorter::sort_list_of_lists -list $title_types]
set title_type_cat_id	[category::find -path [list "Personnel Title"]]
set status_types		[db_list_of_lists status_types {}]
set status_types		[tree::sorter::sort_list_of_lists -list $status_types]

# Add [None] options to any sets of options that can be left empty
set status_types		[linsert $status_types 0 $none]

if {[db_string can_create_a_title_type_p {
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	categories	c
				  where	acs_permission.permission_p(c.category_id, :user_id, 'admin') = 't'
				connect	by prior parent_category_id = category_id
				  start	with category_id = category.lookup('//Personnel Title//'))
	} -default 0]} {

	# //TODO// make a better URL?
	set title_type_create_url	"/categories/add-edit?[export_vars -override {{parent_category_id $title_type_cat_id}}]"
	set title_type_create_html "
		<small>
			<a	title=\"Click here to create a new Title Type.\"
				href=\"$title_type_create_url\">(Create a new Title Type)
			</a>
		</small>
	"
} else {set title_type_create_html ""}

if {[exists_and_not_null group_id]} {
	set group_id_widget {
		{group_name:text(inform)			{label "Group:"}}
		{group_id:integer(hidden)			{value $group_id}}
	}
} else {
	set groups				[db_list_of_lists groups {}]
	set groups				[tree::sorter::sort_list_of_lists -list $groups]

	if {[exists_and_not_null gpm_title_id]
		&& [db_0or1row get_existing_gpm_group_id {
				select	r.object_id_one						as group_id,
						acs_object.name(r.object_id_one)	as group_name
				  from	inst_group_personnel_map	gpm,
						acs_rels					r
				 where	gpm.acs_rel_id		= r.rel_id
				   and	gpm.gpm_title_id	= :gpm_title_id
		  }] == 1} {
		# This is the case when editting a title in group that is at the root
		# of the subsite or is not part of the subsite at all (it _can_ happen)
		set group_id_widget	{
			{group_name:text(inform)			{label "Group:"}}
			{group_id:integer(hidden)			{value $group_id}}
		}
	} elseif {[llength $groups] > 0} {
		# Make sure current-group is in list of possible groups
		set found_current_group_p 0
		foreach g $groups {
			set g_group_id [lindex $g 1]
			if {[exists_and_not_null group_id] && $g_group_id == $group_id} {
				set found_current_group_p 1
				break
			}
		}

		# Add the group to the list since it was not found
		if {[exists_and_not_null group_id]
			&& $found_current_group_p == 0
			&& [db_0or1row group {}]} {
			linsert $groups 0 [list $group_id $group_name]
		}

		# Allow user to select a group to create the title with
		set group_id_widget	{
			{group_id:integer(select)			{label "Group:$reqd"}	{options {$groups}}				}
		}
	} elseif {[exists_and_not_null group_id]} {
		set group_id_widget	{
			{group_id:integer(hidden)			{value $group_id}}
		}
	} else {
		set group_id_widget	{}
	}
}

ad_form	-name add_edit									\
		-export {personnel_id action return_url step}	\
		-form [append form_widgets {
	{gpm_title_id:key}
	{title_id:integer(select)				{label "Type:$reqd"}	{options {$title_types}}
		{after_html "$title_type_create_html"}
	}
} "$group_id_widget" {
	{pretty_title:text,optional				{label "Display As:"}
		{tooltip {If this is filled out, this is the text that will be displayed on web-pages instead of 'Title'.  Use it only if the 'Title' field is not enough to accurately describe the title.  This text does NOT replace the 'Group' field. For example, the title 'Stotter Chair of Pediatrics' would need to use this field. The text 'Stotter Chair' would go into the Display field.}}
	}
	{status_id:integer(select),optional		{label "Status:"}		{options {$status_types}}	}
	{leader_p:text(checkbox),optional		{label "Leader?:"}		{options {{"" "t"}}}		}
	{start_date:date,optional				{label "Start Date"}	{value $now}				}
	{end_date:date,optional					{label "End Date"}									}
	{title_priority_number:integer,optional	{label "Display Order:"}	{html {size 4}}			}
	{submit:text(submit)			{label $user_execute_action}}
	{required:text(inform)			{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
}] -validate {
	# Make sure end-date is after start-date
	{end_date	{![exists_and_not_null start_date]
				||	![exists_and_not_null end_date]
				||	[expr [clock scan [join [lrange $start_date 0 2] "-"]] \
					<=	  [clock scan [join [lrange $end_date 0 2] "-"]]]} {
			[clock format [clock scan [join [lrange $start_date 0 2] "-"]] -format "%B %e, %Y"]
			is not prior to
			[clock format [clock scan [join [lrange $end_date 0 2] "-"]] -format "%B %e, %Y"].
			<br>The <q>Start Date</q> must be prior to <q>End Date</q>.
		}
	}
} -on_request {
	set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]
} -new_request {
	set owner_name [db_string personnel_name {
		select acs_object.name(:personnel_id) from dual
	}]

	if {$user_id == $personnel_id} {
		set title		"$action an $object_type For Yourself"
	} else {
		set title		"$action an $object_type owned by \"$owner_name\""
	}
} -edit_request {
	permission::require_permission -object_id $gpm_title_id -privilege "write"
	db_1row title {}

	if {$user_id == $personnel_id} {
		set title		"$action Your $object_type \"$description\""
	} else {
		set title		"$action the $object_type \"$description\" owned by \"$owner_name\""
	}

	if {[exists_and_not_null start_date]} {
		set start_date	[split $start_date "-"]
	}
	if {[exists_and_not_null end_date]} {
		set end_date	[split $end_date "-"]
	}
} -on_submit {
	set start_date		[join [lrange $start_date 0 2] "-"]
	set end_date		[join [lrange $end_date 0 2] "-"]
} -new_data {
	set error_p 0
	db_transaction {

		if {[db_string title_exists_p {} -default 0]} {
			ad_return_error "Error" "Could not create this title because it already exists in the 
			database."
			ad_script_abort
			db_abort_transaction
		} else {
			set gpm_title_id [db_exec_plsql title_new {}]
		}
	}
} -edit_data {
	permission::require_permission -object_id $gpm_title_id -privilege "write"

	if {[db_string title_exists_p {} -default 0]} {
		ad_return_complaint 1 "
			Could not edit title because it already exists.<br>
			Perhaps you want to delete the title instead?
		"
		ad_script_abort
	}

	db_1row old_title_details {}
	if {$group_id != $old_group_id} {
		permission::require_permission -object_id $group_id -privilege "create"
	}

	db_transaction {
		db_exec_plsql title_edit {}
	}
} -after_submit {
	if {[empty_string_p $return_url]} {
		set return_url $party_detail_url
	}
	template::forward $return_url
}
