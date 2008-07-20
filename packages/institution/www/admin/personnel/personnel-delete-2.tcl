# -*- tab-width: 4 -*-
ad_page_contract {
	@author			nick@ucla.edu
	@creation-date	2004/01/14
	@cvs-id			$Id: personnel-delete-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:integer,notnull}
	{return_url [get_referrer]}
}

# require 'delete' to delete personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

set person_exists_p [db_string person_exists_p {
	select	1
	  from	persons
	 where	person_id = :personnel_id
} -default 0]

if {!$person_exists_p} {
	# continue on because person already not in the system
} else {
	db_transaction {
		personnel::delete -personnel_id $personnel_id
	}
}

if {[empty_string_p $return_url] || [regexp -- "$personnel_id" $return_url]} {
	set return_url "."
}
template::forward "$return_url"
