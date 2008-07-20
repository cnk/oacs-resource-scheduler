ad_page_contract {
	@author	  nick@ucla.edu
	@creation-date	  2004/01/28
	@cvs-id $Id: personnel-group-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:integer,notnull}
	{group_id:integer,notnull}
	{title_id:integer ""}
	{return_url [get_referrer]}
}

# require 'delete' to delete personnel-titles
# //TODO// check permission on gpm_title_id's, not personnel_id
permission::require_permission -object_id $personnel_id -privilege "delete"

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

set person_check 0
set person_check [db_0or1row person_exist "select first_names, last_name from persons where person_id = :personnel_id"]

db_0or1row get_group_name "select short_name, name from inst_groups, categories where group_id = :group_id and category_id = group_type_id"

set group_type_name ""
if {![empty_string_p $title_id]} {
	set group_type_name [db_string get_group_type_name "select name from categories where category_id = :title_id"]
}

set title "Unassociating $first_names $last_name from $name $short_name"
if {!$person_check} {
	ad_return_complaint 1 "This personnel does not exist"
	return
} else {
	set warning_text "Warning, you are about to UNASSOCIATE $first_names $last_name from $group_type_name $short_name" 
	ad_form -name personnel_group_delete \
		-export {
			personnel_id
			group_id
			title_id
			return_url
		} \
		-form {
			{warning:text(inform)
				{label "Warning"}
				{value $warning_text}
			}
		} -action {personnel-group-delete-2} -method {post}
}
