# -*- tab-width: 4 -*-
# /packages/institution/www/certification/detail.tcl

ad_page_contract {
	This is the detail page for the certification objects in the institution package.

	@param			certification_id		the id of the certification you wish to see.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/02/17
	@cvs-id			$Id: detail.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{certification_id:naturalnum}
	{return_url [get_referrer]}
	{step:naturalnum,optional}
}

set object_type_key	"certification"
set object_type		"Certification"
set object_type_pl	"Certifications"
set action			""
set context			[list [list "../$object_type_key/" $object_type_pl] "Details"]
set user_id			[ad_conn user_id]
set package_id		[ad_conn package_id]
set subsite_url		[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# see if we are looking at a certification that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row certification {}] <= 0} {
	ad_return_complaint 1 "Certification does not exist (it may exist in other contexts)."
	return
}

# require 'read' on current certification to see anything:
if {!$read_p} {
	permission::require_permission -object_id $certification_id -privilege "read"
	return
}

# require 'write' on current certification to allow editting:
if {$write_p} {
	set certification_edit_url	"add-edit?[export_vars {certification_id}]"
} else {
	set certification_edit_url	""
}

# require 'delete' on current certification to delete it
if {$delete_p} {
	set certification_delete_url	"delete?[export_vars {certification_id}]"
} else {
	set certification_delete_url	""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set certification_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $certification_id}}]"
} else {
	set certification_permit_url	""
}

# See if the user can perform any actions on the current certification.
set can_change_this_certification_p [expr $create_p || $delete_p || $write_p || $admin_p]

# set the title
if {$user_id == $party_id} {
	set title	"Details About Your $object_type \"$description\""
} else {
	set title	"Details About the $object_type \"$description\" owned by \"$owner_name\""
}
set party_detail_url [subsite::party_admin_detail_url -party_id $party_id]
