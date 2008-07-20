ad_page_contract {
    @author   nick@ucla.edu
    @creation-date    2004/01/14
    @cvs-id $Id: faculty-delete-2.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
    {return_addr:trim,optional "detail?[export_vars personnel_id]"}
}

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node::get_url -node_id [ad_conn subsite_id]]

# require 'delete' to delete personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set person_check 0
set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]

set personnel_error 0

if {!$person_check} {
    #ad_return_complaint 1 "This personnel does not exist"
    #return
    # continue on cuz person already not in the system
} else {
    set personnel_error 0
    db_transaction {
	db_dml faculty_delete "delete from inst_faculty where faculty_id = :personnel_id"
    } on_error {
	set personnel_error 1
	db_abort_transaction
    }
    if {$personnel_error} {
	ad_return_complaint 1 "Faculty NOT DELETED PROPERLY - $errmsg"
	return 0
    }
    

}

ad_returnredirect "$return_addr"
