# -*- tab-width: 4 -*-
# /packages/institution/www/admin/title/arrange-0.tcl
ad_page_contract {
	Interface for selecting a subset and re-ordering it for display on a given
	subsite.  This page allows the user to select the subsite they want to arrange
	their titles for.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-02-15 11:30 PST
	@cvs-id			$Id: arrange-0.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} -query {
	{personnel_id:integer,notnull}
	{return_url	[get_referrer]}
	{step:naturalnum,optional}
}

set indefinite_article	"a"
set object_type_key		"title"
set object_type			"Title"
set object_type_pl		"Titles"
set user_id				[ad_conn user_id]
set peer_ip				[ad_conn peeraddr]
set package_id			[ad_conn package_id]
set this_subsite_id		[ad_conn subsite_id]
set subsite_url			[site_node_closest_ancestor_package_url]

set action				"Choose"
set	user_execute_action	"Choose"

set personnel_name		[db_string psnl_name {select acs_object.name(:personnel_id) from dual} -default ""]
if {$personnel_name == ""} {
	ad_return_complaint 1 "The person you are trying to arrange the $object_type_pl of does not exist."
	ad_script_abort
}

if {$user_id == $personnel_id} {
	set owner_name		"your"
} else {
	set owner_name		"$personnel_name's"
}

set title				"Arrange $owner_name $object_type_pl"
set context				[list [list "../$object_type_key/" $object_type_pl] $action]

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege admin

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]
set main_subsite_id		[ctrl_procs::subsite::get_main_subsite_id]

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

db_multirow -extend {
	select_subsite_url
	visit_subsite_url
	reset_arrangement_url
} personnel_subsite_list personnel_subsite_list {} {
	set select_subsite_url		"arrange-1?[export_vars {personnel_id chosen_subsite_id return_url step}]"
	set visit_subsite_url		""
	set reset_arrangement_url	[export_vars -base arrangement-reset {personnel_id chosen_subsite_id return_url step}]
}
