# /packages/acs4x/tcl/acs-object-procs.tcl

ad_library {

    Utility procs to help with ACS Objects
    
    @creation-date 2004/12/3
    @cvs-id $Id: acs-object-procs.tcl 2 2005-04-09 03:47:05Z avni $
}

namespace eval ctrl_procs::acs_object {}

ad_proc -public ctrl_procs::acs_object::update_object {
    {-object_id:required}
    {-modifying_user ""}
    {-modifying_ip ""}
} {
    Update the acs_objects last_modified_date, user, and ip
} {
    if [empty_string_p $modifying_user] {
	set modyfing_user [ad_conn user_id]
    }

    if [empty_string_p $modifying_ip] {
	set modifying_ip [ad_conn peeraddr]
    }
    set error_p 0
    
    db_transaction {
	db_exec_plsql update {}
    } on_error {
	set error_p 1
    }
    
    if {$error_p} {
	ad_return_complaint 1 "There was a problem updating the acs_object -- $errmsg"
	ad_script_abort
    }
}
 
