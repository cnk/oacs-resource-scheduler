# -*- tab-width: 4 -*-
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2004/05/11
	@cvsid			$Id: cores.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
}

set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set title		"Research Core Facilities"
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]

db_multirow -extend {detail_url parent_detail_url} core_groups core_groups {} {
	set detail_url "core-detail?[export_vars {group_id}]"
	set parent_detail_url "core-detail?[export_vars -override {{group_id $parent_group_id}}]"
}
