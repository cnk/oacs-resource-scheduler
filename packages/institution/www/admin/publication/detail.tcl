# -*- tab-width: 4 -*-
# /packages/institution/www/publication/detail.tcl

ad_page_contract {
	This is the detail page for publication objects in the institution package.

	@param			publication_id		the id of the publication you wish to see

	@author			helsleya@cs.ucr.edu
	@author			nick@ucla.edu
	@creation-date	2004/02/01
	@cvs-id			$Id: detail.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{publication_id:naturalnum}
}

set object_type			"Publication"
set object_type_plural	"Publications"
set context				[list [list "../publication/" $object_type_plural] "Details"]
set package_id			[ad_conn package_id]
set user_id				[ad_conn user_id]
set subsite_url			[site_node_closest_ancestor_package_url]
set context_bar			[ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] "Publication Detail"]]

# see if we are looking at an publication that exists in the current
# context, and if so get its attributes and permissions
if {[db_0or1row publication {}] == 0} {
	ad_return_complaint 1 "The publication you requested does not exist."
	ad_script_abort
}

# require 'read' on current publication to see anything:
if {!$read_p} {
	permission::require_permission -object_id $publication_id -privilege "read"
	return
}

if {![empty_string_p $publish_date]} {
	set pretty_publish_date			[util_AnsiDatetoPrettyDate $publish_date]
} else {
	set pretty_publish_date			""
}

# require 'create' to create new publication mappings
if {$create_p} {
	set publication_create_url		"publication-ae"
	set publication_map_url			"publication-map?[export_vars publication_id]"
} else {
	set publication_create_url		""
	set publication_map_create_url	""
}

# require 'delete' to delete new publication
if {$delete_p} {
	set publication_delete_url		"publication-delete?[export_vars publication_id]"
} else {
	set publication_delete_url		""
}

# Add a 'permit' URL if the user has 'admin' privileges
if {$admin_p} {
	set publication_permit_url		"${subsite_url}permissions/one?[export_vars -override {{object_id $publication_id}}]"
} else {
	set publication_permit_url		""
}

# require 'write' to edit exisiting publication
if {$write_p} {
		set personnel_id 0
	set publication_edit_url		"publication-ae?[export_vars {publication_id personnel_id}]"
} else {
	set publication_edit_url		""
}

# see if the publication contents are in the DB
if {$content_bytes > 0 && [exists_and_not_null publication_type]} {
	set publication_contents_url	"publication?[export_vars {publication_id}]"
}

# See if the user can perform any actions on the current publication.
set can_change_this_publication_p [expr $create_p || $delete_p || $write_p || $admin_p]

# set the page title
set page_title $object_type
