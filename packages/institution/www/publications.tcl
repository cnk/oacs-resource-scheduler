# /packages/institution/www/publications.tcl			-*- tab-width: 4 -*-
#
#ad_page_contract {
#} {
#	{personnel_id:integer,notnull}
#	{suppress_custom_order_p:optional}
#}

set user_id			[ad_conn user_id]
set package_id		[ad_conn package_id]
set subsite_id		[ad_conn subsite_id]
set subsite_url		[site_node_closest_ancestor_package_url]

set this_url		"[ad_conn url]?[export_vars {personnel_id}]"
set main_subsite_id	[ctrl_procs::subsite::get_main_subsite_id]
if {[db_string custom_ordered_publications_p {} -default 0]} {
	set publications_sql custom_ordered_publications_subset
} else {
	set subsite_id $main_subsite_id
	if {![exists_and_not_null suppress_custom_order_p]
		&& [db_string custom_ordered_publications_p {} -default 0]} {
		set publications_sql custom_ordered_publications_subset
	} else {
		set publications_sql publications
	}
}

db_multirow -extend {
	download_url
	edit_url
	unmap_url
} publications "$publications_sql" {} {
	if {$bytes > 0} {
		set download_url "publication-download?[export_vars {publication_id}]"
	}
	set edit_url ""
	set unmap_url ""
}
