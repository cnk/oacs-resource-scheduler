ad_library {
    Page caching procs for access subsite 

    @author KH
    @cvs-id $Id: page-cache-access-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
    @creation-date 2006-02-07
}

namespace eval inst::pg_cache::access {}

ad_proc -public inst::pg_cache::access::refresh_time {} {
    Returns the caching time 
} {
    return 1800
}

ad_proc -public inst::pg_cache::access::get_possible_lang {} {
    Retrieve the list off possible languages 
} {
    set result_list [util_memoize "inst::pg_cache::access::get_possible_lang_nocache" [refresh_time]]
    return $result_list
}

ad_proc -private inst::pg_cache::access::get_possible_lang_nocache {} {
    Return the list of all languages
} {
    return [db_list_of_lists possible_languages {**SQL**}]
}

ad_proc -private inst::pg_cache::access::subsite_groups {-subsite_id} {
    return [util_memoize "inst::pg_cache::access::subsite_groups_nocache -subsite_id $subsite_id" [refresh_time]]
}

ad_proc -private inst::pg_cache::access::subsite_groups_nocache {-subsite_id} {
    return the list of subgroups for listing
} {
    set subsite_groups [db_list_of_lists subsite_groups {}]
    return $subsite_groups
}
