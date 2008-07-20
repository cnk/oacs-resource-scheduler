# /packages/institution/tcl/access-procs.tcl

ad_library {
    
    ACCESS Helper Procedures

    @author avni@ctrl.ucla.edu
    @creation-date 2005/03/01
    @cvs-id $Id: access-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
    
    @inst::access::selected_publication_delete
}

namespace eval inst::access {}

ad_proc -private inst::access::update_publication_to_null {
    {-publication_id:required}
} {
    Updates the passed in publication_id in access_personnel to null
} {
    db_dml access_update_selected_publication_one_to_null {}
    db_dml access_update_selected_publication_two_to_null {}
    db_dml access_update_selected_publication_three_to_null {}
    return
}

ad_proc -private inst::access::update_publication_to_null_for_personnel {
    {-personnel_id:required} 
    {-publication_id:required}
} {
    Updates the access selected publication_id for the personnel_id passed in to be null
} {
    db_dml access_selected_publication_one_to_null {} 
    db_dml access_selected_publication_two_to_null {} 
    db_dml access_selected_publication_three_to_null {} 
    return
}
