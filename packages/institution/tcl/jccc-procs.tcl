# /packages/institution/tcl/jccc-procs.tcl

ad_library {
    
    JCCC Helper Procedures

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/11/07
    @cvs-id $Id: jccc-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
    
    @inst::jccc::member_p
}

namespace eval inst::jccc {}

ad_proc -private inst::jccc::group_id {} {
    Return the JCCC group_id
} {
    return [db_string jccc_group_lookup {}]
}

ad_proc -public inst::jccc::group_p {
    {-group_id:required}
} {
    Returns 1 if the group passed in a JCCC group
    Return 0 if the group is not
} {
    set jccc_group_id [inst::jccc::group_id]
    set jccc_group_list [db_list jccc_group_list {}]
    if {[lsearch $jccc_group_list $group_id] != -1} {
	return 1
    } else {
	return 0
    }
}

ad_proc -public inst::jccc::member_p {
    {-personnel_id:required}
} {
    Returns 1 if the personnel is a member of a JCCC group
    Returns 0 if the personnel is not
} {
    set jccc_group_id [inst::jccc::group_id]
    set jccc_member_p [group::member_p -user_id $personnel_id -group_id $jccc_group_id -cascade]
    if {$jccc_member_p} {
	return 1
    } else {
	return 0
    }
}

ad_proc -public inst::jccc::personnel_delete {
    {-personnel_id:required} 
} {
    Deletes personnel from jccc_personnel table
} {
    db_dml jccc_personnel_delete {} 
    return
}
