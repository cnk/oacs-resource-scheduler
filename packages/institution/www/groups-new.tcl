# -*- tab-width: 4 -*-
ad_page_contract {
	Displays a hierarchical list of groups, using cookies to remember the set of expanded groups

	@author			helsleya@cs.ucr.edu	(AH)
	@author			avni@avni.net		(AK)
	@creation-date	2003-06-16
} {
}

set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set title		"Departments"
set context		[list [list "" "/"] $title]

set subsite_id	[ad_conn subsite_id]
set package_id	[ad_conn package_id]
set package_url	[ad_conn package_url]

set user_id		[ad_conn user_id]
