# -*- tab-width: 4 -*-
# /packages/institution/www/admin/title/arrange.tcl
ad_page_contract {
	A user interface for arranging the display of a personnel's titles on a given
	subsite.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-02-11 15:52 PST
	@cvs-id			$Id: arrange-1.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} -query {
	{chosen_subsite_id:naturalnum,trim}
	{personnel_id:naturalnum,trim}
	{show_p:array,integer,trim,optional}
	{order:array,integer,trim,optional}
	{return_url	[get_referrer]}
	{step:naturalnum,optional "1"}
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

set action				"Arrange"
set	user_execute_action	"Save Changes"

set personnel_name		[db_string psnl_name {select acs_object.name(:personnel_id) from dual} -default ""]
if {[db_0or1row object_names {}] == 0} {
	ad_return_complaint 1 "The person or subsite you requested does not exist."
	ad_script_abort
}

if {$user_id == $personnel_id} {
	set owner_name		"your"
} else {
	set owner_name		"$personnel_name's"
}

set title				"$action $owner_name $object_type_pl"
set context				[list [list "../$object_type_key/" $object_type_pl] $action]

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege admin

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]
set main_subsite_id		[ctrl_procs::subsite::get_main_subsite_id]

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
	append user_execute_action	" & Return to Step $step"
}

# Retrieve Data ################################################################
db_multirow arranged_titles arranged_titles {} {
	set title		[ctrl::quote_js $title		"\""]
	set group_name	[ctrl::quote_js $group_name	"\""]
}

if {${arranged_titles:rowcount} <= 0} {
	db_multirow arranged_titles sitewide_default_arranged_titles {} {
		set title		[ctrl::quote_js $title		"\""]
		set group_name	[ctrl::quote_js $group_name	"\""]
	}
}
