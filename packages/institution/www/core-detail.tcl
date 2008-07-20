# -*- tab-width: 4 -*-
ad_page_contract {
	@author helsleya@cs.ucr.edu
} {
	{group_id:integer}
	{show:optional ""}
	{hide:optional ""}
}

set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set context		[list [list "cores" "Cores"] "Details"]
set subsite_id	[ad_conn subsite_id]

if {[db_0or1row group_detail {} -column_array details] == 0} {
	ad_return_complaint 1 "The Core Facility you requested does not exist."
	ad_script_abort
}

# replace any '<image.../>' tags:
set details(description) [party_image::subst -party_id $group_id $details(description)]

set title "Details for Core"

# get a list of groups within this group, their count, and type
set children			"  select	group_id  from	inst_groups	 where	parent_group_id = :group_id"
set children_p				[db_string group_children_count {}]
set subgroup_types			[db_list subgroup_types {}]

# get information that categorizes this group
db_multirow group_cat_info	group_cat_info {}

# group contact info
db_multirow addresses		group_addresses {}
db_multirow phones			group_phone {}
db_multirow urls			group_urls {}
db_multirow emails			group_emails {}
db_multirow certifications	group_certifications {}

array set unique_titles [list]

# figure out which subset of personnel belong to the subsite
if {[db_string subsite_roots_exist_p {}]} {
	set subsite_personnel	[db_map subsite_personnel]
} else {
	set active				[personnel::get_status_id -name "Active"]
	set subsite_personnel	[db_map all_personnel]
}

# retrieve the personnel, filtering through the :subsite_personnel query
db_multirow personnel		group_personnel {} {
	set unique_titles($personnel_title) 1
}
set titles [lsort [array names unique_titles]]

db_multirow leaders			group_leaders {}

