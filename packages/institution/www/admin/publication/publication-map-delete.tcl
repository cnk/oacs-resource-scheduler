# -*- tab-width: 8 -*-
# /packages/institution/www/admin/publicaton/publication-map-delete.tcl

ad_page_contract {
    @author   nick@ucla.edu
    @creation-date    2004/02/09
    @cvs-id $Id: publication-map-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:integer,notnull}
    {publication_id:integer,notnull}
}

#########################NEED TO CHECK DELETE PERMISSION HERE#################
set user_id	[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

# require 'delete' to delete new personnel
permission::require_permission -object_id $personnel_id -privilege "delete"

set context_bar	[ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Personnel Publication Unassociate"]]

set person_exists_p [db_0or1row person_exist {
    select	first_names,
		last_name
      from	persons
     where	person_id = :personnel_id
}]

set publication_exists_p [db_0or1row get_publication_title {
    select title as pub_title
      from inst_publications
     where publication_id = :publication_id
}]

if {!$person_exists_p} {
    ad_return_error "Error" "This personnel does not exist"
    ad_script_abort
    return
} elseif {!$publication_exists_p} {
    # This should never happen, but in case it does...
    ad_return_error "Error" "The publication belonging to <i>$first_names $last_name</i> which you are trying to remove does not exist."
    ad_script_abort
    return
}

set title "Unassociating $first_names $last_name from the publication $pub_title"
set warning_text "<b>You are about to UNASSOCIATE $first_names $last_name from the publication:</b><br><br>$pub_title" 

ad_form -name {publication_personnel_delete} -form {
	{warning:text(inform)  {label "Warning:"} {value $warning_text}}
} -export {personnel_id publication_id} -action {publication-map-delete-2} -method {post}
