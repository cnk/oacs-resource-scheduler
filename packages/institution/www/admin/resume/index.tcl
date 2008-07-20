# -*- tab-width: 4 -*-
# /packages/resume/www/index.tcl
ad_page_contract {
	This is the main page for the resumes part of the institution package.

	@param			personnel_id	(optional) the personnel_id of the resumes you wish to view, defaults to [ad_conn user_id]

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/04
	@cvs-id			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:naturalnum,optional}
}

set context		[list "Resumes"]
set obj_type_pl	"Resumes"
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

if {![exists_and_not_null party_id]} {
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

# require 'create' on current personnel to create resumes:
if {$create_p} {
	set resume_create_url	"add-edit?[export_vars {personnel_id}]"
} else {
	set resume_create_url	""
}

# items is an sql-query (be careful) or comma-delimited list of values
set items					[db_map resumes_of_personnel]

# set the title based upon all prior information
if {$user_id == $personnel_id} {
	set title "Your $obj_type_pl"
} else {
	set title "$obj_type_pl owned by \"$owner_name\""
}
