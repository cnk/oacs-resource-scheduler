# -*- tab-width: 4 -*-
# /packages/institution/www/groups/detail.tcl
ad_page_contract {
	This is the detail page for the groups objects in the institution package.
	It presents the user with a tree of subgroups which they have permission
	to read in the current context.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/21
	@cvs-id			$Id: detail.tcl,v 1.4 2007/03/03 04:55:07 andy Exp $
} {
	{group_id:naturalnum,optional}
	{group_name:optional}
	{show:integer,optional}
	{hide:integer,optional}
	{current_page:naturalnum 0}
	{row_num:naturalnum 10}
	{max_personnel:integer 30}
} -validate {
	group_id_or_name {
		if {![info exists group_id] && ![info exists group_name]} {
			ad_complain "You must specify the ID or name of the group you wish to see the details of."
			return
		}
	}
}

set context		[list [list "../groups/" "Groups"] "Details"]
set title		"Details for "
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

set personnel_admin_p	[permission::permission_p -object_id $package_id -privilege "admin"]
set sitewide_admin_p	[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]

set subgroup_create_url		""
set group_permit_url		""
set group_delete_url		""

if {![info exists group_id]} {
	set group_id [db_string group_lookup {select nvl(inst_group.lookup(:group_name), -1) from dual}]
	if {$group_id == -1} {
		ad_return_complaint 1 "The group you specified does not exist."
		ad_script_abort
	}
}

set this_url "[ad_conn url]?[export_vars {group_id}]"

# see if we are looking at a group that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row group {}] <= 0} {
	ad_return_complaint 1 "Group does not exist (it may exist in other contexts)."
	ad_script_abort
}
set parent_group_url [export_vars -base detail -override {{group_id $parent_group_id}}]
set alias_group_url	 [export_vars -base detail -override {{group_id $alias_for_group_id}}]

# require 'read' on current group to see anything:
if {!$read_p} {
	permission::require_permission -object_id $group_id -privilege "read"
	ad_script_abort
}

append title "\"$short_name\""

# require 'write' on current group to allow editing:
if {$write_p} {
	set physician_p 1
	set group_edit_url					"add-edit?[export_vars {group_id}]"
	set group_associate_personnel_url	"../personnel/search/?[export_vars -override {{exclude_group_id $group_id}}]"
	set personnel_group_add_url			"../personnel/personnel-ae?[export_vars {group_id}]"
	set physician_group_add_url			"../personnel/personnel-ae?[export_vars {group_id physician_p}]"
	set jccc_group_p [inst::jccc::group_p -group_id $group_id]
	if {$jccc_group_p} {
		set jccc_write_url				"jccc-ae?[export_url_vars group_id]"
	}
}

# require 'create' on current group to create sub-groups:
if {$create_p} {
	set subgroup_create_url			"add-edit?[export_vars -override {{parent_group_id $group_id} {return_url $this_url}}]"
	set group_add_address_url		"../address/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
	set group_add_email_url			"../email/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
	set group_add_url_url			"../url/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
	set group_add_phone_url			"../phone-number/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
	set group_add_certification_url	"../certification/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
	set group_add_image_url			"../party-image/add-edit?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
}

# require 'delete' on current group to delete it and all subgroups
if {$delete_p} {
	set group_delete_url "delete?[export_vars {group_id}]"
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set group_permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $group_id}}]"
}

# replace any '<image.../>' tags:
set description [party_image::subst -party_id $group_id $description]

# roots is an sql-query (be careful) or comma-delimited list of values
set roots				[db_map direct_subgroups_of]
set root_group_id		$group_id
set actual_object_type	"Group"

set group_addresses			[db_map group_addresses]
set group_emails			[db_map group_emails]
set group_urls				[db_map group_urls]
set group_phones			[db_map group_phones]
set group_certifications	[db_map group_certifications]
set group_personnel			[db_map group_personnel]
set group_images			[db_map group_images]

set group_addresses_url			"../address/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
set group_emails_url			"../email/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
set group_urls_url				"../url/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
set group_phones_url			"../phone-number/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
set group_certifications_url	"../certification/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"
set group_personnel_url			"../personnel/"
set group_images_url			"../party-image/?[export_vars -override {{party_id $group_id} {return_url $this_url}}]"

# See if the user can perform any actions on the current group.
set can_change_this_group_p [expr $create_p || $delete_p || $write_p || $admin_p]
