# /packages/institution/www/admin/publication/publication-delete-2.tcl	-*- tab-width: 4 -*-
ad_page_contract {
	@author			nick@ucla.edu
	@author			helsleya@cs.ucr.edu
	@creation-date	2004/02/01
	@cvs-id			$Id: publication-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{publication_id:integer,notnull}
	{return_url [get_referrer]}
}

set title		"Publication Delete"

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] "Publication Delete"]]

if {![publication::publication_exist -publication_id $publication_id]} {
	ad_return_complaint 1 "The publication you are requesting does not exist"
	return
}

# require 'delete' to delete new publication...
permission::require_permission -object_id $publication_id -privilege "delete"

# put up a confirm dialog
set pub_title [db_string get_title {
	select	title
	  from	inst_publications
	 where	publication_id = :publication_id
}]

set warning_text	"
	Warning, you are about to delete the publication, \"$pub_title\", from this
	system.  This is irreversible. Are you sure you wish to continue?
"

ad_form -name {publication_delete} -action {publication-delete-2} -form {
	{warning:text(inform)	{label "Warning"} {value $warning_text}}
} -export {publication_id return_url}


