# /packages/institution/www/admin/publication-map.tcl

ad_page_contract {
    @author    nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id $Id: publication-map.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {publication_id:integer}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

# require 'create' to create new publication-personnel map
permission::require_permission -object_id $package_id -privilege "create"

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/publication/ "Publication Index"] "Personnel Publication Associate"]]

set title "Personnel Publication Map Search"
################################################################################
# SET UP SELECT OPTIONS
################################################################################
set no_preference "(No Preference)"

##############################################################################
###############NEED TO DYNAMICALLY CREATE SELECTS FOR ALL THE DIFFERENT GROUPS
##############################################################################
set dept_options [db_list_of_lists get_departments {select short_name, group_id from inst_groups where group_type_id = (select category_id from categories where lower(name) = 'department')}]
set dept_options [linsert $dept_options 0 [list $no_preference]]

################################################################################
# the search form
################################################################################
set ltr_index [list]
foreach ltr {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} {
    lappend ltr_index "<a href='search-result?letter=$ltr'>$ltr</a>"
}
set letter_index [join $ltr_index "&nbsp;"]

ad_form -name search_personnel -action {publication-map-2} -method {post} -form {
    {combine_method:integer(select),optional	{label ""}	         {options {{"All" 0} {"Any" 1}}} {value 0}}
    {employee_id:integer,optional               {label "UCLA Employee ID"}}
    {first_name:text,optional                   {label "First Name"}}
    {last_names:text,optional                   {label "Last Name"}}
    {dept:text(select),optional                 {label "Deptartment"} {options $dept_options}}
    {search:text(submit)                        {label "Search"}}    

} -export {publication_id}


