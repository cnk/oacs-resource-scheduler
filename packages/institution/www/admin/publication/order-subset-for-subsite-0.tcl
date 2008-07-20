# -*- tab-width: 4 -*-
# /packages/institution/www/admin/publication/order-subset-for-subsite-0.tcl
ad_page_contract {
	Interface for selecting a subset and re-ordering it for display on a given
	subsite.  This page allows the user to select the subsite they want to arrange
	their publications for.

	@author			helsleya@cs.ucr.edu
	@creation-date	<2005-02-15 11:30 PST
	@cvs-id			$Id: order-subset-for-subsite-0.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:integer,notnull}
	{return_url	[get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"a"
set object_type_key		"publication"
set object_type			"Publication"
set object_type_pl		"Publications"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set this_subsite_id		[ad_conn subsite_id]
set subsite_url			[site_node_closest_ancestor_package_url]

set title				"Arrange $object_type_pl on a Website"
set context				[list [list ../ "Admin"] $title]

set personnel_name		[db_string psnl_name {select acs_object.name(:personnel_id) from dual} -default ""]
if {$personnel_name == ""} {
	ad_return_complaint 1 "The person you are trying to arrange the $object_type_pl of does not exist."
	ad_script_abort
}

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege admin

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]
set main_subsite_id		[ctrl_procs::subsite::get_main_subsite_id]

db_multirow -extend {
	select_subsite_url
	visit_subsite_url
	reset_arrangement_url
} personnel_subsite_list personnel_subsite_list {} {
	set select_subsite_url		"order-subset-for-subsite?[export_vars {personnel_id subsite_id return_url step}]"
	set visit_subsite_url		""
	set reset_arrangement_url	[export_vars -base arrangement-reset -override {personnel_id {chosen_subsite_id $subsite_id} return_url step}]
}

