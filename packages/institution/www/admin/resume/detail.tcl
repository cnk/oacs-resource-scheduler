# -*- tab-width: 4 -*-
# /packages/institution/www/resume/detail.tcl

ad_page_contract {
	This is the detail page for the resume objects in the institution package.

	@param			resume_id		the id of the resume you wish to see.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/02/17
	@cvs-id			$Id: detail.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{resume_id:naturalnum}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set object_type_key	"resume"
set object_type		"Resume"
set object_type_pl	"Resumes"
set action			""
set context			[list [list "../$object_type_key/" $object_type_pl] "Details"]
set user_id			[ad_conn user_id]
set package_id		[ad_conn package_id]
set subsite_url		[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# see if we are looking at a resume that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row resume {}] <= 0} {
	ad_return_complaint 1 "Resume does not exist (it may exist in other contexts)."
	return
}

# require 'read' on current resume to see anything:
if {!$read_p} {
	permission::require_permission -object_id $resume_id -privilege "read"
	return
}

if {$content_length > 0} {
	set resume_download_url	"[ad_conn package_url]resume-download?[export_vars {resume_id}]"
}

# require 'write' on current resume to allow editting:
if {$write_p} {
	set resume_edit_url	"add-edit?[export_vars {resume_id}]"
} else {
	set resume_edit_url	""
}

# require 'delete' on current resume to delete it
if {$delete_p} {
	set resume_delete_url	"delete?[export_vars {resume_id}]"
} else {
	set resume_delete_url	""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set resume_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $resume_id}}]"
} else {
	set resume_permit_url	""
}

# See if the user can perform any actions on the current resume.
set can_change_this_resume_p [expr $create_p || $delete_p || $write_p || $admin_p]

# set the title
if {$user_id == $personnel_id} {
	set title	"Details About Your $object_type \"$description\""
} else {
	set title	"Details About the $object_type \"$description\" owned by \"$owner_name\""
}
set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]
