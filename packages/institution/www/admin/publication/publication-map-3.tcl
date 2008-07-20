ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id    $Id: publication-map-3.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {publication_id:multiple,notnull}
    {personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

# require 'create' to create new publication-personnel map
permission::require_permission -object_id $package_id -privilege "create"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] [list [set subsite_url]institution/publication/publication-map?[export_vars publication_id] "Personnel Map Search "] [list [set subsite_url]institution/publication/publication-map-2?[export_vars {publication_id}] "Personnel Map Results "] "Personnel Map Warning"]]

set person_check 0
set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]

set publication_titles ""
foreach publication $publication_id {
    db_0or1row group_name "select title from inst_publications where publication_id = :publication" 
    append publication_titles "$title "
}

set warning_text "Warning, you about to associate $first_names $last_name with the publication(s) $publication_titles"

ad_form -name {personnel_publication_map} -form {
    {warning:text(inform) {label "Warning"} {value $warning_text}}
} -export {personnel_id publication_id} -action {publication-map-4} -method {post}
