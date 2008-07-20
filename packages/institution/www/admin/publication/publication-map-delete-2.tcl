# /packages/institution/www/admin/publicaton/publication-map-delete-2.tcl

ad_page_contract {
    @author   nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id $Id: publication-map-delete-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
    {publication_id:integer,notnull}
}

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

# require 'delete' to delete new personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set delete_error 0
db_transaction {
    db_dml delete_publication_personnel_subsets {
	delete from inst_psnl_publ_ordered_subsets
	where  publication_id = :publication_id 
	and    personnel_id = :personnel_id
    }

    db_dml delete_publication_maps {
	delete from inst_personnel_publication_map
	where publication_id = :publication_id 
	and personnel_id = :personnel_id
    }

    inst::access::update_publication_to_null_for_personnel -personnel_id $personnel_id -publication_id $publication_id
    arr::profile::publication_remove -publication_id $publication_id -personnel_id $personnel_id

    set publication_map_exists_p [db_string publication_personnel_map_exists_p {
	select count(*)
	from   inst_personnel_publication_map
	where  publication_id = :publication_id
    }]

    if {!$publication_map_exists_p} {
	inst::access::update_publication_to_null -publication_id $publication_id
	arr::profile::publication_remove -publication_id $publication_id
	db_exec_plsql publication_delete {
	    begin
	          inst_publication.delete(publication_id => :publication_id);
	    end;
	}
    }
    
} on_error {
    set delete_error 1
    db_abort_transaction
}

if {$delete_error} {
    ad_return_error "Error" "Mapping Not Deleted Properly - $errmsg"
    return
}

set return_url "${subsite_url}institution/admin/personnel/detail?[export_url_vars personnel_id]"
ad_returnredirect $return_url
