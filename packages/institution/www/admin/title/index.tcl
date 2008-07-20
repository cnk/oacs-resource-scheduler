# -*- tab-width: 4 -*-
# /packages/title/www/index.tcl
ad_page_contract {
	This is the main page for the titles part of the institution package.

	@param			personnel_id	(optional) the personnel_id of the titles you wish to view, defaults to [ad_conn user_id]

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/11/11
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{personnel_id:naturalnum	{[ad_conn user_id]}}
}

set obj_type_pl	"Titles"
set context		[list $obj_type_pl]
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

if {![exists_and_not_null personnel_id]} {
	template::forward "?[export_vars -override {{personnel_id $user_id}}]"
}

# this variable is used to build proper URLs for managing permissions
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# see if we are looking at a personnel that exists
if {[db_0or1row personnel {}] <= 0} {
	ad_return_complaint 1	"Personnel does not exist."
	ad_script_abort
}

# require 'read' on current personnel to see anything:
if {!$read_p} {
	permission::require_permission -object_id $personnel_id -privilege "read"
}

# require 'create' on current personnel to create titles:
if {$create_p} {
	set title_create_url	"add-edit?[export_vars {personnel_id}]"
} else {
	set title_create_url	""
}

# items is an sql-query (be careful) or comma-delimited list of values
set items					[db_map titles_of_party]

# set the title based upon all prior information
if {$user_id == $personnel_id} {
	set page_title "Your $obj_type_pl"
} else {
	set page_title "$obj_type_pl of \"$owner_name\""
}

set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]
