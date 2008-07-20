ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id    $Id: publication-map-4.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {publication_id:multiple,notnull}
    {personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node::get_url -node_id [ad_conn subsite_id]]
# require 'create' to create new publication-personnel map
permission::require_permission -object_id $package_id -privilege "create"

set publication_id [lindex $publication_id 0]

foreach publication $publication_id {
    publication::publication_personnel_map -publication $publication \
	-personnel_id $personnel_id
}


ad_returnredirect "../personnel/detail?[export_vars personnel_id]"
