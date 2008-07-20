# /packages/institution/www/admin/publicaton/publication-map-delete-all.tcl copied from publication-map-delete.tcl

ad_page_contract {
    @author   nick@ucla.edu
    @author   modified by David@ctrl.ucla.edu 07/27/2006
    @creation-date    2004/02/09
    @cvs-id $Id: publication-map-delete-all.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
    {publication_ids:optional ""}
}

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id	[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]
set return_url "${subsite_url}institution/admin/personnel/detail?[export_url_vars personnel_id]"

# require 'delete' to delete new personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set context_bar	[ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Personnel Publication Unassociate"]]

set person_exists_p [db_0or1row person_exist {}]

set ix 0
set iy 0
set warning_text ""
set pub_title ""
set warning_list ""
set publication_ids1 [split $publication_ids ","]

foreach del_item $publication_ids1 {
    if {[llength $del_item] > 0} {
	set publication_exists_p [db_0or1row get_publication_title {}]
	if {$publication_exists_p} {
	incr iy
	}
	incr ix
	append warning_list $iy 
	append warning_list ".&nbsp;&nbsp;"
	append warning_list $pub_title
	append warning_list "<br>"
    }
}

if {!$person_exists_p} {
    ad_return_error "Error" "This personnel does not exist"
    ad_script_abort
    return
} elseif {$ix > $iy} {
    # This should never happen, but in case it does...
    ad_return_error "Error" "Some of publications belonging to <i>$first_names $last_name</i> which you are trying to remove does not exist.<br>$ix > $iy"
    ad_script_abort
    return
}

set title "Unassociating $first_names $last_name from the publication $pub_title"
set warning_text "<b>You are about to UNASSOCIATE $first_names $last_name from following publications:</b><br><br>$warning_list" 
ad_form -name {publication_personnel_delete_all} -form {
    {warning:text(inform)  {label "Warning:"} {value $warning_text}}
    {publication_ids1:text(hidden) {value $publication_ids1}}
    {submit_btn:text(submit) {label "Confirm Deletion"}}
} -on_submit {
    foreach del_item $publication_ids1 {
    if {[llength $del_item] > 0} {
	set delete_error 0
	set publication_id $del_item
	db_transaction {
	    db_dml delete_publication_personnel_subsets {}
	    db_dml delete_publication_maps {}
	    inst::access::update_publication_to_null_for_personnel -personnel_id $personnel_id -publication_id $publication_id
	    arr::profile::publication_remove -publication_id $publication_id -personnel_id $personnel_id
	    set publication_map_exists_p [db_string publication_personnel_map_exists_p {}]
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
    }
    }
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -export {personnel_id publication_id}
