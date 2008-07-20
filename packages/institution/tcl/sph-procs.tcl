# /packages/institution/tcl/sph-procs.tcl

ad_library {
    
    SPH Helper Procedures

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/11/07
    @cvs-id $Id: sph-procs.tcl,v 1.1 2006/09/29 16:27:20 kellie Exp $
    
    @inst::sph::member_p
}

namespace eval inst::sph {}

ad_proc -private inst::sph::group_id {} {
    Return the SPH group_id
} {
    return [db_string sph_group_lookup {}]
}

ad_proc -public inst::sph::group_p {
    {-group_id:required}
} {
    Returns 1 if the group passed in a SPH group
    Return 0 if the group is not
} {
    set sph_group_id [inst::sph::group_id]
    set sph_group_list [db_list sph_group_list {}]
    if {[lsearch $sph_group_list $group_id] != -1} {
	return 1
    } else {
	return 0
    }
}

ad_proc -public inst::sph::member_p {
    {-personnel_id:required}
} {
    Returns 1 if the personnel is a member of a SPH group
    Returns 0 if the personnel is not
} {
    set sph_group_id [inst::sph::group_id]
    set sph_member_p [group::member_p -user_id $personnel_id -group_id $sph_group_id -cascade]
    if {$sph_member_p} {
	return 1
    } else {
	return 0
    }
}

ad_proc -public inst::sph::personnel_delete {
    {-personnel_id:required} 
} {
    Deletes personnel from sph_personnel table
} {
    db_dml sph_personnel_delete {} 
    return
} 

ad_proc -public inst::sph::category_list {
    {-parent_category_id:required}
} {
    set category_list [db_list_of_lists get_category_list {}]
    return $category_list
}
