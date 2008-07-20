# packages/acs-content-repository/tcl/content-extlink-procs.tcl 

ad_library {
    
    Procedures for content_extlink
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2004-06-09
    @arch-tag: f8f62c6c-bf3b-46d9-8e1e-fa5e60ba1c05
    @cvs-id $Id: content-extlink-procs.tcl,v 1.6 2005-12-14 15:29:26 eduardop Exp $
}

namespace eval ::content::extlink {}

ad_proc -public content::extlink::copy {
    -extlink_id:required
    -target_folder_id:required
    -creation_user:required
    {-creation_ip ""}
} {
    @param extlink_id extlink to copy
    @param target_folder_id folder to copy extlink into
    @param creation_user 
    @param creation_ip
    @return 0
} {
    return [package_exec_plsql -var_list [list \
        [list extlink_id $extlink_id ] \
        [list target_folder_id $target_folder_id ] \
        [list creation_user $creation_user ] \
        [list creation_ip $creation_ip ] \
    ] content_extlink copy]
}

ad_proc -public content::extlink::new {
    {-extlink_id ""}
    -url:required
    -parent_id:required
    {-name ""}
    {-label ""}
    {-description ""}
    {-package_id ""}
} {
    @param Create a new external link.
    @return 0
} {
    return [package_exec_plsql -var_list [list \
        [list extlink_id $extlink_id ] \
        [list url $url ] \
        [list parent_id $parent_id ] \
        [list name $name ] \
        [list label $label ] \
        [list description $description ] \
        [list package_id $package_id ] \
    ] content_extlink new]
}


ad_proc -public content::extlink::delete {
    -extlink_id:required
} {
    @param extlink_id item_id of extlink to delete
    @return 0
} {
    return [package_exec_plsql -var_list [list \
        [list extlink_id $extlink_id ] \
    ] content_extlink del]
}


ad_proc -public content::extlink::is_extlink {
    -item_id:required
} {
    @param item_id item_id to check

    @return 1 if extlink, otherwise 0
} {
    return [package_exec_plsql -var_list [list \
        [list item_id $item_id ] \
    ] content_extlink is_extlink]
}

ad_proc -public content::extlink::name {
    -item_id:required
} {
    Returns the name of an extlink

    @item_id  The object id of the item to check.
} {
    return [db_string get {}]
}
