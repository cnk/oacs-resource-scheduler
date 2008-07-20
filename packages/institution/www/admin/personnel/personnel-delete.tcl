# /packages/institution/www/admin/personnel/personnel-delete.tcl	-*- tab-width: 4 -*-
ad_page_contract {
	@author			nick@ucla.edu
	@creation-date	2004/01/14
	@cvs-id			$Id: personnel-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:integer,notnull}
	{return_url:trim,optional "index"}
}

# require 'delete' to delete personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

set titles_url		[export_vars -base ../title/ {personnel_id}]

set person_exists_p	[db_0or1row person_exist {
	select	first_names,
			last_name
	  from	persons
	 where	person_id = :personnel_id
}]

if {$person_exists_p} {
	ad_form -name personnel_delete -action {personnel-delete-2}	\
		-export	{personnel_id return_url}						\
		-form	{ {delete:text(submit) {label "Delete"}} } -method {post}
} else {
	ad_return_complaint 1 "This personnel does not exist"
}
