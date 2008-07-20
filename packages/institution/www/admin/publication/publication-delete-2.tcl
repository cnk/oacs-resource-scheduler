# /packages/institution/www/admin/publication/publication-delete.tcl	-*- tab-width: 4 -*-
ad_page_contract {
	A confirm page for the deletion of publications.

	@author			nick@ucla.edu
	@creation-date	2004/02/01
	@cvs-id			$Id: publication-delete-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{publication_id:integer,notnull}
	{return_url [get_referrer]}
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node::get_url -node_id [ad_conn subsite_id]]

# require 'delete' to delete publication
permission::require_permission -object_id $publication_id -privilege "delete"

if {![publication::publication_exist -publication_id $publication_id]} {
	# continue on cuz person already not in the system
} else {
	publication::publication_delete -publication_id $publication_id
}

if {![exists_and_not_null return_url]} {
	set return_url "[ad_conn package_url]admin/publication/"
}
template::forward $return_url
