ad_library {
    Page caching for institutions
    @author KH
    @cvs-id $Id: page-cache-institution-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
    @creation-date 2006-02-08
}

namespace eval inst::pg_cache::inst {} 
namespace eval inst::pg_cache::inst::phys_srch {} 

ad_proc -public inst::pg_cache::inst::phys_srch::refresh_time {} {
    return 1800
}

ad_proc -public inst::pg_cache::inst::phys_srch::possible_categoriess {-parent_category_name} {
    Return possible categories 
} {
    set result_list [util_memoize "inst::pg_cache::inst::phys_srch::possible_categories -parent_category_name {$parent_category_name}" [refresh_time]]
    return result_list
}

ad_proc -public inst::pg_cache::inst::phys_srch::possible_categories_nocache {-parent_category_name} {
    Return possible categories
} {
    return [db_list_of_lists possible_categories {}]
}

ad_proc -public inst::pg_cache::inst::phys_srch::clinical_interests {} {
    return clinical interest list
} {
    set result_list [util_memoize "inst::pg_cache::inst::phys_srch::clinical_interests_nocache" [refresh_time]]
    return $result_list
}

ad_proc -public inst::pg_cache::inst::phys_srch::clinical_interests_nocache {} {
    return clinical interest list
} {
    return [db_list_of_lists clinical_interests {}]
}

ad_proc -public inst::pg_cache::inst::phys_srch::child_categories {} {
    return child categories
} {
    return [util_memoize "inst::pg_cache::inst::phys_srch::child_categories_nocache" [refresh_time]]
}

ad_proc -public inst::pg_cache::inst::phys_srch::child_categories_nocache {} {
    return child categories
} {
    return [db_list_of_lists child_categories {}]
}

ad_proc -public inst::pg_cache::inst::phys_srch::possible_lang {} {
    return possible languages
} {
    set result_list [util_memoize "inst::pg_cache::inst::phys_srch::possible_lang_nocache" [refresh_time]]
    return $result_list
}

ad_proc -public inst::pg_cache::inst::phys_srch::possible_lang_nocache {} {
    return possible langauges
} {
    return [db_list_of_lists possible_languages {**SQL**}]
}
