# -*- tab-width: 4 -*-
# /packages/institution/www/admin/resume/add-edit.tcl
ad_page_contract {
	Interface for creating new and editting existing resumes.  When creating a
	resume, <code>resume_id</code> must not be passed.

	@param			resume_id		(optional) the id of the resume you wish to edit
	@param			personnel_id	(optional) the id of the personnel you wish to create a resume for

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: add-edit.tcl,v 1.2 2007/02/21 20:25:40 andy Exp $
} {
	{resume_id:naturalnum,optional}
	{personnel_id:naturalnum,optional}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"a"
set object_type_key		"resume"
set object_type			"Resume"
set object_type_pl		"Resumes"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set subsite_url			[site_node_closest_ancestor_package_url]

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null resume_id]} {
	if {![exists_and_not_null personnel_id] &&
		[db_0or1row get_personnel_id {
			select	personnel_id
			  from	inst_personnel_resumes
			 where	resume_id = :resume_id
		}] != 1} {
		ad_return_complaint 1 "The $object_type you requested does not exist."
		return
	}
	set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $resume_id -privilege "delete"]} {
		set resume_delete_url	"delete?[export_vars {resume_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $resume_id -privilege "admin"]} {
		set subsite_url			[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set resume_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $resume_id}}]"
	}

	set resume_download_url		"[ad_conn package_url]resume-download?[export_vars {resume_id}]"
	set resume_download_html	"<a href=\"$resume_download_url\">Download This Resume</a><br>"
	set action					"Edit"
	set	user_execute_action		"Save Changes"
	set can_delete_or_permit_p	[expr [exists_and_not_null resume_delete_url] || [exists_and_not_null resume_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.  In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action				[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action			"to $old_action $indefinite_article $object_type"
	}
	set title					"$action Your Request $old_action"
} elseif {[exists_and_not_null personnel_id]} {
	# make sure the id corresponds to personnel (and not simply a person)
	set personnel_p [db_string personnel_p {
		select 1
		  from inst_personnel
		 where personnel_id = :personnel_id
	} -default 0]

	if {!$personnel_p} {
		ad_return_complaint 1 {
			You attempted to supply a non-personnel as an input to this form.
			Only personnel may have resumes.
		}
		ad_script_abort
	}

	# check for permission to create a resume for this personnel
	permission::require_permission -object_id $personnel_id -privilege "create"

	set action					"Add"
	set	user_execute_action		"Save"
	set resume_download_html	""
	set can_delete_or_permit_p	0
} else {
	ad_return_complaint 1 {
		You must supply a valid resume when attempting to edit a resume.
		Alternatively, you may indicate a personnel for which you wish to create
		a resume.
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
set resume_types	[db_list_of_lists resume_types {}]

ad_form -name add_edit -export {action return_url step} -html {
	enctype "multipart/form-data"
} -form {
	{resume_id:key}
	{personnel_id:integer(hidden)}
	{description:text,optional			{label "Description:"}		}
	{resume_type_id:integer(select)		{label "Type:$reqd"}	{options {$resume_types}}}
	{resume_upload:text(file)	        {label "Resume:$reqd"}
		{html {onChange "var other = document.add_edit.resume.style; if(this.value == null || this.value == '') {other.display = '';} else {other.display = 'none';}"}}
		{before_html $resume_download_html}
	}
	{submit:text(submit)				{label $user_execute_action}}
	{required:text(inform)				{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
} -select_query_name "resume" -on_request {
	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $resume_id -privilege "write"
		db_1row resume {}
		if {$user_id == $personnel_id} {
			set title		"$action Your $object_type \"$description\""
		} else {
			set title		"$action the $object_type \"$description\" owned by \"$owner_name\""
		}
	} else {
		# The user requested an 'Add' page
		# setup some default values

		# this goes in the page title
		set owner_name [db_string party_name {select acs_object.name(:personnel_id) from dual}]
		if {$user_id == $personnel_id} {
			set title		"$action a $object_type For Yourself"
		} else {
			set title		"$action a $object_type owned by \"$owner_name\""
		}
	}

	set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]
} -on_submit {
	if {[exists_and_not_null resume_upload]} {
		set original_name	$resume_upload
		set extension		[string tolower [file extension $resume_upload]]
		regsub "\." $extension "" extension
		set format			[ns_guesstype $resume_upload]
		set resume_upload	[ns_queryget resume_upload.tmpfile]
		set file_bytes		[file size $resume_upload]
	}
} -new_data {
	db_transaction {
		# create a new resume
		set resume_id [db_exec_plsql resume_new {}]

		# update content
		if {[exists_and_not_null resume_upload]} {
			db_dml resume_upload_blob {} -blob_files [list $resume_upload]
		}
	}
} -edit_data {
	permission::require_permission -object_id $resume_id -privilege "write"
	db_transaction {
		db_dml resume_edit {}

		# update content
		if {[exists_and_not_null resume_upload]} {
			db_dml resume_upload_blob {} -blob_files [list $resume_upload]
		}

		db_dml modified {}
	}
} -after_submit {
	template::forward $return_url
}
