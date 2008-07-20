# -*- tab-width: 4 -*-
ad_page_contract {
	This is the main page for the institution package.  It presents the user
	with a tree of groups which they have permission to read in the current
	subsite as well as some controls for manipulating those groups as
	well as personnel.

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/02/24
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{show:integer,optional}
	{hide:integer,optional}
}

set title		"Faculty Editor"
set user_id		[ad_maybe_redirect_for_registration]
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]
set subsite_url	[site_node::get_url_from_object_id -object_id $subsite_id]

set group_create_url		""
set group_edit_url			""
set group_permit_url		""
set group_delete_url		""

# require read-permission on the package to see this page
permission::require_permission -object_id $package_id -privilege "read"

set personnel_search_url	"personnel-search"

# cannot edit or delete the root group (it actually doesn't exist)
set write_p					0
set delete_p				0

set admin_p					[permission::permission_p -object_id $package_id -privilege "admin"]
set any_admin_p             [inst_permissions::admin_p]

if {$any_admin_p || $admin_p} {
	set admin_url "admin/"
}

set subsite_trunks "
	select	group_id
	  from	inst_groups	g,
			categories	c
	 where	[subsite::parties_sql -only -root -groups -party_id {g.group_id}]
	   and	g.group_type_id	= c.category_id
	   and	c.enabled_p		= 't'
"
set n_children	[llength [db_list subsite_trunks $subsite_trunks]]

# See if the user can perform any actions on the current group.
set publication_upload_url "publication/upload-info"
