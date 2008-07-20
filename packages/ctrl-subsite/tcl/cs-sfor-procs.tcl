# /packages/ctrl-subsite/tcl/cs-sfor-procs.tcl

ad_library {
    
    Procs to map subsite object rels
    
    @creation-date 4/16/2007
    @author avni@ctrl.ucla.edu (AK)
    @cvs_id $id$
}

namespace eval ctrl::subsite {}

ad_proc -public ctrl::subsite::object_rel_new {
    {-subsite_id:required}
    {-object_id:required}
} {
    Create a new subsite object relationship mapping
} {
    set error_p 0
    db_transaction {
	set rel_id [db_exec_plsql subsite_object_rel_new {}]
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	return -1
    } else {
	return $rel_id
    }    
}

ad_proc -public ctrl::subsite::object_rel_del {
    {-object_id:required}
} {
    Delete all subsite object relationships where the object_id
    is equal to the object_id passed in
} {
    set error_p 0
    db_transaction {
	db_exec_plsql subsite_object_rel_del {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }

    if {$error_p} {
	return -1
    } else {
	return 0
    }    
}
