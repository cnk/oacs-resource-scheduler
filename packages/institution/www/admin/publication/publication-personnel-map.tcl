ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/23
    @cvs-id    $Id: publication-personnel-map.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]
# require 'create' to create new publication-personnel map
permission::require_permission -object_id $package_id -privilege "create"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Personnel Publication Associate"]]

set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]
set title "Select the following publication(s) to associate with $first_names $last_name"

set publication_options [db_list_of_lists get_pub_options {
    select substr(title,0,100) as title, publication_id 
    from   inst_publications 
    where  publication_id not in (select publication_id from inst_personnel_publication_map where personnel_id = :personnel_id)
    order  by title asc
}]

set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]
ad_form -name {personnel_publication_map_2} -form {
    {publication_id:integer(multiselect) {label "Publication"} {options $publication_options} {html {size 35}}}
} -export {personnel_id} -action {publication-map-3} -method {post}
