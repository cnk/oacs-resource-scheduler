# -*- tab-width: 4 -*-
ad_page_contract {
	@author			nick@ucla.edu
	@creation-date	2004/01/28
	@cvs-id			$Id: personnel-group-delete-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:integer,notnull	}
	{group_id:integer,notnull		}
	{title_id:integer				""}
	{return_url						[get_referrer]}
}

# require 'delete' to delete personnel
# //TODO// check permission on gpm_title_id's, not personnel_id
permission::require_permission -object_id $personnel_id -privilege "delete"

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

db_transaction {
	personnel::unassociate				\
		-personnel_id	$personnel_id	\
		-group_id		$group_id		\
		-title_id		$title_id
}

if {[empty_string_p $return_url]} {
	set return_url [export_vars -base detail {personnel_id}]
}
template::forward $return_url